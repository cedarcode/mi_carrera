import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const toast = this.element

    toast.classList.remove("translate-x-full", "opacity-0")
    toast.classList.add("mr-4")

    setTimeout(() => {
      toast.classList.add("translate-x-full", "opacity-0", "mr-4")
      toast.classList.remove("mr-4")

      toast.addEventListener("transitionend", () => {
        toast.classList.add("hidden")
      }, { once: true })
    }, 5000)
  }
}
