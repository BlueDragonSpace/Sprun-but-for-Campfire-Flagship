extends "res://inGame/npc/player/player.gd"

func reflection() -> void:
	
	# the dream that started it all
	
	set_max_hp(64) # minecraft stack!!
	attack_stat = 12
	defend_stat = 10
	speed_stat = 1 # fastest possible
	
	# No, you aren't going to go for a second stat boost. I refuse to let this happen
	set_sprun_slots(1)
	set_sprun(0)
	
	$Reflecting.play()

const HIDE = preload("uid://24y2bom7sjw5")

func hideAction() -> void:
	var hide_debuff = DE_BUFF_RECT.instantiate()
	hide_debuff.debuff = HIDE
	
	DeBuffs.add_child(hide_debuff)
