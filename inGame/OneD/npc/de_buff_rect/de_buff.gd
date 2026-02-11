class_name DeBuff
extends Resource

# All buffs and debuffs are "debuffs" within the system.
# It's a weird analogy for De/Buff, which makes sense, ok?

# Only HIDE currently works, working on more currently
enum DEBUFF {
	## BUFFS
	STRENGTH, # increase atk damage
	FORTITUDE, # increase defense
	HIDE, # prevents being targeted, should be able to get attacked by group target, however
	SALVE, # prevent next debuff (pancea sts)
	
	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa, #spacer
	## DEBUFFS
	VULNERABLE, # take more attack damage
	WEAK, # do less attack damage
	FRAIL, # do less defense
	POISON, # less damage over time
	FIRE, # more damage over time
	FREEZE, # last in turn queue
	STUN, # action is disabled and / or switched with a "Pass"
	# prevent next buff debuff (haha kinda nuts there)
}
@export var debuff_type = DEBUFF.STRENGTH

@export var display_name = 'base'
@export_multiline var info = 'what da debuff do'
@export var icon = Texture2D

@export var is_bad = false # bad as in you want to remove it
# expiration in turns
@export var expiration = 1

enum SPECIAL_EXPIRATION {
	NONE,
	PREP,
}
@export var special_expiration = SPECIAL_EXPIRATION.NONE
