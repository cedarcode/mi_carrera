import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';
import { put } from '@rails/request.js';

export default class extends Controller {
  connect() {
    var lists = document.querySelectorAll('ul');

    lists.forEach((list) => {
      Sortable.create(list, {
        group: 'shared',
        sort: true,
        onEnd: this.onEnd.bind(this),
      });
    });
  }

  onEnd(event) {
    const url = event.item.dataset.draggableUrl;
    const newSemester = event.to.parentElement.dataset.semester;

    put(url, {
      body: JSON.stringify({ semester: newSemester })
    });
  }
}
