import { Controller } from "@hotwired/stimulus";
import { enter, leave } from "el-transition"

export default class extends Controller {
  connect() {
    enter(this.element)
    setTimeout(() => {
      this.dismiss();
    }, 6000);
  }

  dismiss() {
    Promise.all([
      leave(this.element),
    ]).then(() => {
      this.element.remove()
    })
  }
}
