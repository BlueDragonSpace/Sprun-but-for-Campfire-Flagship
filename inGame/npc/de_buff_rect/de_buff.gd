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
	SALVE,
	
	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa, #spacer
	## DEBUFFS
	VULNERABLE, # take more attack damage
	WEAK, # do less attack damage
	FRAIL, # do less defense
}
@export var debuff_type = DEBUFF.STRENGTH

@export var display_name = 'base'
@export var info = 'what do debuff do'
@export var icon = Texture2D

# expiration in turns
@export var time_til_expiration = 1

enum EXPIRATION_TIME {
	NONE,
	PREP,
}
@export var special_expiration = EXPIRATION_TIME.NONE
