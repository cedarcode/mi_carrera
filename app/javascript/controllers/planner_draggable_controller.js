import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { FetchRequest } from '@rails/request.js';

export default class extends Controller {
  static outlets = ['planner-loading'];
  static values = {
    put: { type: Boolean, default: true }
  };

  connect() {
    Sortable.create(this.element, {
      forceAutoScrollFallback: true,
      group: {
        name: 'shared',
        put: this.putValue
      },
      sort: false,
      onEnd: this.onEnd.bind(this),
      handle: "[data-planner-draggable-handle]",
    });
  }

  async onEnd(event) {
    if (event.from === event.to) { return; }

    this.plannerLoadingOutlet.start();

    const url = event.item.dataset.plannerDraggableUrl;
    const method = event.item.dataset.plannerDraggableMethod;
    const newSemester = event.to.dataset.semester;

    var params = { subject_plan: { semester: newSemester } };

    if (method == 'post') {
      params['subject_plan'].subject_id = event.item.dataset.plannerDraggableSubjectId;
    }

    const request = new FetchRequest(method, url, { headers: { 'Accept': 'text/vnd.turbo-stream.html, text/html' }, body: JSON.stringify(params) })
    const response = await request.perform()
    if (!response.ok) {
      window.location.reload();
    }
  }
}
