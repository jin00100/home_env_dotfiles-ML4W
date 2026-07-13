hl.on("hyprland.start", function () 
    hl.exec_cmd("wayvnc 0.0.0.0 5900")
    hl.exec_cmd("systemctl --user start app-dev.lizardbyte.app.Sunshine.service")
end)
