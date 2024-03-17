import { bar } from "./bartmp.js"
import { applauncher } from "./applauncher.js"
import PowerMenu from "./powermenu.js"

App.config({
    style: "./style.css",
    windows: [ bar, applauncher, PowerMenu() ],
})

export { }
