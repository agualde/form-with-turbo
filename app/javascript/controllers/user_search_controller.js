import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "form" ]

  connect() {
    console.log("Hello from users search controller")
  }

  filter(event) {
    if (event.key == 'Enter') return

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 300)
  }

  clear() {
    this.inputTarget.value = ""
  }

  clearAndSubmit() {
    this.inputTarget.value = ""
    this.formTarget.requestSubmit()
  }
}