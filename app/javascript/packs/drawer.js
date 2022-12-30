import { MDCDrawer } from "@material/drawer";
const drawer = MDCDrawer.attachTo(document.querySelector(".mdc-drawer"));

import { MDCList } from "@material/list";
const list = MDCList.attachTo(document.querySelector(".mdc-list"));
list.wrapFocus = true;

const listEl = document.querySelector(".mdc-drawer .mdc-list");
const mainContentEl = document.querySelector(".main-content");

listEl.addEventListener("click", (event) => {
  mainContentEl.querySelector("input, button").focus();
});

document.body.addEventListener("MDCDrawer:closed", () => {
  mainContentEl.querySelector("input, button").focus();
});

import { MDCTopAppBar } from "@material/top-app-bar";
const topAppBar = MDCTopAppBar.attachTo(document.getElementById("app-bar"));
// topAppBar.setScrollTarget(document.getElementById("main-content"));
topAppBar.listen("MDCTopAppBar:nav", () => {
  drawer.open = !drawer.open;
});
