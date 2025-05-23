import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]

  connect() {
    const toast = this.toastTarget

    toast.classList.remove("hidden")

    requestAnimationFrame(() => {
      toast.classList.remove("translate-x-full", "opacity-0")
      toast.classList.add("translate-x-0", "opacity-100")
    })

    setTimeout(() => {
      toast.classList.remove("translate-x-0", "opacity-100")
      toast.classList.add("translate-x-full", "opacity-0")

      toast.addEventListener("transitionend", () => {
        toast.classList.add("hidden")
      }, { once: true })
    }, 5000)
  }
}
