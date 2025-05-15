Text = {}

Text.refresh_surface_property_cache = function()
    storage.surface_property_cache = {}
    for _, surface_property in pairs(prototypes.surface_property) do
        storage.surface_property_cache[surface_property.name] = surface_property.is_time
    end
    return storage.surface_property_cache
end


Text.build_value_with_unit = function(surface_property, value)
    if storage.surface_property_cache[surface_property] then
        -- is_time = true
        return { "spv.generic-time", value / 60 }
    end
    return { "surface-property-unit." .. surface_property, value }
end


---@class Text
---@field build_text fun(surface: LuaSurface): string | LocalisedString
Text.build_text = function(surface)
    local surface_name = surface.name
    local planet = surface.planet
    local planet_name = nil
    if planet then
        planet_name = planet.name
    end
    local platform = surface.platform
    local platform_name = nil
    if platform then
        platform_name = platform.name
    end
    ---@type LocalisedString
    local ret_list = { "" }
    ret_list[#ret_list + 1] = {
        "spv.kv-pair",
        { "spv.surface-name" },
        surface_name,
    }
    if planet_name then
        ret_list[#ret_list + 1] = {
            "spv.kv-pair",
            { "spv.planet-name" },
            { "",
                "[planet=" .. planet_name .. "]",
                { "space-location-name." .. planet_name }
            },
        }
    end
    if platform_name then
        ret_list[#ret_list + 1] = {
            "spv.kv-pair",
            { "spv.space-platform-name" },
            "[space-platform=" .. platform_name .. "]",
        }
    end
    for surface_property, is_time in pairs(storage.surface_property_cache) do
        local value = surface.get_property(surface_property)
        ret_list[#ret_list + 1] = {
            "spv.kv-pair",
            { "surface-property-name." .. surface_property },
            Text.build_value_with_unit(surface_property, value),
        }
    end
    if ret_list and ret_list[#ret_list] then
        ret_list[#ret_list][1] = "spv.kv-pair-noreturn"
    end
    return ret_list
end

return Text
