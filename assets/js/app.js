import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import alertify from "alertifyjs";
import topbar from "topbar";
import Alpine from "alpinejs";

window.Alpine = Alpine;
Alpine.start();

let Hooks = {};

Hooks.alertify_info = {
  mounted() {
    const alertifyInfo = ({ message }) => {
      alertify.set("notifier", "position", "top-right");
      alertify.notify(message, "custom-success");
    };
    this.handleEvent("alertify_info", alertifyInfo);
  },
};

Hooks.alertify_error = {
  mounted() {
    const alertifyError = ({ message }) => {
      alertify.set("notifier", "position", "top-right");
      alertify.notify(message, "custom-error");
    };
    this.handleEvent("alertify_error", alertifyError);
  },
};

Hooks.copyPasswordToClipboard = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      let moduleId = this.el.dataset.moduleId;

      let passwordInput = document.querySelector(`#copy-password-${moduleId}`);

      passwordInput.select();
      passwordInput.setSelectionRange(0, 99999);
      document.execCommand("copy");

      // Notify user password copied
      this.pushEventTo(this.el, "copied-password");
    });
  },
};

Hooks.clearInput = {
  updated() {
    this.el.querySelector("#chat-message-input").value = "";
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: {
    _csrf_token: csrfToken,
    timezone: -new Date().getTimezoneOffset() / 60,
  },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

export default function sendTimezoneToServer() {
  const timezone = -(new Date().getTimezoneOffset() / 60);
  let csrfToken = document
    .querySelector("meta[name='csrf-token']")
    .getAttribute("content");

  if (typeof window.localStorage != "undefined") {
    try {
      var xhr = new XMLHttpRequest();
      xhr.open("POST", "/session/set-timezone", true);
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.setRequestHeader("x-csrf-token", csrfToken);
      xhr.onreadystatechange = function () {
        if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
          localStorage["timezone"] = timezone.toString();
        }
      };
      xhr.send(`{"timezone": ${timezone}}`);
    } catch (e) {}
  }
}

sendTimezoneToServer();
