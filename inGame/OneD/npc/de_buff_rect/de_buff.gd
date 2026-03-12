class_name DeBuff
extends Resource

# All buffs and debuffs are "debuffs" within the system.
# It's a weird analogy for De/Buff, which makes sense, ok?

# Only HIDE currently works, working on more currently
enum DEBUFF {
	## NEITHER??
	NONE,
	
	## BUFFS
	#STRENGTH, # increase atk damage
	#FORTITUDE, # increase defense
	HIDE, # prevents being targeted, should be able to get attacked by group target, however
	SALVE, # prevent next debuff (pancea sts)
	FORTIFIED, # prevent losing defense on start of turn
	
	aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa, #spacer in the inspector, doesn't actually do anything lol
	## DEBUFFS
	#VULNERABLE, # take more attack damage
	#WEAK, # do less attack damage
	#FRAIL, # do less defense
	POISON, # less damage over time
	FIRE, # more damage over time
	FREEZE, # last in turn queue
	STUN, # action is disabled and / or switched with a "Pass"
	# prevent next buff debuff (haha kinda nuts there)
}
@export var debuff_type = DEBUFF.NONE

@export var display_name = 'base'
@export_multiline var info = 'what da debuff do'
@export var icon = Texture2D

@export var is_bad = false # bad as in you want to remove it
# expiration in turns
@export var expiration = 1

enum SPECIAL_EXPIRATION {
	NONE,
	PREP,
	NEVER,
}
@export var special_expiration = SPECIAL_EXPIRATION.NONE
