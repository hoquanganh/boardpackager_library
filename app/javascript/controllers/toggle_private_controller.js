import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["switch"];

  connect() {
    console.log("Toggle Private controller connected");
  }

  togglePrivacy(event) {
    const switchElement = event.target;
    const documentId = switchElement.dataset.documentId;
    const userId = switchElement.dataset.userId;
    const isChecked = switchElement.checked;

    fetch(`/users/${userId}/documents/${documentId}/toggle_privacy`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
      body: JSON.stringify({ private: isChecked }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not OK");
        }
        const contentType = response.headers.get("content-type");
        if (contentType && contentType.includes("application/json")) {
          return response.json();
        } else {
          throw new Error("Response was not in JSON format");
        }
      })
      .then((data) => {
        console.log(data);
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }
}
