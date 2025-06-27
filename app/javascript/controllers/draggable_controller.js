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
        handle: "[data-draggable-handle]",
      });
    });

    this.hasNotApprovedSubjectsListTarget && Sortable.create(this.notApprovedSubjectsListTarget, {
      group: {
        name: 'shared',
        put: false
      },
      sort: false,
      onEnd: this.onEnd.bind(this),
      handle: "[data-draggable-handle]",
    });
  }

  onEnd(event) {
    const url = event.item.dataset.draggableUrl;
    const method = event.item.dataset.draggableMethod;
    const newSemester = event.to.dataset.semester;

    var params;
    if (method == 'put') {
      params = { subject_plan: { semester: newSemester } };
    } else if (method == 'post') {
      const subjectId = event.item.dataset.draggableSubjectId;
      params = { subject_plan: { subject_id: subjectId, semester: newSemester } };
    }

    const request = new FetchRequest(method, url, { headers: { 'Accept': 'text/vnd.turbo-stream.html, text/html' }, body: JSON.stringify(params) })
    request.perform()
  }
}
