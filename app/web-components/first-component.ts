class MyComponent extends HTMLElement {
  // component implementation goes here
  // The browser calls this method when the element is
  // added to the DOM.
  // connectedCallback() {
  //   // Create a Date object representing the current date.
  //   const now = new Date();

  //   // Format the date to a human-friendly string, and set the
  //   // formatted date as the text content of this element.
  //   this.textContent = now.toLocaleDateString();
  // }

  constructor() {
    super();

    const button = document.createElement('button');
    button.textContent = this.getAttribute('label') || 'Click Me';
    button.className = this.getAttribute('btn-class') || '';
    this.appendChild(button);
  }
}

customElements.define('first-component', MyComponent);
