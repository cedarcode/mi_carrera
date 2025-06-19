import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs';

export default class extends Controller {
  connect() {
    var lists = document.querySelectorAll('ul');

    lists.forEach((list) => {
      Sortable.create(list, {
        group: 'shared',
        sort: true,
      });
    });
  }
}
