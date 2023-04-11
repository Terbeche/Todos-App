import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "todos", "editForm"]

  create(event) {
    console.log("create");
    event.preventDefault();
    let url = this.formTarget.action;
    let data = new FormData(this.formTarget);

    fetch(url, {
      method: "POST",
      body: data,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      }
    }).then(response => response.text())
      .then(html => {
        this.todosTarget.insertAdjacentHTML("beforeend", html);
        this.formTarget.reset();
      });
  }

  edit(event) {
    console.log("edit");
  
    event.preventDefault();
    let url = event.target.href;
  
    fetch(url)
      .then(response => response.text())
      .then(html => {
        let todoElement = event.target.closest(".todo");
        todoElement.style.display = "none";
        // Create a new element to hold the edit form
        let editFormWrapper = document.createElement("div");
        editFormWrapper.innerHTML = html;
        // Insert the edit form into the DOM after the todo element
        todoElement.insertAdjacentElement("afterend", editFormWrapper);
      });
  }

  // update(event) {
  //   console.log("update");

  //   event.preventDefault();
  //   let formElement = event.target;
  //   let url = formElement.action;
  //   let data = new FormData(formElement);
  //   fetch(url, {
  //     method: "PATCH",
  //     body: data,
  //     headers: {
  //       "X-CSRF-Token": docuformment.querySelector("meta[name='csrf-token']").content,
  //       "Accept": "text/javascript"
  //     }
  //   }).then(response => response.text())
  //     .then(html => {
  //       formElement.closest(".todo").outerHTML = html;
  //     });
  // }

  update(event) {
    console.log("update");
    let editForm = this.editFormTarget;
    event.preventDefault();
    let url = editForm.action;
    let data = new FormData(editForm);
    fetch(url, {
      method: "PATCH",
      body: data,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Accept": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => {
      // Use the data from the response to update the HTML of the todo element
      let todoElement = document.getElementById(data.id);
      console.log(todoElement);
      todoElement.querySelector(".title").textContent = data.title;
      todoElement.querySelector(".description").textContent = data.description;
      todoElement.querySelector(".due_date").textContent = data.due_date;
      editForm.remove();
      todoElement.style.display = "";
    });
  }
  
  delete(event) {
    console.log("delete");
    event.preventDefault();
      let url = event.target.href;

      fetch(url, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        }
      }).then(() => {
        let todoElement = event.target.closest(".todo");
        todoElement.remove();
      });
    
  }
}