class_name GlobalEnemy
extends GlobalNPC

# generally, enemies are randomized
@export var hp_range     : int = 5
@export var speed_range  : int = 3
@export var attack_range : int = 4
@export var defend_range : int = 3
@export var wave_scaling : float = 1.0 ## should be set automatically based on wave count

#okee this isn't randomized actuallly
@export var show_intent : bool = true

## mysterious! "What evil_growl_sound?" They say, "I never found that!"
# and they go on a long winded ARG adventure to discover that nothing really matters
# and the evil_growl_sould literally does nothing at all
@export var evil_growl_sound = 'grhhrhrug'
# I do like ARGs actually
