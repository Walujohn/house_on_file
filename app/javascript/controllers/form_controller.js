import { Controller } from "@hotwired/stimulus"
//import debounce from "https://cdn.skypack.dev/lodash.debounce@4.0.8"

// Connects to data-controller="form"
export default class extends Controller {
  static get targets() { return [ "submit" ] }

//  initialize() {
//    this.submit = debounce(this.submit.bind(this), 200)
//  }    
    
  connect() {
    this.submitTarget.hidden = true
  }

  submit() {
    this.submitTarget.click()
  }    
    
  hideValidationMessage(event) {
    event.stopPropagation()
    event.preventDefault()
  }
}