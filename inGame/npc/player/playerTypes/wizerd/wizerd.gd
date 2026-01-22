extends "res://inGame/npc/player/player.gd"

@onready var WizerdAnimate: AnimationPlayer = $WizerdAnimate

func mega_lazer(atk_mult, sprun_loss) -> void:
	
	# link the static 7 to the number in the action!!!
	## Currently working on adding ATK and DFD values to the info bar
	
	action_victim.take_damage(attack_stat * atk_mult)
	WizerdAnimate.play("mega_lazer")
	
	set_sprun(sprun_active - sprun_loss) # ? blunder, this should be set inside of the action...
	
	$MegaLazer.play()

func heal(sprun_loss : int) -> void:
	action_victim.current_hp += 10
	
	set_sprun(sprun_active - sprun_loss)

const FIRE = preload("uid://ddyfivxukty2j")

func fireball(atk_mult, sprun_loss : int) -> void:
	action_victim.take_damage(attack_stat * atk_mult)
	
	var fire = action_victim.check_debuff(DeBuff.DEBUFF.FIRE)
	
	# add fire debuff
	if fire:
		print('adding to expiration of fire')
		fire.expiration += 1
	else:
		var child = DE_BUFF_RECT.instantiate()
		child.debuff = FIRE
		action_victim.DeBuffs.add_child(child)
	
	set_sprun(sprun_active - sprun_loss)
