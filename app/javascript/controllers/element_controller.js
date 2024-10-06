import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="element"
export default class extends Controller {
  static targets = [ "click" ]

  click() {
    this.clickTargets.forEach(target => target.click())
  }
}
