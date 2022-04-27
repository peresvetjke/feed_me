import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { bodyIsVisible: Boolean }

  static targets = [ "body" ]

  connect() {
    
  }

  updateVisibility(target, boolean) {
    if (boolean) {
      $(target).removeClass("hide")
    } else {
      $(target).addClass("hide")
    }
  }

  click() {
    this.bodyIsVisibleValue = !this.bodyIsVisibleValue
    this.updateVisibility(this.bodyTarget, this.bodyIsVisibleValue)
  }

}
