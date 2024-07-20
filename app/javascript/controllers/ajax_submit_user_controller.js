import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form", "table", "errors", "cityFilter" ]

  connect() {
    console.log("UserForm controller connected")
  }

  submitForm(event) {
    event.preventDefault()
    
    const formData = new FormData(this.formTarget)

    fetch(this.formTarget.action, {
      method: 'POST',
      body: formData,
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => response.text())
    .then(html => {
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, 'text/html')
      const turboStreamElements = doc.querySelectorAll('turbo-stream')
      
      turboStreamElements.forEach(turboStreamElement => {
        const action = turboStreamElement.getAttribute('action')
        const target = turboStreamElement.getAttribute('target')
        const content = turboStreamElement.querySelector('template').content

        if (action === 'append' && target === 'user-table') {
          this.tableTarget.appendChild(content.cloneNode(true))
          this.formTarget.reset()
          this.clearErrors()
        } else if (action === 'replace' && target === 'new_user_form') {
          this.formTarget.innerHTML = content.querySelector('form').innerHTML
        } else if (action === 'replace' && target === 'city-filter') {
          this.updateCityFilter(content)
        }
      })
    })
    .catch(error => {
      console.error("Error:", error)
    })
  }

  updateCityFilter(content) {
    const newSelect = content.querySelector('select')
    const currentSelect = this.cityFilterTarget
    
    // Update options
    currentSelect.innerHTML = newSelect.innerHTML
    currentSelect.selectedIndex = 0  // Reset to "All Cities" if the current selection is no longer available
  }

  clearErrors() {
    const errorElements = this.formTarget.querySelectorAll('.is-invalid, .invalid-feedback')
    errorElements.forEach(el => {
      if (el.classList.contains('is-invalid')) {
        el.classList.remove('is-invalid')
      } else {
        el.remove()
      }
    })

    if (this.hasErrorsTarget) {
      this.errorsTarget.innerHTML = ''
    }
  }
}