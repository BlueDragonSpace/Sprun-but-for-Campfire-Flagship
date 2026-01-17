extends "res://inGame/npc/player/player.gd"

@onready var WizerdAnimate: AnimationPlayer = $WizerdAnimate

func mega_lazer(atk_mult, sprun_loss) -> void:
	
	# link the static 7 to the number in the action!!!
	## Currently working on adding ATK and DFD values to the info bar
	
	action_victim.take_damage(attack_stat * atk_mult)
	WizerdAnimate.play("mega_lazer")
	
	set_sprun(sprun_active - sprun_loss) # ? blunder, this should be set inside of the action...
	
	$MegaLazer.play()

func die() -> void:
	# yup, redefined fo wizard funzies
	# probably gonna mess me up down the line, but funzies
	
	# you can only die once
	if is_dead == false:
		is_dead = true
		OneDRoot.remove_dead_actions(self)
		Animate.call_deferred("play", "die")
	
	$wawaawawawa.play()
