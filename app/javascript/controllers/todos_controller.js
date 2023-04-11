import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "todos", "editForm"]
connect() {
  this.element.addEventListener("dragstart", this.dragstart.bind(this));
  this.element.addEventListener("dragover", this.dragover.bind(this));
  this.element.addEventListener("drop", this.drop.bind(this));
}

disconnect() {
  this.element.removeEventListener("dragstart", this.dragstart.bind(this));
  this.element.removeEventListener("dragover", this.dragover.bind(this));
  this.element.removeEventListener("drop", this.drop.bind(this));
}
  
  dragstart(event) {
    event.dataTransfer.setData("text/plain", event.target.id);
  }
  
  dragover(event) {
    event.preventDefault();
  }

  drop(event) {
    event.preventDefault();
    let draggedId = event.dataTransfer.getData("text/plain");
    let draggedElement = document.getElementById(draggedId);
    let targetElement = event.target.closest(".todo");
    if (targetElement && targetElement !== draggedElement) {
      let todoElements = Array.from(this.element.querySelectorAll(".todo"));
      let draggedIndex = todoElements.indexOf(draggedElement);
      let targetIndex = todoElements.indexOf(targetElement);
      if (draggedIndex < targetIndex) {
        targetElement.parentNode.insertBefore(draggedElement, targetElement.nextSibling);
      } else {
        targetElement.parentNode.insertBefore(draggedElement, targetElement);
      }
      todoElements = Array.from(this.element.querySelectorAll(".todo"));
      let positions = todoElements.map((element) => element.id).filter((id) => id !== "");
      let url = "/todos/update_positions";
      fetch(url, {
        method: "POST",
        body: JSON.stringify({ positions: positions }),
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        }
      });
    }
  }

  create(event) {
    event.preventDefault();
    let url = this.formTarget.action;
    let data = new FormData(this.formTarget);
  
    fetch(url, {
      method: "POST",
      body: data,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      }
    }).then(response => {
      if (!response.ok) {
        throw response;
      }
      return response.text();
    })
      .then(html => {
        this.todosTarget.insertAdjacentHTML("beforeend", html);
        this.formTarget.reset();
      })
      .catch(error => {
        error.json().then(json => {
          console.error('There was a problem with the fetch operation:', json.errors);
          let errorMessageElement = document.querySelector("#error-message");
          errorMessageElement.textContent = json.errors.join(", ");
        });
      });
  }

  edit(event) {  
    event.preventDefault();
    let url = event.target.href;
  
    fetch(url)
      .then(response => response.text())
      .then(html => {
        let todoElement = event.target.closest(".todo");
        todoElement.style.display = "none";
        let editFormWrapper = document.createElement("div");
        editFormWrapper.innerHTML = html;
        todoElement.insertAdjacentElement("afterend", editFormWrapper);
      });
  }

  update(event) {
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
      let todoElement = document.getElementById(data.id);
      todoElement.querySelector(".title").textContent = data.title;
      todoElement.querySelector(".description").textContent = data.description;
      todoElement.querySelector(".due_date").textContent = data.due_date;
      editForm.remove();
      todoElement.style.display = "";
    });
  }
  
  delete(event) {
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

  toggleCompleted(event) {
    let todoId = event.target.value;
    let completed = event.target.checked;
    let url = `/todos/${todoId}/toggle_completed`;

    fetch(url, {
      method: "POST",
      body: JSON.stringify({ completed: completed }),
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      }
    });

    let todoElement = document.getElementById(todoId);
    if (completed) {
      console.log("toggleCompleted")
      todoElement.classList.add("completed");
    } else {
      todoElement.classList.remove("completed");
    }
  }
  
}