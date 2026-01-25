# Subject Dependency Graph Feature Design

## Overview

Add a graph/tree visualization showing subject dependencies. Users can see which subjects unlock others, with visual indicators for availability status.

## Use Cases

1. **Planned subjects graph** (`/planner/graph`): Shows dependencies between subjects in the user's plan
2. **Category-filtered graph** (`/subjects/graph?categories[]=first_semester&categories[]=second_semester`): Shows dependencies for subjects in selected categories/semesters

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  SubjectGraphComponent (ViewComponent)                      │
│  - Accepts: collection of subjects, current_student         │
│  - Outputs: container div with data attributes              │
│  - Passes: nodes (subjects) + edges (prerequisites)         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  subject_graph_controller.js (Stimulus)                     │
│  - Reads data from HTML attributes                          │
│  - Initializes Cytoscape.js with dagre layout               │
│  - Handles node clicks → navigates to subject show page     │
│  - Styles nodes: green (available), default (not available) │
└─────────────────────────────────────────────────────────────┘
```

## Technology Choice

**Cytoscape.js** with **cytoscape-dagre** for hierarchical layout:
- Built-in DAG support with dagre layout algorithm
- Conditional styling (green for available subjects)
- Rich event system for node clicks
- Works well with Stimulus lifecycle
- Active maintenance, excellent documentation

## Routes

```ruby
# config/routes.rb
namespace :planner do
  resource :graph, only: [:show]
end

namespace :subjects do
  resource :graph, only: [:show]
end
```

- `GET /planner/graph` → `Planner::GraphsController#show`
- `GET /subjects/graph?categories[]=first_semester` → `Subjects::GraphsController#show`

## Controllers

### Subjects::GraphsController

```ruby
# app/controllers/subjects/graphs_controller.rb
module Subjects
  class GraphsController < ApplicationController
    def show
      categories = params[:categories] || []

      @subjects = current_degree.subjects
        .where(category: categories)
        .includes(:course, :exam)

      TreePreloader.preload(@subjects)
    end
  end
end
```

### Planner::GraphsController

```ruby
# app/controllers/planner/graphs_controller.rb
module Planner
  class GraphsController < ApplicationController
    def show
      planned_subjects = current_student.user.subject_plans
        .includes(subject: [:course, :exam])
        .map(&:subject)

      TreePreloader.preload(planned_subjects)

      @subjects = planned_subjects
    end
  end
end
```

## ViewComponent

### SubjectGraphComponent

```ruby
# app/components/subject_graph_component.rb
class SubjectGraphComponent < ViewComponent::Base
  def initialize(subjects:, current_student:)
    @subjects = subjects
    @current_student = current_student
  end

  def nodes
    @subjects.map do |subject|
      {
        id: subject.id,
        code: subject.code,
        name: subject.short_name || subject.name,
        url: helpers.subject_path(subject),
        available: @current_student.available?(subject)
      }
    end
  end

  def edges
    subject_ids = Set.new(@subjects.map(&:id))
    edges = []

    @subjects.each do |subject|
      collect_prerequisite_edges(subject.course&.prerequisite_tree, subject.id, subject_ids, edges)
    end

    edges.uniq
  end

  private

  def collect_prerequisite_edges(prerequisite, target_subject_id, subject_ids, edges)
    return unless prerequisite

    case prerequisite
    when SubjectPrerequisite
      source_subject_id = prerequisite.approvable_needed.subject_id
      if subject_ids.include?(source_subject_id)
        edges << { source: source_subject_id, target: target_subject_id }
      end
    when LogicalPrerequisite
      prerequisite.operands_prerequisites.each do |child|
        collect_prerequisite_edges(child, target_subject_id, subject_ids, edges)
      end
    end
  end
end
```

### Template

```erb
<%# app/components/subject_graph_component.html.erb %>
<div
  data-controller="subject-graph"
  data-subject-graph-nodes-value="<%= nodes.to_json %>"
  data-subject-graph-edges-value="<%= edges.to_json %>"
  class="subject-graph-container"
  style="width: 100%; height: 500px;">
</div>
```

## Stimulus Controller

```javascript
// app/javascript/controllers/subject_graph_controller.js
import { Controller } from "@hotwired/stimulus"
import cytoscape from "cytoscape"
import dagre from "cytoscape-dagre"

cytoscape.use(dagre)

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
        name: 'dagre',
        rankDir: 'TB',
        nodeSep: 50,
        rankSep: 80
      },
      style: [
        {
          selector: 'node',
          style: {
            'label': 'data(label)',
            'text-wrap': 'wrap',
            'text-max-width': '100px',
            'background-color': '#6c757d',
            'color': '#fff',
            'text-valign': 'center',
            'padding': '10px'
          }
        },
        {
          selector: 'node[available]',
          style: { 'background-color': '#28a745' }
        },
        {
          selector: 'edge',
          style: {
            'width': 2,
            'line-color': '#ccc',
            'target-arrow-color': '#ccc',
            'target-arrow-shape': 'triangle',
            'curve-style': 'bezier'
          }
        }
      ]
    })

    this.cy.on('tap', 'node', (evt) => {
      const url = evt.target.data('url')
      if (url) Turbo.visit(url)
    })
  }

  buildElements() {
    const nodes = this.nodesValue.map(n => ({
      data: {
        id: n.id.toString(),
        label: `${n.code}\n${n.name}`,
        url: n.url,
        available: n.available || undefined
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
```

## Views

### Planner Graph

```erb
<%# app/views/planner/graphs/show.html.erb %>
<h1>Plan de materias</h1>

<% if @subjects.any? %>
  <%= render SubjectGraphComponent.new(
    subjects: @subjects,
    current_student: current_student
  ) %>
<% else %>
  <p>No tienes materias planificadas. <%= link_to "Agregar materias", planner_path %></p>
<% end %>
```

### Subjects Graph

```erb
<%# app/views/subjects/graphs/show.html.erb %>
<h1>Grafo de dependencias</h1>

<%= render SubjectGraphComponent.new(
  subjects: @subjects,
  current_student: current_student
) %>
```

## Package Dependencies

```bash
yarn add cytoscape cytoscape-dagre
```

## System Tests

### Planner Graph Tests

```ruby
# test/system/planner/graph_test.rb
require "application_system_test_case"

class Planner::GraphTest < ApplicationSystemTestCase
  setup do
    @degree = degrees(:informatica)
    @user = users(:student)
    sign_in @user
  end

  test "displays graph with planned subjects" do
    subject1 = subjects(:calculo1)
    subject2 = subjects(:calculo2)
    SubjectPlan.create!(user: @user, subject: subject1, semester: 1)
    SubjectPlan.create!(user: @user, subject: subject2, semester: 2)

    visit planner_graph_path

    assert_selector "[data-controller='subject-graph']"
    assert_selector "[data-subject-graph-nodes-value]"
  end

  test "shows empty state when no planned subjects" do
    visit planner_graph_path

    assert_text "No tienes materias planificadas"
    assert_link "Agregar materias"
  end

  test "clicking a node navigates to subject page" do
    subject = subjects(:calculo1)
    SubjectPlan.create!(user: @user, subject: subject, semester: 1)

    visit planner_graph_path

    execute_script <<~JS
      const cy = document.querySelector('[data-controller="subject-graph"]').__cytoscape;
      cy.nodes().first().emit('tap');
    JS

    assert_current_path subject_path(subject)
  end
end
```

### Subjects Graph Tests

```ruby
# test/system/subjects/graph_test.rb
require "application_system_test_case"

class Subjects::GraphTest < ApplicationSystemTestCase
  setup do
    @degree = degrees(:informatica)
    sign_in users(:student)
  end

  test "displays graph filtered by single category" do
    visit subjects_graph_path(categories: ["first_semester"])

    assert_selector "[data-controller='subject-graph']"
  end

  test "displays graph filtered by multiple categories" do
    visit subjects_graph_path(categories: ["first_semester", "second_semester"])

    assert_selector "[data-controller='subject-graph']"
  end

  test "nodes show availability status" do
    user = users(:student)
    user.update!(approvals: [approvables(:calculo1_course).id])

    visit subjects_graph_path(categories: ["second_semester"])

    node_data = find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
    parsed = JSON.parse(node_data)

    assert parsed.any? { |n| n["available"] == true }
  end
end
```

## Implementation Checklist

1. [ ] Add npm packages: `yarn add cytoscape cytoscape-dagre`
2. [ ] Create `SubjectGraphComponent` (component + template)
3. [ ] Create `subject_graph_controller.js` Stimulus controller
4. [ ] Add routes for both graph endpoints
5. [ ] Create `Subjects::GraphsController`
6. [ ] Create `Planner::GraphsController`
7. [ ] Create view templates
8. [ ] Add system tests
9. [ ] Manual testing with real data
