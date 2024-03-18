import PopupWindow from "./popup.js"

const icons = {
        sleep: "weather-clear-night-symbolic",
        reboot: "system-reboot-symbolic",
        logout: "system-log-out-symbolic",
        shutdown : "system-shutdown-symbolic",
};

const SysButton = (key, action, label) => Widget.Button({
    on_clicked: () => Utils.exec(action),
    child: Widget.Box({
        vertical: true,
        class_name: "system-button",
        children: [
            Widget.Icon(icons[key]),
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
                    SysButton("shutdown", "shutdown now", "Shutdown"),
                    SysButton("logout", "pkill Hyprland", "Log Out"),
                    SysButton("reboot", "systemctl reboot", "Reboot"),
                    SysButton("sleep", "systemctl suspend", "Sleep"),
                  ]
    }),
})
