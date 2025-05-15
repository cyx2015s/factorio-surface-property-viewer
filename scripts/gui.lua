mod_gui = require("mod-gui")

GUI = {}

GUI.create_button = function(player_index)
    local player = game.get_player(player_index)
    local button_flow = mod_gui.get_button_flow(player)
    if not button_flow.surface_property_viewer_button then
        button_flow.add {
            type = "button",
            name = "surface-property-viewer-button",
            caption = { "surface-property-viewer-button" },
            tooltip = { "surface-property-viewer.button-tooltip" },
        }
    end
end

GUI.create_frame = function(player_index, content)
    local player = game.get_player(player_index)
    local frame_flow = mod_gui.get_frame_flow(player)
    if not frame_flow.surface_property_viewer_frame then
        local frame = frame_flow.add {
            type = "frame",
            name = "surface_property_viewer_frame",
            caption = { "surface-property-viewer.title" },
            direction = "vertical"
        }
        frame.add {
            type = "label",
            caption = content,
        }
    end
end

GUI.destroy_button = function(player_index)
    local player = game.get_player(player_index)
    local button_flow = mod_gui.get_button_flow(player)
    if button_flow.surface_property_viewer_button then
        button_flow.surface_property_viewer_button.destroy()
    end
end

GUI.destroy_frame = function(player_index)
    local player = game.get_player(player_index)
    local frame_flow = mod_gui.get_frame_flow(player)
    if frame_flow.surface_property_viewer_frame then
        frame_flow.surface_property_viewer_frame.destroy()
    end
end


GUI.on_click = function(event)
    if event.element.name == "surface-property-viewer-button" then
        local player = game.get_player(event.player_index)
        local frame_flow = mod_gui.get_frame_flow(player)
        if frame_flow.surface_property_viewer_frame then
            GUI.destroy_frame(player.index)
        else
            GUI.create_frame(player.index, "Surface Properties")
        end
    end
end

return GUI
