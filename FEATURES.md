# Feature Roadmap - Sprun but for Campfire Flagship

This document organizes and clarifies the features for the game based on the to-do list and development priorities.

## Current Game Features (Implemented)

- ✅ Turn-based combat with multiple characters
- ✅ Action queue system
- ✅ Scaling mechanics
- ✅ Completely resizable to any resolution (Control Nodes)
- ✅ Player intents system
- ✅ 5 different enemy wave types
- ✅ Debuff system (Freeze, Poison)
- ✅ 2D and 3D dimension switching mechanics
- ✅ Blizzard attack (attack all enemies)
- ✅ Freeze debuff and Chill move
- ✅ Basic 3D pathfinding implementation

## In Progress (Version 0.9 - 1.0)

### 3D Pathfinding System
**Status:** Currently being worked on
**Description:** Custom pathfinding implementation for better control than Godot's default

**Requirements:**
- Pass array of all blocks to ThreeDRoot
- Complete pathfind function and link to node
- Verify path calculations work correctly
- Display pathfinding visualization

**Known Issues:**
- Takes too long to calculate
- Doesn't navigate well around obstacles

### Connections (Version 1.0)

#### Character System
- Move characters to be outside of one_d_root (for all dimensions)

#### Advanced Pathfinding
- Create new node inheriting from 3DPathfind
- Implement direction-based algorithms:
  - Y-Axis free movement
  - Z-Axis free movement
  - X-Axis free movement
- Manhattan Distance for grid-based system
- Consider GDExtension for performance

#### Grid-Based System
- Implement 2D and 3D grids
- Movement distance calculation
- Position shifting between dimensions (1D ↔ 2D ↔ 3D)

#### Attack System Improvements
- Hitboxes
- Environment blocking
- Line of Sight mechanics
- Ranged vs Melee attacks distinction
- Different targeting systems
- Rat spawning position logic

#### Camera System
- Beep-O Camera style (Mario + Rabbids)
- Default camera centered on specific point (not player)
- Move camera script to average position of all players
- Camera switching (already has input binding: E key)
- 3D camera controls (WASD for camera, IJKL for player movement)

#### Movement Tab
- Implement "Move" tab functionality
- Jump mechanics implementation

## High Priority Features (Version 1.5 - 2.0)

### Critical Bugs to Fix

#### Game-Breaking
- [ ] Strange rounding error between shown stat bar damage and actual inflicted damage
- [ ] Turn order point offset when enemies die

#### Important Bugs
- [ ] Intent shows random target sometimes (visual only, action is correct)
- [ ] Last player's actions show up during first player's animation

### Enemy System Refactor
- [ ] Structure enemy attacks as Actions (class_name)
- [ ] Add sprun for charge attacks
- [ ] Enable enemies to be reused as playable characters

## Medium Priority Features (Version 2.0 - 3.0)

### Debuffs & Status Effects
- [ ] Stone/Stun debuff (Mario + Rabbids style)

### Movement & Controls
- [ ] Sprun movement shifting based on character size
- [ ] Back button to undo action selection
- [ ] Hide unnecessary tabs (e.g., rat cannot defend)

### Visual Effects & Polish
- [ ] MegaLazer VFX (screen shake, connecting line, color change)
- [ ] Dialogue interactions (character-to-character, mid-battle)

### Battle Mechanics
- [ ] Cat Battle (special enemy with consequences)
- [ ] Turn limit until next wave (prevent stat farming)
- [ ] Differentiate between similar enemies and rats
- [ ] All characters get special attack when specific character is present
- [ ] Combined DEF and ATK actions

### UI/UX Improvements
- [ ] Create custom theme (buttons, sliders, etc.)
- [ ] Resize action tabs (mobile optimization)
- [ ] Auto-count/green text for sprun availability
- [ ] Settings menu
- [ ] Creative credits sequence (not boring rolling text)

### Character Features
- [ ] New attacks in new forms (Kitty, Sun Robot)
- [ ] Death saves system (Deltarune/DnD style)
- [ ] Kitty's 9 Lives mechanic

## Future Features (Version 4.0+)

### Polish & Juice
- [ ] Art and music
- [ ] Implement "Make it Juicy" principles
- [ ] Pixel-perfect screen resolution (1920x1080)

### Content Creation
- [ ] New actions
- [ ] New characters
- [ ] New enemies
- [ ] Progression/scaling systems

### Tutorial System
**Requirements:**
- Explain turn queue (top to bottom)
- Explain sprun usage vs sprun needed
- Show which character's turn it is
- Make it engaging and clear

## Low Priority / Nice to Have (Version 5.0+)

### Distribution
- [ ] Steam release
- [ ] Itch.io release
- [ ] Marketing outreach

### Advanced Features (Version 6.0 - Aspirational)
- [ ] Finish round when final enemy dies
- [ ] Different types of sprun (red for ATK, blue for DEF, etc.)

## Art Assets Needed

- [ ] Fire debuff sprite
- [ ] Speed stat icon
- [ ] Poison debuff sprite
- [ ] Berserk enemy sprite
- [ ] Charge-up enemy sprite
- [ ] Fireball effect
- [ ] Megalazer effect

## Enemy Concepts (Rodent Lord Rodents)

- Rats (poison + bite)
- Hamster (chunky/tank)
- Mouse (weak, easy to spawn)
- Porcupine (thorns/damage reflect)
- Flying Squirrels
- Chipmunks
- Beavers
- Capybaras
- Gophers
- Base Squirrel

## Design Quirks & Features

- Balance funny and serious tones
- "2...3...4!" counting system (Tangled Up reference)
- Looking up camera angle for size comparison
- Kitty needs 9 slots for 9 lives
- Mobile support (works by accident!)

## Turn Structure

1. **Player Input Phase**
2. **Middle Phase:**
   - Defense actions
   - Quick actions
   - Rest of actions (by timeline)
3. **End Phase**

## Player Tips (to document in-game)

- Tabs on Action Bar can be rearranged
- Beating final enemy immediately ends wave
- Prep rounds will always be at least two
- Aggro mechanics affect targeting

## Development Notes

### Refactoring Needed
- [ ] Animation tracks don't worry about unresolvable tracks
- [ ] Make HP changing set by tween (instead of process)
- [ ] Set one remaining .set() method in ready()
- [ ] Open slot for Action resource on ActionButton

### Known Quirks
- Putting an enemy in player section makes game freak out (no sprun slots)
- However, they can still defend perfectly fine

## Feature Request Process

For new feature requests, please include:

1. **Feature Name:** Clear, descriptive title
2. **Description:** What the feature does
3. **Priority:** Critical / High / Medium / Low
4. **Requirements:** Specific implementation details
5. **Dependencies:** What needs to be done first
6. **Assets Needed:** Art, sound, etc.
7. **Testing Criteria:** How to verify it works

## Version History

- **v0.0.4** (Current): Added Blizzard and Freeze moves, started 3D pathfinding
- **v0.0.3** (Milkyway Update): Player intents, 5 enemy wave types, debuff system
- Earlier versions focused on core turn-based mechanics

---

**Game Inspiration:** Slay the Spire, Mario + Rabbids, Balatro

**Development Platform:** Godot 4.6

**Current Focus:** 3D pathfinding and dimension-switching mechanics
