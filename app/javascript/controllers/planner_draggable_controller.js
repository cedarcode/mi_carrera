import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { FetchRequest } from '@rails/request.js';

export default class extends Controller {
  static targets = ['semesterSubjectsList', 'notApprovedSubjectsList'];

  connect() {
    this.semesterSubjectsListTargets.forEach((list) => {
      Sortable.create(list, {
        group: 'shared',
        sort: false,
        onEnd: this.onEnd.bind(this),
        handle: "[data-planner-draggable-handle]",
      });
    });

    this.hasNotApprovedSubjectsListTarget && Sortable.create(this.notApprovedSubjectsListTarget, {
      group: {
        name: 'shared',
        put: false
      },
      sort: false,
      onEnd: this.onEnd.bind(this),
      handle: "[data-planner-draggable-handle]",
    });
  }

  onEnd(event) {
    const url = event.item.dataset.plannerDraggableUrl;
    const method = event.item.dataset.plannerDraggableMethod;
    const newSemester = event.to.dataset.semester;

    var params = { subject_plan: { semester: newSemester } };

    if (method == 'post') {
      params['subject_plan'].subject_id = event.item.dataset.plannerDraggableSubjectId;
    }

    const request = new FetchRequest(method, url, { headers: { 'Accept': 'text/vnd.turbo-stream.html, text/html' }, body: JSON.stringify(params) })
    request.perform()
  }
}
