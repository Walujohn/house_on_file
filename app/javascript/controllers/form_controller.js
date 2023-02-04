import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  hideValidationMessage(event) {
    event.stopPropagation()
    event.preventDefault()
  }
}