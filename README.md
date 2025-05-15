# Overview

This is a mod that allow you to view the current properties of the viewing surface.

## Scripting

Technically, all surface_properties are `number` types, but some mods encode other data in `number` form, and the number itself doesn't mean anything. You can register a localiser function to define the way a surface property is displayed. For example, you can test with the following code at run time:

```lua
remote.add_interface(
    "test_i",
    {
        test_f = function(value)
            return math.round(value / 10) / 100 .. "bar"
        end
    }
)

remote.call(
    "spv",
    {
        surface_property = "pressure",
        remote_interface = "test_i",
        localiser = "test_f",
    }
)

```

You can check the pressure at top left, it now displays the pressure in bar instead of hPa.

## TODO

- [ ] Auto detect surface properties that are intended to be hidden, and/or add another remote interface to hide them.