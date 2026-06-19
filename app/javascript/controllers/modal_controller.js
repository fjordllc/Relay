import { Controller } from "@hotwired/stimulus"

// 第26章: <dialog> を使ったモーダル
export default class extends Controller {
  connect() {
    this.element.showModal()
  }

  close() {
    this.element.close()
  }

  // close イベント（Esc など）で、閉じたダイアログを DOM から取り除く
  cleanup() {
    this.element.remove()
  }
}
