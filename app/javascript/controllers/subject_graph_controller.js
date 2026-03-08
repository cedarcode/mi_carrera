import { Controller } from "@hotwired/stimulus"
import cytoscape from "cytoscape"

export default class extends Controller {
  static values = {
    nodes: Array,
    edges: Array,
    semesterLabels: Object
  }

  get isMobile() {
    return window.innerWidth < 640
  }

  connect() {
    this.mobile = this.isMobile
    const groups = this.groupBySemester()
    const positions = this.mobile
      ? this.calculateMobilePositions(groups)
      : this.calculateDesktopPositions(groups)

    this.cy = cytoscape({
      container: this.element,
      elements: this.buildElements(),
      layout: {
        name: "preset",
        positions: (node) => positions[node.id()] || { x: 0, y: 0 },
        fit: false
      },
      minZoom: 0.3,
      maxZoom: 3,
      autoungrabify: true,
      style: this.buildStyles(this.mobile)
    })

    this.headerEls = []
    this.selectedNode = null
    this.tooltipEl = null

    if (this.mobile) {
      this.cy.zoom(1)
      const bb = this.cy.elements().boundingBox()
      this.cy.pan({ x: -bb.x1 + 16, y: -bb.y1 + 10 })
      this.cy.userPanningEnabled(true)
      this.cy.userZoomingEnabled(false)
      this.cy.boxSelectionEnabled(false)
    } else {
      this.cy.fit(undefined, 40)
    }

    this.buildSemesterNodeGroups()
    this.createHeaders(this.mobile)
    this.cy.on("pan zoom", () => {
      this.positionHeaders()
      this.positionTooltip()
    })

    this.cy.on("tap", "node", (evt) => this.handleNodeTap(evt.target))
    this.cy.on("tap", (evt) => {
      if (evt.target === this.cy) this.clearSelection()
    })

    if (!this.mobile) {
      this.cy.on("mouseover", "node", (evt) => {
        if (!this.selectedNode) {
          evt.target.addClass("hovered")
          this.highlightConnected(evt.target, true)
        }
      })
      this.cy.on("mouseout", "node", (evt) => {
        if (!this.selectedNode) {
          evt.target.removeClass("hovered")
          this.clearHighlight()
        }
      })
    }

    this.boundResize = this.handleResize.bind(this)
    window.addEventListener("resize", this.boundResize)

    // Store reference for testing
    this.element.__cytoscape = this.cy
  }

  handleNodeTap(node) {
    if (this.selectedNode && this.selectedNode.id() === node.id()) {
      // Second tap on same node: navigate
      const url = node.data("url")
      if (url) window.Turbo?.visit(url)
      return
    }

    this.clearSelection()
    this.selectedNode = node
    node.addClass("selected")
    this.highlightConnected(node, false)
    this.showTooltip(node)
  }

  highlightConnected(node, hoverOnly) {
    const predecessors = node.predecessors()
    const successors = node.successors()
    const connected = predecessors.union(successors).union(node)

    if (hoverOnly) {
      predecessors.nodes().addClass("predecessor-hover")
      successors.nodes().addClass("successor-hover")
      predecessors.edges().addClass("highlighted-edge")
      successors.edges().addClass("highlighted-edge")
      return
    }

    // Full selection: dim everything, then highlight chain
    this.cy.elements().addClass("dimmed")
    connected.removeClass("dimmed")
    predecessors.nodes().addClass("predecessor")
    successors.nodes().addClass("successor")
    predecessors.edges().addClass("highlighted-edge")
    successors.edges().addClass("highlighted-edge")
    node.removeClass("dimmed")
  }

  clearHighlight() {
    this.cy.elements().removeClass("predecessor-hover successor-hover highlighted-edge")
  }

  clearSelection() {
    if (!this.selectedNode) return
    this.selectedNode.removeClass("selected")
    this.selectedNode = null
    this.cy.elements().removeClass("dimmed predecessor successor predecessor-hover successor-hover highlighted-edge selected")
    this.removeTooltip()
  }

  showTooltip(node) {
    this.removeTooltip()

    const tooltip = document.createElement("div")
    tooltip.className = "graph-tooltip"

    const name = node.data("label").replace("\n", " - ")
    const url = node.data("url")

    tooltip.innerHTML = `
      <span class="graph-tooltip-text">${name}</span>
      <a href="${url}" class="graph-tooltip-link" data-turbo-action="advance">Ver detalles →</a>
    `

    // Stop mouse/touch events from reaching Cytoscape's canvas
    tooltip.addEventListener("mousedown", (e) => e.stopPropagation())
    tooltip.addEventListener("touchstart", (e) => e.stopPropagation())
    tooltip.addEventListener("pointerdown", (e) => e.stopPropagation())

    // Append to document body so it renders above the Cytoscape canvas
    document.body.appendChild(tooltip)
    this.tooltipEl = tooltip
    this.tooltipNode = node
    this.positionTooltip()
  }

  positionTooltip() {
    if (!this.tooltipEl || !this.tooltipNode) return

    const rbb = this.tooltipNode.renderedBoundingBox()
    const centerX = (rbb.x1 + rbb.x2) / 2
    const bottomY = rbb.y2

    // Convert from Cytoscape container-relative to viewport coordinates
    const containerRect = this.element.getBoundingClientRect()

    this.tooltipEl.style.left = `${containerRect.left + centerX}px`
    this.tooltipEl.style.top = `${containerRect.top + bottomY + 8}px`
  }

  removeTooltip() {
    if (this.tooltipEl) {
      this.tooltipEl.remove()
      this.tooltipEl = null
      this.tooltipNode = null
    }
  }

  handleResize() {
    clearTimeout(this.resizeTimer)
    this.resizeTimer = setTimeout(() => {
      const wasMobile = this.mobile
      this.mobile = this.isMobile

      if (wasMobile !== this.mobile) {
        // Layout mode changed, rebuild
        this.clearSelection()
        this.headerEls.forEach(el => el.remove())
        this.headerEls = []

        const groups = this.groupBySemester()
        const positions = this.mobile
          ? this.calculateMobilePositions(groups)
          : this.calculateDesktopPositions(groups)

        this.cy.style(this.buildStyles(this.mobile))
        this.cy.nodes().forEach(node => {
          const pos = positions[node.id()]
          if (pos) node.position(pos)
        })

        if (this.mobile) {
          this.cy.zoom(1)
          const bb = this.cy.elements().boundingBox()
          this.cy.pan({ x: -bb.x1 + 16, y: -bb.y1 + 10 })
          this.cy.userZoomingEnabled(false)
        } else {
          this.cy.userZoomingEnabled(true)
          this.cy.fit(undefined, 40)
        }

        this.createHeaders(this.mobile)
      }
    }, 200)
  }

  groupBySemester() {
    const groups = new Map()
    for (const n of this.nodesValue) {
      const sem = n.semester ?? 0
      if (!groups.has(sem)) groups.set(sem, [])
      groups.get(sem).push(n)
    }
    return new Map([...groups.entries()].sort((a, b) => a[0] - b[0]))
  }

  calculateDesktopPositions(groups) {
    const colWidth = 160
    const nodeHeight = 45
    const nodeGapY = 15
    const topPadding = 40

    const positions = {}
    let col = 0

    for (const [, nodes] of groups) {
      const x = col * colWidth + colWidth / 2
      for (let i = 0; i < nodes.length; i++) {
        const y = topPadding + i * (nodeHeight + nodeGapY) + nodeHeight / 2
        positions[nodes[i].id.toString()] = { x, y }
      }
      col++
    }

    return positions
  }

  calculateMobilePositions(groups) {
    const nodesPerRow = 2
    const containerW = window.innerWidth
    const padding = 16
    const gapX = 14
    const nodeW = Math.floor((containerW - padding * 2 - gapX) / nodesPerRow)
    const nodeH = 42
    const rowGap = 14
    const semGap = 44

    const positions = {}
    let y = semGap

    for (const [, nodes] of groups) {
      for (let i = 0; i < nodes.length; i++) {
        const col = i % nodesPerRow
        const row = Math.floor(i / nodesPerRow)
        positions[nodes[i].id.toString()] = {
          x: padding + col * (nodeW + gapX) + nodeW / 2,
          y: y + row * (nodeH + rowGap) + nodeH / 2
        }
      }
      const rowsInSemester = Math.ceil(nodes.length / nodesPerRow)
      y += rowsInSemester * (nodeH + rowGap) + semGap
    }

    return positions
  }

  buildStyles(mobile) {
    const fontSize = mobile ? "11px" : "12px"
    const nodeWidth = mobile ? Math.floor((window.innerWidth - 32 - 14) / 2) : 130
    const nodeHeight = mobile ? 42 : 45
    const textMaxWidth = mobile ? `${nodeWidth - 10}px` : "120px"

    return [
      {
        selector: "node",
        style: {
          "label": "data(label)",
          "text-wrap": "wrap",
          "text-max-width": textMaxWidth,
          "background-color": "#6b7280",
          "color": "#fff",
          "text-valign": "center",
          "text-halign": "center",
          "padding": "0px",
          "shape": "round-rectangle",
          "width": nodeWidth,
          "height": nodeHeight,
          "font-size": fontSize,
          "cursor": "pointer",
          "border-width": 0,
          "border-color": "#000",
          "transition-property": "background-color, border-width, border-color, opacity",
          "transition-duration": "0.15s"
        }
      },
      {
        selector: "node[?available]",
        style: { "background-color": "#3b82f6" }
      },
      {
        selector: "node[?completed]",
        style: { "background-color": "#22c55e" }
      },
      // Hover: subtle border
      {
        selector: "node.hovered",
        style: { "border-width": 2, "border-color": "#1d4ed8" }
      },
      // Selected node: bold border
      {
        selector: "node.selected",
        style: { "border-width": 3, "border-color": "#1e293b" }
      },
      // Dimmed (unrelated to selection)
      {
        selector: ".dimmed",
        style: { "opacity": 0.2 }
      },
      // Predecessor chain highlight (upstream)
      {
        selector: "node.predecessor",
        style: { "border-width": 2, "border-color": "#f59e0b" }
      },
      // Successor chain highlight (downstream)
      {
        selector: "node.successor",
        style: { "border-width": 2, "border-color": "#8b5cf6" }
      },
      // Hover-only highlights (lighter)
      {
        selector: "node.predecessor-hover",
        style: { "border-width": 2, "border-color": "#fbbf24" }
      },
      {
        selector: "node.successor-hover",
        style: { "border-width": 2, "border-color": "#a78bfa" }
      },
      // Edges
      {
        selector: "edge",
        style: {
          "width": 1.5,
          "line-color": "#cbd5e1",
          "target-arrow-color": "#cbd5e1",
          "target-arrow-shape": "triangle",
          "arrow-scale": 0.8,
          "curve-style": "bezier",
          "opacity": 0.6,
          "transition-property": "line-color, target-arrow-color, width, opacity",
          "transition-duration": "0.15s"
        }
      },
      // Highlighted edges (connected to selection/hover)
      {
        selector: "edge.highlighted-edge",
        style: {
          "line-color": "#64748b",
          "target-arrow-color": "#64748b",
          "width": 2.5,
          "opacity": 1
        }
      }
    ]
  }

  buildSemesterNodeGroups() {
    this.semesterNodeGroups = new Map()
    this.cy.nodes().forEach(node => {
      const sem = node.data("semester")
      if (!this.semesterNodeGroups.has(sem)) this.semesterNodeGroups.set(sem, [])
      this.semesterNodeGroups.get(sem).push(node)
    })
  }

  createHeaders(mobile) {
    for (const [sem] of [...this.semesterNodeGroups.entries()].sort((a, b) => a[0] - b[0])) {
      const label = this.semesterLabelsValue[sem.toString()] || `Semestre ${sem}`

      const header = document.createElement("div")
      header.textContent = label
      header.className = "graph-semester-header"
      header.style.color = mobile ? "#374151" : "#6b7280"
      header.dataset.semester = sem.toString()

      this.element.appendChild(header)
      this.headerEls.push(header)
    }

    this.positionHeaders()
  }

  positionHeaders() {
    if (!this.cy || !this.semesterNodeGroups) return

    const zoom = this.cy.zoom()

    for (const header of this.headerEls) {
      const sem = parseInt(header.dataset.semester)
      const nodes = this.semesterNodeGroups.get(sem)
      if (!nodes || nodes.length === 0) continue

      let minY = Infinity
      let sumX = 0

      for (const node of nodes) {
        const rbb = node.renderedBoundingBox()
        if (rbb.y1 < minY) minY = rbb.y1
        sumX += (rbb.x1 + rbb.x2) / 2
      }

      const avgX = sumX / nodes.length

      header.style.left = `${avgX}px`
      header.style.top = `${minY - 4}px`
      header.style.transform = "translate(-50%, -100%)"
      header.style.fontSize = `${Math.max(10, 13 * zoom)}px`
    }
  }

  buildElements() {
    const nodes = this.nodesValue.map(n => ({
      data: {
        id: n.id.toString(),
        label: `${n.code}\n${n.name}`,
        url: n.url,
        available: n.available,
        completed: n.completed,
        semester: n.semester ?? 0
      }
    }))

    const edges = this.edgesValue.map(e => ({
      data: {
        source: e.source.toString(),
        target: e.target.toString()
      }
    }))

    return [...nodes, ...edges]
  }

  disconnect() {
    if (this.headerEls) {
      this.headerEls.forEach(el => el.remove())
    }
    this.removeTooltip()
    if (this.boundResize) {
      window.removeEventListener("resize", this.boundResize)
    }
    clearTimeout(this.resizeTimer)
    this.cy?.destroy()
  }
}
