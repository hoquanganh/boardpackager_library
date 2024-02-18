import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('Connected');
    const userEmail = this.element.textContent;
    this.element.textContent = `Welcome: ${userEmail}`;
  }
}
