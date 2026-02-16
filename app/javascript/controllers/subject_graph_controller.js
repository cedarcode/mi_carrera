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
    const mobile = this.isMobile
    const groups = this.groupBySemester()
    const positions = mobile
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
      style: this.buildStyles(mobile)
    })

    this.headerEls = []

    if (mobile) {
      this.cy.zoom(1)
      // Pan so graph starts at the top of the container
      const bb = this.cy.elements().boundingBox()
      this.cy.pan({ x: -bb.x1 + 16, y: -bb.y1 + 10 })
      this.cy.userPanningEnabled(true)
      this.cy.userZoomingEnabled(false)
      this.cy.boxSelectionEnabled(false)
    } else {
      this.cy.fit(undefined, 40)
    }

    this.buildSemesterNodeGroups()
    this.createHeaders(mobile)
    this.cy.on("pan zoom", () => this.positionHeaders())

    this.cy.on("tap", "node", (evt) => {
      const url = evt.target.data("url")
      if (url) Turbo.visit(url)
    })

    // Store reference for testing
    this.element.__cytoscape = this.cy
  }

  groupBySemester() {
    const groups = new Map()
    for (const n of this.nodesValue) {
      const sem = n.semester ?? 0
      if (!groups.has(sem)) groups.set(sem, [])
      groups.get(sem).push(n)
    }
    // Return sorted by semester number
    return new Map([...groups.entries()].sort((a, b) => a[0] - b[0]))
  }

  calculateDesktopPositions(groups) {
    const colWidth = 160
    const nodeHeight = 45
    const nodeGapY = 15
    const topPadding = 40 // space for semester headers

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
    const semGap = 44 // gap between semester sections (includes header space)

    const positions = {}
    let y = semGap // start with space for first header

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
          "cursor": "pointer"
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
      {
        selector: "edge",
        style: {
          "width": 1.5,
          "line-color": "#cbd5e1",
          "target-arrow-color": "#cbd5e1",
          "target-arrow-shape": "triangle",
          "arrow-scale": 0.8,
          "curve-style": "bezier",
          "opacity": 0.6
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
      header.style.position = "absolute"
      header.style.pointerEvents = "none"
      header.style.fontWeight = "600"
      header.style.whiteSpace = "nowrap"
      header.style.zIndex = "10"
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

      // Use cytoscape's rendered bounding boxes for accurate positioning
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
    this.cy?.destroy()
  }
}
