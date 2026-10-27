-- Crop definitions. Pure data: no LÖVE calls here.
--
-- Sprites come from objects/spring_crops.png, which is laid out in 16x32 cells:
-- each crop owns one row, columns 0..stages-1 are its growth stages,
-- column 7 is the seed packet and column 8 is the harvested item.
local crops = {
    { id = 'strawberry', name = 'Strawberry', row = 0, stages = 6, stageTime = 3.0 },
    { id = 'leek',       name = 'Leek',       row = 1, stages = 6, stageTime = 2.5 },
    { id = 'potato',     name = 'Potato',     row = 2, stages = 7, stageTime = 2.0 },
    { id = 'onion',      name = 'Onion',      row = 3, stages = 6, stageTime = 2.0 },
}

crops.SHEET = 'objects/spring_crops.png'
crops.CELL_WIDTH = 16
crops.CELL_HEIGHT = 32
crops.SEED_COLUMN = 7
crops.ITEM_COLUMN = 8

crops.byId = {}
for _, def in ipairs(crops) do
    crops.byId[def.id] = def
end

return crops
