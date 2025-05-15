GUI = require("scripts.gui")
Text = require("scripts.text")

script.on_configuration_changed(function()
    Text.refresh_surface_property_cache()
    -- for _, player in pairs(game.players) do
    --     GUI.destroy_button(player.index)
    --     GUI.destroy_frame(player.index)
    --     GUI.create_button(player.index)
    -- end
end)

script.on_init(function()
    Text.refresh_surface_property_cache()
end)
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    if player == nil then
        return
    end
    GUI.create_button(player.index)
end)

script.on_event(defines.events.on_gui_click, function(event)
    GUI.on_click(event)
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    if player == nil then
        return
    end
    local frame_flow = mod_gui.get_frame_flow(player)
    if frame_flow.surface_property_viewer_frame then
        GUI.destroy_frame(player.index)
        GUI.create_frame(player.index, Text.build_text(player.surface))
    end
end)

remote.add_interface("spv", {
    set_localiser = Text.set_localiser,
    get_localiser = Text.get_localiser,
    remove_localiser = Text.remove_localiser,
    refresh_surface_property_cache = Text.refresh_surface_property_cache,
})
