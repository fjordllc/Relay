import { Controller } from "@hotwired/stimulus"

// 第24章: 末尾が見えたら「もっと読む」を自動でクリックする
export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.observer = new IntersectionObserver((entries) => {
      if (entries[0].isIntersecting) {
        this.buttonTarget.click()
      }
    })
  }

  buttonTargetConnected(button) {
    this.observer.observe(button)
  }

  buttonTargetDisconnected(button) {
    this.observer.unobserve(button)
  }

  disconnect() {
    this.observer.disconnect()
  }
}
