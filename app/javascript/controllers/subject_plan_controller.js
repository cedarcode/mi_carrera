import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  static targets = ["semesterList"];

  connect() {
    // Cache the CSRF token for use in fetch calls
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    this.initializeSortable();
  }

  initializeSortable() {
    this.isDragging = false;
    this.semesterLists = this.semesterListTargets.map((list) => {
      const isUnassigned = list.dataset.semester === "unassigned";
      return new Sortable(list, {
        group: {
          name: "semester",
          pull: true,
          put: !isUnassigned,
        },
        animation: 150,
        dragClass: "sortable-drag",
        ghostClass: "sortable-ghost",
        chosenClass: "sortable-chosen",
        onStart: this.handleDragStart.bind(this),
        onEnd: this.handleDrop.bind(this),
        sort: !isUnassigned,
        removeOnSpill: false,
        revertOnSpill: true,
        delay: 150,
        delayOnTouchOnly: true,
        handle: ".mdc-deprecated-list-item",
        preventOnFilter: false,
      });
    });

    // Add a click handler on the entire list to trigger the link if not dragging
    this.semesterListTargets.forEach((list) => {
      list.addEventListener("click", (e) => {
        if (this.isDragging) {
          e.preventDefault();
          return;
        }

        const listItem = e.target.closest(".mdc-deprecated-list-item");
        if (listItem) {
          const link = listItem.querySelector("a");
          if (link && !e.target.closest(".mdc-deprecated-list-item__meta")) {
            link.click();
          }
        }
      });
    });
  }

  handleDragStart(event) {
    this.isDragging = true;
    // Add visual feedback for potential drop targets except unassigned and source list
    this.semesterListTargets.forEach((list) => {
      if (list !== event.from && list.dataset.semester !== "unassigned") {
        list.classList.add("sortable-drag-target");
      }
    });
  }

  async handleDrop(event) {
    this.isDragging = false;
    // Remove drag target styling from all lists
    this.semesterListTargets.forEach((list) => {
      list.classList.remove("sortable-drag-target");
    });

    if (event.to.dataset.semester === "unassigned") {
      event.from.insertBefore(event.item, event.from.children[event.oldIndex]);
      return;
    }

    const subjectId = event.item.dataset.subjectId;
    const newSemester = event.to.dataset.semester;

    if (subjectId.startsWith("new-")) {
      const actualSubjectId = subjectId.replace("new-", "");
      try {
        const response = await this.fetchTurbo("/subject_plans", "POST", {
          subject_plan: {
            subject_id: actualSubjectId,
            semester: parseInt(newSemester, 10),
          },
        });

        if (!response.ok) {
          const data = await response.json();
          console.error("Error response:", data);
          alert(data.error || "Failed to create subject plan");
          event.from.insertBefore(
            event.item,
            event.from.children[event.oldIndex]
          );
          return;
        }

        const streamContent = await response.text();
        this.processTurboStream(streamContent);
      } catch (error) {
        console.error("Error:", error);
        event.from.insertBefore(
          event.item,
          event.from.children[event.oldIndex]
        );
      }
      return;
    }

    // Handle regular semester-to-semester drag and drop
    try {
      const response = await this.fetchTurbo(
        `/subject_plans/${subjectId}/update_semester`,
        "PATCH",
        {
          semester: parseInt(newSemester, 10),
        }
      );

      if (!response.ok) {
        const data = await response.json();
        console.error("Error response:", data);
        alert(data.error || "Failed to update semester");
        event.to.insertBefore(event.item, event.to.children[event.oldIndex]);
      } else {
        const streamContent = await response.text();
        this.processTurboStream(streamContent);
      }
    } catch (error) {
      console.error("Error:", error);
      event.to.insertBefore(event.item, event.to.children[event.oldIndex]);
    }
  }

  async fetchTurbo(url, method, bodyData) {
    return fetch(url, {
      method,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken,
        Accept: "text/vnd.turbo-stream.html",
      },
      body: JSON.stringify(bodyData),
    });
  }

  processTurboStream(streamContent) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(streamContent, "text/html");
    doc.querySelectorAll("turbo-stream").forEach((element) => {
      Turbo.renderStreamMessage(element.outerHTML);
    });
  }
}
