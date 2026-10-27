# Haztalyi architecture

A small farming game in LÖVE 11.5. Run it with `love src`.

## Libraries

All libraries are vendored as plain files under `src/lib/` (no submodules), trimmed to
their Lua sources and licenses. Require them by full path, e.g. `require('lib.hump.camera')`.

| Library | Used for |
|---|---|
| [Concord](https://github.com/Concord-Studio/Concord) | ECS: entities, components, systems, world resources |
| [hump](https://github.com/vrld/hump) | `gamestate` for screens, `camera` for follow/zoom; `timer`/`signal` available |
| [anim8](https://github.com/kikito/anim8) | sprite-sheet animations |
| [bump](https://github.com/kikito/bump.lua) | AABB collision for the player against trees and map edges |
| [bitser](https://github.com/gvx/bitser) | not used yet: reserved for save/load |

`classic` was removed: `hump.class` covers the same need, and the ECS means few classes are required.

## Layout

```
src/
  conf.lua, main.lua    LÖVE entry points (main only boots the menu state)
  config.lua            tunables and key bindings
  lib/                  vendored third-party code; never edit
  assets/graphics/      character/, animals/, objects/, tileset/ (snake_case names)
  core/assets.lua       cached image/quad/anim8-grid loading
  data/crops.lua        crop definitions (pure data)
  world/farm.lua        the tile grid: tilled soil, crop references, blocked tiles
  ecs/
    components.lua      every component, registered once
    entities.lua        factories: player, tree, crop
    systems/            one behaviour per file, see order below
  states/               menu, play, pause (hump.gamestate)
  ui/                   hud, menuList widget
```

## Conventions

- **Tiles are data, not entities.** The ground is a 2D array in `world/farm.lua`, drawn from
  a static sprite batch. Only things that change or move are entities: the player, trees, crops.
- **Shared services are world resources.** `play.lua` registers `farm`, `bump`, `camera` and
  `inventory` with `world:setResource()`; systems read them with `getResource()`. No globals.
- **Position is the entity's feet.** Sprites carry an origin offset, colliders hang from the
  feet, and rendering y-sorts on `position.y`.
- **Only the input system knows about keys.** It writes an `intent` component; other systems
  read intents. AI or replay can drive entities by writing intents too.
- **Every system file starts with `require('ecs.components')`**, because Concord validates
  component names when a system is defined.

## System order (`states/play.lua`)

1. `input`: keyboard to `intent`
2. `movement`: `intent` to velocity and facing, moved through bump
3. `farming`: picks the target tile, then tills, plants or harvests
4. `growth`: advances crop stages over time
5. `animation`: chooses idle/walk per direction, updates the sprite frame
6. `camera`: smooth follow, clamped to the map, pixel-snapped
7. `render` (draw): ground, tile cursor, y-sorted sprites

## Next steps

- Day/night cycle and day-based growth (hump.timer), watering
- Save/load the farm grid and inventory with bitser
- House, fences and animals from the existing assets
- Selling produce and buying seeds
