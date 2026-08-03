import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["postType", "prefectureField"]

  connect() {
    this.togglePrefecture()
  }

  togglePrefecture() {
    const selected = this.postTypeTargets.find((radio) => radio.checked)
    const isEatOut = selected?.value === "eat_out"

    this.prefectureFieldTarget.hidden = !isEatOut
  }
}
