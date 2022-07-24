import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal" ]


  successClose(event) {
    if (event.detail.success) {
      this.modalTarget.classList.add("hidden")
    }
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }

  open() {
    this.modalTarget.classList.remove("hidden")
  }
}