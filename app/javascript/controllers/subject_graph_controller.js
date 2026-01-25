import { Controller } from "@hotwired/stimulus"
import cytoscape from "cytoscape"
import cytoscapeDagre from "cytoscape-dagre"

// Register the dagre layout extension
if (typeof cytoscape.use === "function") {
  cytoscape.use(cytoscapeDagre)
}

export default class extends Controller {
  static values = {
    nodes: Array,
    edges: Array
  }

  connect() {
    this.cy = cytoscape({
      container: this.element,
      elements: this.buildElements(),
      layout: {
        name: "dagre",
        rankDir: "TB",
        nodeSep: 50,
        rankSep: 80
      },
      style: [
        {
          selector: "node",
          style: {
            "label": "data(label)",
            "text-wrap": "wrap",
            "text-max-width": "100px",
            "background-color": "#6b7280",
            "color": "#fff",
            "text-valign": "center",
            "text-halign": "center",
            "padding": "10px",
            "shape": "round-rectangle",
            "width": "label",
            "height": "label",
            "font-size": "12px"
          }
        },
        {
          // Blue for available (can take now)
          selector: "node[?available]",
          style: { "background-color": "#3b82f6" }
        },
        {
          // Green for completed (all approvables approved)
          selector: "node[?completed]",
          style: { "background-color": "#22c55e" }
        },
        {
          selector: "edge",
          style: {
            "width": 2,
            "line-color": "#d1d5db",
            "target-arrow-color": "#d1d5db",
            "target-arrow-shape": "triangle",
            "curve-style": "bezier"
          }
        }
      ]
    })

    this.cy.on("tap", "node", (evt) => {
      const url = evt.target.data("url")
      if (url) Turbo.visit(url)
    })

    // Store reference for testing
    this.element.__cytoscape = this.cy
  }

  buildElements() {
    const nodes = this.nodesValue.map(n => ({
      data: {
        id: n.id.toString(),
        label: `${n.code}\n${n.name}`,
        url: n.url,
        available: n.available,
        completed: n.completed
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
    this.cy?.destroy()
  }
}
