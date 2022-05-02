import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ['link']

  connect() {
    
  }

  click(e) {
    e.preventDefault()
    // console.log("clicked!")
    // console.log(e.target)
    Turbo.visit(e.target.href)

  }
}