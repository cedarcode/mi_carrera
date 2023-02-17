import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti";

export default class extends Controller {
  connect() {
    const duration = 5 * 1000;
    const animationEnd = Date.now() + duration;
    const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

    const interval = setInterval(() => {
      const timeLeft = animationEnd - Date.now();

      if (timeLeft <= 0) {
        return clearInterval(interval);
      }

      const particleCount = 50 * (timeLeft / duration);

      confetti({ ...defaults, particleCount, origin: { x: this.randomInRange(0.1, 0.3), y: Math.random() - 0.2 } });
      confetti({ ...defaults, particleCount, origin: { x: this.randomInRange(0.7, 0.9), y: Math.random() - 0.2 } });
    }, 250);
  }

  randomInRange(min, max) {
    return Math.random() * (max - min) + min;
  }
}
