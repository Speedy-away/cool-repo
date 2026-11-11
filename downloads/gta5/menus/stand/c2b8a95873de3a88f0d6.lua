util.require_natives("natives-1660775568")
menu.toggle_loop(menu.my_root(), "Disable Horns", {}, "", function()
    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
        AUDIO.SET_HORN_ENABLED(vehicle, false)
    end
end)
util.keep_running()