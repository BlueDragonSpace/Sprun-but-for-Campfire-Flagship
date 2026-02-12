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

# convert into Sigilant ON
func shift_gear(_sprun_cost) -> void:
	# figure out bit shifting again
	# disable basic actions, turn on ON
	
	# if currently ON, turn off and go back to being basic and Sigilant
	
	# 2^0 = 1
	# 2^1 = 2
	# + 2 = Basic
	# 2^14 = Sigilant
	# 2^15 = Sigilant ON
	
	print(pow(2, 13) + 2)
	print(NPC_instance.player_type)
	
	# is sigilant + basic (in bitshift form)
	if NPC_instance.player_type == (pow(2, 13) + 2):
		NPC_instance.player_type = pow(2, 14) # turns to Sigilant ON
		Icon.self_modulate = Color(Color.BLUE)
		print('turned to on')
	else:
		# shifts back to regular
		NPC_instance.player_type = pow(2, 13) + 2
		Icon.self_modulate = Color(Color.WHITE)
		print('turned to off')
