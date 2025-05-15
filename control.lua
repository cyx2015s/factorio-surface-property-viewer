GUI = require("scripts.gui")

script.on_configuration_changed(function()
    for _, player in pairs(game.players) do
        GUI.destroy_button(player.index)
        GUI.destroy_frame(player.index)
        GUI.create_button(player.index)
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    GUI.create_button(player.index)
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "surface-property-viewer-button" then
        local player = game.get_player(event.player_index)
        if player.gui.screen.surface_property_viewer_frame then
            GUI.destroy_frame(player.index)
        else
            GUI.create_frame(player.index, "Surface Properties")
        end
    end
end)
