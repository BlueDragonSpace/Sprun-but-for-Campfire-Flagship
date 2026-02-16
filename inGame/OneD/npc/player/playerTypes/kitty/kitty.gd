extends "res://inGame/OneD/npc/player/player.gd"

func reflection() -> void:
	
	# the Dream that started it all
	
	set_max_hp(64) # minecraft stack!!
	NPC_instance.attack_stat = 12
	NPC_instance.defend_stat = 10
	NPC_instance.speed_stat = 99 # aka really freaking fast
	
	# base Dream
	set_sprun_slots(1)
	set_sprun(0)
	
	## turns into the Dream
	# 2^15 = Reflected Kitty
	# adding two gives basic actions (by bit-shifting)
	NPC_instance.player_type = pow(2,15) + 2
	Icon.self_modulate = Color(Color.BLUE)


const HIDE = preload("uid://24y2bom7sjw5")

# it's broken

func hideAction() -> void:
	
	# kitty debuffs themselves
	take_debuff(HIDE, 2)

const SALVE = preload("uid://jh6814od43pa")

func dream(defend_mult: int) -> void:
	# defends and gives a Salve to all allies
	action_victim.current_defense += NPC_instance.defend_stat * defend_mult
	action_victim.Animate.play("defend")
	$DoDefend.play()
	
	# adds the salve
	action_victim.take_debuff(SALVE, 99)
