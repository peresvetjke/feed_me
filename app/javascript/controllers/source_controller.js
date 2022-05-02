import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ 'select' ]

  static values = { sourceId: String, listSourceId: String }

  connect() {
    console.log('source connected')
    // console.log(this.idValue)
    // console.log(this.selectTarget.value)
  }

  updateList() {
    // console.log(this.selectTarget.value)
    if (this.selectTarget.value == '') {
      this.clearAssignment()
    } else {
      this.assignList(this.selectTarget.value)
    }
  }

  assignList(listId) {
    let self = this
    let method = 'post'
    let params = { 
      list: {
        id: listId
      } 
    }

    Rails.ajax({
      url: `/sources/${this.sourceIdValue}/assign_to_list`,
      type: method,
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      }
      // ,
      // success(data) {
      //   // console.log('success')
      // },
      // error: function(data) {
      //   alert("Error occured. Please contact administrator.")
      // }
    })
  }

  clearAssignment() {
    let self = this
    let method = 'delete'
    let params = { }

    Rails.ajax({
      url: `/sources/${this.sourceIdValue}/clear_assignment`,
      type: method,
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      }
      // ,
      // success(data) {
      //   console.log('success')
      // },
      // error: function(data) {
      //   alert("Error occured. Please contact administrator.")
      // }
    })
  }
}