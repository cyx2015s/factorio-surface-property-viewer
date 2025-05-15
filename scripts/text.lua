Text = {}

Text.localisers = {}
Text.refresh_surface_property_cache = function()
    storage.surface_property_cache = {}
    for _, surface_property in pairs(prototypes.surface_property) do
        storage.surface_property_cache[surface_property.name] = {
            is_time = surface_property.is_time,
            localised_name = surface_property.localised_name or { "surface-property-name." .. surface_property.name },
            localised_unit_key = surface_property.localised_unit_key or
                { "surface-property-unit" .. surface_property.name }
        }
    end
    return storage.surface_property_cache
end


Text.build_value_with_unit = function(surface_property, value)
    if Text.localisers[surface_property] then
        return remote.call(
            Text.localisers[surface_property].remote_interface,
            Text.localisers[surface_property].localiser,
            value
        )
    end
    if storage.surface_property_cache[surface_property].is_time then
        return { "spv.generic-time", value / 60 }
    end
    return { storage.surface_property_cache[surface_property].localised_unit_key, value }
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
    for surface_property, attrs in pairs(storage.surface_property_cache) do
        local value = surface.get_property(surface_property)
        ret_list[#ret_list + 1] = {
            "spv.kv-pair",
            attrs.localised_name,
            Text.build_value_with_unit(surface_property, value),
        }
    end
    if ret_list and ret_list[#ret_list] then
        ret_list[#ret_list][1] = "spv.kv-pair-noreturn"
    end
    return ret_list
end


Text.set_localiser = function(data)
    surface_property = data.surface_property
    remote_interface = data.remote_interface
    localiser = data.localiser
    if surface_property == nil or remote_interface == nil or localiser == nil then
        error(
            "All values must be provided. \nExample: \n/c remote.call('spv', 'set_localiser', {surface_property = 'your_surface_property' remote_interface = 'your_interface_name', localiser = 'your_function_name' })\n Your function must take a number as input and return a string or LocalisedString.")
    end
    ret = remote.call(remote_interface, localiser, 0)
    if type(ret) ~= "string" and type(ret) ~= "table" then
        error("localiser function must always return a string or LocalisedString. Got type " .. type(ret) .. " instead.")
    end
    Text.localisers[surface_property] = {
        remote_interface = remote_interface,
        localiser = localiser,
    }
end

Text.get_localiser = function(surface_property)
    return Text.localisers[surface_property]
end

Text.remove_localiser = function(surface_property)
    if Text.localisers[surface_property] then
        Text.localisers[surface_property] = nil
    end
end

return Text
