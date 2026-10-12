# Farming Simulator Game Design

## Overview
This document outlines the design for a generic farming simulator game built using LÖVE2D and the following libraries:
- anim8 (for sprite animations)
- bump (for collision detection)
- classic (for object-oriented programming)
- Concord (for Entity-Component-System architecture)
- hump (collection of utilities: camera, class, gamestate, signal, timer, vector)

## Core Architecture
The game uses an Entity-Component-System (ECS) architecture with Concord as the primary framework. This approach provides:
- Clear separation of concerns between data (components) and behavior (systems)
- Easy extension of new entity types and behaviors
- Efficient processing of similar entities through systems

## Systems
1. **InputSystem** - Captures and processes raw input from the player
2. **PlayerControlSystem** - Translates input into player actions and updates player-controlled entities
3. **PlantingSystem** - Handles the logic for planting seeds on tilled soil
4. **GrowthSystem** - Manages the growth progression of crops over time
5. **HarvestSystem** - Handles harvesting mature crops when interacted with
6. **RenderSystem** - Draws all visible entities using their sprite animations (anim8)
7. **CollisionSystem** - Uses bump.lua for collision detection and resolution
8. **CameraSystem** - Controls the game camera using hump.camera to follow the player
9. **StateSystem** - Manages game states (menu, playing, paused) using hump.gamestate

## Key Components

### Player Components
- **Position** (hump.vector): World coordinates of the player
- **Velocity** (hump.vector): Movement speed and direction
- **Sprite** (anim8 Animation): Current animation for rendering
- **InputState**: Tracks current input states (movement keys, action keys)

### Crop Components
- **Position** (hump.vector): World coordinates of the crop
- **Sprite** (anim8 Animation): Animation corresponding to current growth stage
- **GrowthStage** (integer): Current stage of growth (0=seed, 1-4=growing, 5=mature)
- **GrowthTimer** (float): Time remaining until next growth stage
- **CropType** (enum): Type of crop (wheat, corn, vegetables, etc.)

### Soil/Tile Components
- **Position** (hump.vector): World coordinates of the tile
- **Tilled** (boolean): Whether the soil has been tilled
- **Planted** (boolean): Whether a crop is currently planted
- **CropReference** (entity ID): Reference to the planted crop entity (if any)

### Tilemap Component
- **Width** (integer): Number of tiles horizontally
- **Height** (integer): Number of tiles vertically
- **TileData** (2D array): Grid storing tile information

## Data Flow

1. **Input Processing**
   - Raw input → InputSystem → Updates Player Components
   - Player actions (movement, planting) → PlayerControlSystem

2. **Interaction Systems**
   - Player action near tilled soil → PlantingSystem
     - Modifies Soil Components (sets Planted=true)
     - Creates new Crop Entity with appropriate components
   - Player action near mature crop → HarvestSystem
     - Removes Crop Entity
     - Updates Soil Component (sets Planted=false)
     - Provides player with harvested goods

3. **Game Logic Systems**
   - GrowthSystem
     - Updates all Crop Entities each frame
     - Decrements GrowthTimer
     - When timer reaches 0, advances GrowthStage
     - Updates Sprite to match new GrowthStage
   - RenderSystem
     - Processes all entities with Position and Sprite components
     - Uses anim8 to draw current frame of animation
   - CollisionSystem
     - Uses bump.lua to prevent player from moving through obstacles
     - Resolves collisions by adjusting player position
   - CameraSystem
     - Updates camera position to smoothly follow player
     - Uses hump.camera for smooth movement

4. **State Management**
   - StateSystem manages transitions between:
     - Menu State (main menu, options)
     - Play State (active gameplay)
     - Pause State (paused gameplay)
   - Only active state processes updates and renders

## Technical Implementation

### Library Usage
- **Concord**: 
  - Entity world creation and management
  - Component definition and registration
  - System registration and execution order
- **hump.gamestate**:
  - Clean separation of game states
  - Easy state transitions
  - Built-in update/draw callbacks for each state
- **anim8**:
  - Sprite sheet loading and frame extraction
  - Animation creation for player and crop growth stages
  - Efficient animation updates and drawing
- **bump**:
  - Collision world initialization with tilemap dimensions
  - Player entity registration for collision detection
  - Collision resolution during movement
- **hump.camera**:
  - Camera object creation and updating
  - Smooth following with configurable smoothing factor
  - Integration with LÖVE's drawing transformation
- **hump.timer**:
  - Crop growth timing mechanisms
  - Delayed actions for visual feedback
  - General-purpose timing utilities
- **hump.vector**:
  - Position and velocity calculations
  - Direction and movement vector operations
  - Distance calculations for interaction ranges
- **classic/hump.class**:
  - Tilemap class for managing grid data
  - GameManager for high-level game logic
  - Utility classes that don't fit the ECS model
- **LÖVE Built-in**:
  - Audio playback for sound effects and music
  - Graphics rendering foundation
  - Input handling (keyboard, mouse)

### Initialization Sequence
1. Load game assets (images, sounds, sprite sheets)
2. Initialize Concord world and register component types
3. Create and register all game systems with appropriate update order
4. Set up initial game state (menu state)
5. Load or generate initial tilemap
6. Create player entity with starting components
7. Transition to play state to begin gameplay

### Rendering Pipeline
1. Clear screen
2. Apply camera transformation (hump.camera)
3. RenderSystem draws:
   - Tilemap background
   - Soil tiles
   - Crop entities with appropriate growth stage animations
   - Player entity with directional animations
4. Remove camera transformation
5. Render UI elements (in screen space)
6. Present frame

### Collision Handling
1. Define collision world boundaries matching tilemap dimensions
2. Mark non-walkable tiles (water, rocks, etc.) as collision obstacles
3. Register player entity with appropriate collision dimensions (AABB)
4. During movement:
   - Calculate intended movement vector
   - Query collision world for potential collisions
   - Resolve collisions by adjusting movement
   - Apply final movement to player position

## Extensibility Points
1. **New Crop Types**: Add new CropType enum value and corresponding sprite animations
2. **New Interactions**: Create new systems for additional gameplay mechanics (fishing, animal husbandry)
3. **Visual Effects**: Add particle systems or temporary entities for feedback
4. **Audio**: Expand sound effect library for different actions and events
5. **UI Systems**: Add dedicated UI rendering system using LÖVE's graphics functions
6. **Save/Load**: Implement serialization of ECS world state for persistence

## Dependencies and Assumptions
- Requires LÖVE2D 0.9.x or 0.10.x (compatible with anim8 v2.1)
- Assumes sprite sheets are organized with consistent naming conventions
- Tilemap assumes uniform tile size for simplicity
- Growth timing assumes consistent frame rate or uses delta time appropriately
