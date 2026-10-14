import { Controller } from "@hotwired/stimulus"

// 第20章: 入力した文字数を数えて表示する
export default class extends Controller {
  static targets = ["field", "output"]

  connect() {
    this.count()
  }

  count() {
    this.outputTarget.textContent = Array.from(new Intl.Segmenter("ja", { granularity: "grapheme" }).segment(this.fieldTarget.value)).length
  }
}
