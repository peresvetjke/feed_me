import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static values = { id: String, bodyIsVisible: Boolean, isRead: Boolean }

  static targets = [ "title", "body" ]

  connect() {
    if (!this.isReadValue) { 
      $(this.titleTarget).addClass("has-text-weight-bold") 
    }
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

    if (!this.isReadValue) { this.markRead() }
  }

  markRead() {
    let self = this
    let params = { }

    Rails.ajax({
      url: `/articles/${self.idValue}/mark_read`,
      type: 'post',
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      },
      success(data) {
        console.log('success')
        self.isReadValue = !self.isReadValue
        if (self.isReadValue) { 
          $(self.titleTarget).removeClass("has-text-weight-bold") 
        }
      },
      error: function(error) {
        alert(error)
      }
    })
  }

}
