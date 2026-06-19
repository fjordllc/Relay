import { Controller } from "@hotwired/stimulus"

// 第19章: 結びついた要素にフォーカスを当てる（エラーサマリにも再利用）
export default class extends Controller {
  connect() {
    this.element.focus()
  }
}
