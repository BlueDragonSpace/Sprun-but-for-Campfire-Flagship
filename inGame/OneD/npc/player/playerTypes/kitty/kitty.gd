extends "res://inGame/OneD/npc/player/player.gd"

func reflection(_sprun_cost) -> void:
	
	# the dream that started it all
	
	set_max_hp(64) # minecraft stack!!
	NPC_instance.attack_stat = 12
	NPC_instance.defend_stat = 10
	NPC_instance.speed_stat = 1 # fastest possible
	
	# No, you aren't going to go for a second stat boost. I refuse to let this happen
	set_sprun_slots(1)
	set_sprun(0)
	
	$Reflecting.play()

const HIDE = preload("uid://24y2bom7sjw5")

# it's broken

func hideAction(_sprun_cost) -> void:
	
	# kitty debuffs themselves
	take_debuff(HIDE, 2)
	
	#var debuff_child = check_debuff(DeBuff.DEBUFF.HIDE) #finds the HIDE
	
	#if debuff_child:
		#print('found the hide, added 2')
		#debuff_child.expiration += 2
	#else:
		#var child = DE_BUFF_RECT.instantiate()
		#child.debuff = HIDE
		#DeBuffs.add_child(child)
