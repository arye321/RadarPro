local super_radar_entity = table.deepcopy(data.raw["radar"]["radar"])
local super_radar_item = table.deepcopy(data.raw["item"]["radar"])
local super_radar_recipe = table.deepcopy(data.raw["recipe"]["radar"])

-- Item setup
-- Item setup
super_radar_item.name = "super-radar"
super_radar_item.place_result = "super-radar"
super_radar_item.order = "d[radar]-b[super-radar]"

-- robustly tint the icon red
if super_radar_item.icons then
    for _, icon_layer in pairs(super_radar_item.icons) do
        icon_layer.tint = {r=1, g=0.2, b=0.2, a=1}
    end
else
    super_radar_item.icons = {
        {
            icon = super_radar_item.icon,
            icon_size = super_radar_item.icon_size,
            icon_mipmaps = super_radar_item.icon_mipmaps,
            tint = {r=1, g=0.2, b=0.2, a=1}
        }
    }
    super_radar_item.icon = nil
end

-- Recipe setup
super_radar_recipe.name = "super-radar"
super_radar_recipe.result = "super-radar"
-- 10x ingredients cost
if super_radar_recipe.ingredients then
    for _, ingredient in pairs(super_radar_recipe.ingredients) do
        if ingredient.amount then
            -- Named format {type="item", name="x", amount=y}
            ingredient.amount = ingredient.amount * 10
        elseif ingredient[2] then
            -- Short format {"x", y}
            ingredient[2] = ingredient[2] * 10
        end
    end
end

-- Also multiply energy required (time)
super_radar_recipe.energy_required = (super_radar_recipe.energy_required or 0.5) * 10

-- Entity setup
super_radar_entity.name = "super-radar"
super_radar_entity.minable.result = "super-radar"
super_radar_entity.max_health = super_radar_entity.max_health * 10
super_radar_entity.fast_replaceable_group = "radar"

-- 10x range
super_radar_entity.max_distance_of_nearby_sector_revealed = 10 
super_radar_entity.max_distance_of_sector_revealed = 140

-- 10x energy usage
super_radar_entity.energy_per_sector = "100MJ"
super_radar_entity.energy_per_nearby_scan = "2500kJ"
super_radar_entity.energy_usage = "3MW"

-- Scale energy source buffer and input
if super_radar_entity.energy_source then
    super_radar_entity.energy_source.buffer_capacity = "350MJ"
    super_radar_entity.energy_source.input_flow_limit = "6MW"
end

-- Add a tint to the entity sprite so it looks different
local function tint_recursive(sprite)
    if sprite.layers then
        for _, layer in pairs(sprite.layers) do
            tint_recursive(layer)
        end
    else
        sprite.tint = {r=1, g=0.5, b=0.5, a=1}
        -- If it uses 'hr_version', tint that too
        if sprite.hr_version then
            tint_recursive(sprite.hr_version)
        end
    end
end

if super_radar_entity.pictures then
    tint_recursive(super_radar_entity.pictures)
end
-- Also handle if pictures is not layered (single picture) though vanilla radar is usually layered.

data:extend({super_radar_entity, super_radar_item, super_radar_recipe})
