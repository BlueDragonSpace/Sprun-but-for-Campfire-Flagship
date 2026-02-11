extends "res://inGame/OneD/npc/player/player.gd"


const SALVE = preload("uid://jh6814od43pa")

func salvation(sprun_cost) -> void:
	
	# adds the salve
	action_victim.take_debuff(SALVE, 99)
	
	# removes any debuffs
	for debuff_child in action_victim.DeBuffs.get_children():
		if debuff_child.debuff.is_bad:
			debuff_child.expiration = 0 # effectively kills the debuff immediately
	
	set_sprun(NPC_instance.sprun_active - sprun_cost)
