import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { put, post } from '@rails/request.js';

export default class extends Controller {
  connect() {
    var lists = document.querySelectorAll('ul');
    var notApprovedSubjectsList = document.querySelector('ul#not-approved-subjects');

    lists.forEach((list) => {
      if (list.id === 'not-approved-subjects') return;

      Sortable.create(list, {
        group: 'shared',
        sort: false,
        onEnd: this.onEnd.bind(this),
      });
    });

    notApprovedSubjectsList && Sortable.create(notApprovedSubjectsList, {
      group: {
        name: 'shared',
        put: false
      },
      sort: false,
      onEnd: this.onEnd.bind(this),
    });
  }

  onEnd(event) {
    const url = event.item.dataset.draggableUrl;
    const method = event.item.dataset.draggableMethod;
    const newSemester = event.to.parentElement.dataset.semester;

    if (method == 'put') {
      put(url, {
        body: JSON.stringify({ semester: newSemester })
      });
    } else if (method == 'post') {
      const subjectId = event.item.dataset.draggableSubjectId;

      post(url, {
        body: JSON.stringify({ subject_plan: { subject_id: subjectId, semester: newSemester } }),
      });
    }
  }
}
