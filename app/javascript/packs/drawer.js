import { MDCDrawer } from "@material/drawer";
import { MDCList } from "@material/list";
import { MDCTopAppBar } from "@material/top-app-bar";

document.addEventListener("turbolinks:load", function () {
  const list = MDCList.attachTo(document.querySelector(".mdc-list"));
  list.wrapFocus = true;

  const listEl = document.querySelector(".mdc-drawer .mdc-list");
  const mainContentEl = document.querySelector(".main-content");
  listEl.addEventListener("click", () => {
    mainContentEl.querySelector("input, button").focus();
  });
  document.body.addEventListener("MDCDrawer:closed", () => {
    mainContentEl.querySelector("input, button").focus();
  });

  const drawer = MDCDrawer.attachTo(document.querySelector(".mdc-drawer"));
  const topAppBar = MDCTopAppBar.attachTo(document.getElementById("app-bar"));
  topAppBar.listen("MDCTopAppBar:nav", () => {
    drawer.open = !drawer.open;
  });
});
