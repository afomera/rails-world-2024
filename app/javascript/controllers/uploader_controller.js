import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "fileInput",
    "searchInput",
    "results",
    "selector",
    "picker",
    "search",
    "mediaLibrarySearch",
    "searchMediaLibraryInput",
  ];

  static values = { fieldName: String}

  // read query and call custom pexels controller to fetch photos
  search() {
    const query = this.searchInputTarget.value;
    const url = `/pexels/search?query=${query}`;

    // return if less than 3 characters are present
    if (query.length < 3) return;

    // call pexels controller to fetch photos
    // you may want to add a debounce here to prevent multiple calls
    fetch(url)
      .then((response) => response.json())
      .then((data) => this.displayResults(data))
      .catch((error) => console.error("Error:", error));
  }


  searchMediaLibrary() {
    const query = this.searchMediaLibraryInputTarget.value;
    const url = `/media.json?search=${query}&type=image`;

    // return if less than 3 characters are present
    if (query.length < 3) return;

    // call media library controller to fetch photos
    // you may want to add a debounce here to prevent multiple calls
    fetch(url)
      .then((response) => response.json())
      .then((data) => this.displayMediaLibraryResults(data))
      .catch((error) => console.error("Error:", error));
  }

  displayMediaLibraryResults(results) {
    // clear results div and disply new results
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.className = "grid grid-cols-5 gap-3 my-5";

    results.forEach((result) => {
      const div = document.createElement("div");
      div.className =
        "aspect-w-1 aspect-h-1 bg-gray-900 rounded-lg overflow-hidden hover:opacity-50";
      const img = document.createElement("img");
      img.src = result.url;
      img.className = "object-cover cursor-pointer";
      div.appendChild(img);

      this.resultsTarget.appendChild(div);

      // Select photo when clicked
      div.addEventListener("click", () => this.selectMediaLibraryPhoto(result));
    });
  }

  selectMediaLibraryPhoto(result) {
    // clear results div and display selected photo
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.className = "w-40";

    const div = document.createElement("div");
    div.className = "aspect-w-1 aspect-h-1 rounded-lg overflow-hidden my-4";

    const img = document.createElement("img");
    img.src = result.url;
    img.className = "object-cover";

    div.appendChild(img);
    this.resultsTarget.appendChild(div);

    // Add hidden field containing the signed id of the selected image
    // We can just used the signed id here because we already have the blob persisted in the database
    // this will just add another attachment
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.fieldNameValue;
    input.value = `${result.signed_id}`;
    this.element.appendChild(input);
  }

  displayResults(photos) {
    // clear results div and disply new results
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.className = "grid grid-cols-5 gap-3 my-5";

    photos.forEach((photo) => {
      const div = document.createElement("div");
      div.className =
        "aspect-w-1 aspect-h-1 bg-gray-900 rounded-lg overflow-hidden hover:opacity-50";
      const img = document.createElement("img");
      img.src = photo.url;
      img.className = "object-cover cursor-pointer";
      div.appendChild(img);

      var attributionDiv = document.createElement("div");
      attributionDiv.className = "text-white text-xs p-2";
      attributionDiv.innerHTML = `Photo by <a class="underline" href="${photo.user_url}" target="_blank">${photo.user}</a>`;
      div.appendChild(attributionDiv);

      this.resultsTarget.appendChild(div);

      // Select photo when clicked
      div.addEventListener("click", () => this.selectPhoto(photo));
    });
  }

  selectPhoto(photo) {
    // clear results div and display selected photo
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.className = "w-40";

    const div = document.createElement("div");
    div.className = "aspect-w-1 aspect-h-1 rounded-lg overflow-hidden my-4";

    const img = document.createElement("img");
    img.src = photo.url;
    img.className = "object-cover";

    div.appendChild(img);
    this.resultsTarget.appendChild(div);

    // Add hidden field containing the url of the selected photo
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.fieldNameValue;
    input.value = `pexels:${photo.url}`;
    this.element.appendChild(input);
  }

  // clear selections and show selector card
  showSelector() {
    this.clearSelection();
    if (this.hasSelectorTarget) this.selectorTarget.classList.remove("hidden");
    if (this.hasPickerTarget) this.pickerTarget.classList.add("hidden");
    if (this.hasSearchTarget) this.searchTarget.classList.add("hidden");

    if (this.hasSearchMediaLibraryInputTarget) this.searchMediaLibraryInputTarget.value = "";
    if (this.hasMediaLibrarySearchTarget) this.mediaLibrarySearchTarget.classList.add("hidden");
  }

  // clear selections and show fileInput card
  showPicker() {
    this.clearSelection();
    if (this.hasPickerTarget) this.pickerTarget.classList.remove("hidden");
    if (this.hasSelectorTarget) this.selectorTarget.classList.add("hidden");
    if (this.hasSearchTarget) this.searchTarget.classList.add("hidden");
  }

  // clear selections and show search card
  showSearch() {
    this.clearSelection();
    if (this.hasSearchTarget) this.searchTarget.classList.remove("hidden");
    if (this.hasSelectorTarget) this.selectorTarget.classList.add("hidden");
    if (this.hasPickerTarget) this.pickerTarget.classList.add("hidden");
    document.getElementById("query").focus();
  }

  showMediaLibrary() {
    this.clearSelection();
    if (this.hasSearchTarget) this.searchTarget.classList.add("hidden");
    if (this.hasSelectorTarget) this.selectorTarget.classList.add("hidden");
    if (this.hasPickerTarget) this.pickerTarget.classList.add("hidden");

    if (this.hasMediaLibrarySearchTarget) this.mediaLibrarySearchTarget.classList.remove("hidden");
    if (this.hasSearchMediaLibraryInputTarget) this.searchMediaLibraryInputTarget.focus();
  }

  // clears cards and selected photo hidden field
  clearSelection() {
    if (this.hasFileInputTarget) this.fileInputTarget.value = "";
    if (this.hasSearchInputTarget) this.searchInputTarget.value = "";
    if (this.hasResultsTarget) this.resultsTarget.innerHTML = "";
    if (
      document.contains(document.querySelector(`input[name="${this.fieldNameValue}"][type="hidden"]`))
    ) {
      document.querySelector(`input[name="${this.fieldNameValue}"][type="hidden"]`).remove();
    }
  }

  // Prevent enter keystroke from submitting parent form
  preventEnterSubmission = (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
    }
  };

  connect() {
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.addEventListener(
        "keypress",
        this.preventEnterSubmission
      );
    }

    if (this.hasSearchMediaLibraryInputTarget) {
      this.searchMediaLibraryInputTarget.addEventListener(
        "keypress",
        this.preventEnterSubmission
      );
    }
  }

  disconnect() {
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.removeEventListener(
        "keypress",
        this.preventEnterSubmission
      );
    }

    if (this.hasSearchMediaLibraryInputTarget) {
      this.searchMediaLibraryInputTarget.removeEventListener(
        "keypress",
        this.preventEnterSubmission
      );
    }
  }
}
