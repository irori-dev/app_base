import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "object" ]
  
  remove() {
    this.objectTarget.remove()
  }
}