import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "table"]

  connect() {
    console.log("FilterUsers controller Connected")
  }

  filter() {
    const url = new URL(window.location)
    url.searchParams.set('city', this.selectTarget.value)
    
    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => response.text())
    .then(html => {
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, 'text/html')
      const turboStreamElement = doc.querySelector('turbo-stream')
      
      if (turboStreamElement) {
        const content = turboStreamElement.querySelector('template').content
        this.tableTarget.innerHTML = '' // Clear existing table content
        this.tableTarget.appendChild(content.cloneNode(true))
      } else {
        console.error("Turbo Stream element not found in the response")
      }
    })
    .catch(error => {
      console.error("Error:", error)
    })
  }

  search() {
    this.debounce(() => {  
      this.filter()
    });
  }

  debounce(func, timeout = 300){
    if (this.timer) {
      clearTimeout(this.timer)
      console.debug("Debounce timer cleared")
    }
    this.timer = setTimeout(func, timeout);
  }
}
