import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const dropZone = this.element;
    const fileInput = document.getElementById('file-input');

    dropZone.addEventListener('dragover', this.handleDragOver);
    dropZone.addEventListener('dragleave', this.handleDragLeave);
    dropZone.addEventListener('drop', this.handleDrop);

    fileInput.addEventListener('change', this.handleFileSelect);
  }

  handleDragOver = (event) => {
    event.preventDefault();
    this.element.classList.add('border-primary');
    this.element.classList.remove('border-secondary');
  }

  handleDragLeave = (event) => {
    event.preventDefault();
    this.element.classList.add('border-secondary');
    this.element.classList.remove('border-primary');
  }

  handleDrop = (event) => {
    event.preventDefault();
    this.element.classList.remove('border-primary');
    this.element.classList.add('border-secondary');

    const files = Array.from(event.dataTransfer.files);
    const fileListElement = document.getElementById('file-list');
    fileListElement.innerHTML = '';

    files.forEach((file) => {
      const fileNameParagraph = document.createElement('p');
      fileNameParagraph.textContent = file.name;
      fileListElement.appendChild(fileNameParagraph);
    });

    this.selectFiles(files);
  }

  handleFileSelect = (event) => {
    const files = Array.from(event.target.files);
    const fileListElement = document.getElementById('file-list');
    fileListElement.innerHTML = '';

    files.forEach((file) => {
      const fileNameParagraph = document.createElement('p');
      fileNameParagraph.textContent = file.name;
      fileListElement.appendChild(fileNameParagraph);
    });

    this.selectFiles(files);
  }

  selectFiles(files) {
    const inputField = document.getElementById('file-input');
    const dataTransfer = new DataTransfer();

    files.forEach((file) => {
      dataTransfer.items.add(file);
    });

    inputField.files = dataTransfer.files;
  }
}
