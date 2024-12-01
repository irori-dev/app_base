import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "submitButton", "checkbox", "required" ]
  
  connect() {
    this.validate()
  }

  validate() {
    if (this.checkboxTarget.checked) {
      this.submitButtonTarget.disabled = false
    } else {
      this.submitButtonTarget.disabled = true
    }
  }
}