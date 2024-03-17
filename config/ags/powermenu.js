import PopupWindow from "./popup.js"

const icons = {
        sleep: "weather-clear-night-symbolic",
        reboot: "system-reboot-symbolic",
        logout: "system-log-out-symbolic",
        shutdown: "system-shutdown-symbolic",
};

const SysButton = (action, label) => Widget.Button({
    on_clicked: () => Utils.exec(action),
    child: Widget.Box({
        vertical: true,
        class_name: "system-button",
        children: [
            Widget.Icon(icons[action]),
            Widget.Label({
                label,
                visible: true,
                class_name: "sys-but-label"
            }),
        ],
    }),
})

export default () => PopupWindow({
    name: "powermenu",
    transition: "crossfade",
    child: Widget.Box({
        class_name: "powermenu-horizontal",
        children: [
                    SysButton("shutdown", "Shutdown"),
                    SysButton("logout", "Log Out"),
                    SysButton("reboot", "Reboot"),
                    SysButton("sleep", "Sleep"),
                  ]
    }),
})
