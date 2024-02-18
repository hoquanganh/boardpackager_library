import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['toast'];

  connect() {
    this.toastTargets.forEach((toast) => {
      const delay = parseInt(toast.dataset.delay) || 3000;
      const toastElement = new bootstrap.Toast(toast);
      // toastElement.show();
      setTimeout(() => {
        toastElement.hide();
      }, delay);
    });
  }

  hideToast(toast) {
    toast.classList.remove('show');
    setTimeout(() => {
      toast.parentNode.removeChild(toast);
    }, 500);
  }
}
