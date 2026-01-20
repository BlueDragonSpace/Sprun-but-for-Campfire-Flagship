extends "res://inGame/npc/player/player.gd"

func daggers(atk_mult, sprun_loss) -> void:
	
	for victim in OneDRoot.Enemies.get_children():
		victim.take_damage(attack_stat * atk_mult)
	
	action_victim.take_damage(attack_stat * atk_mult)
	
	set_sprun(sprun_active - sprun_loss)
	
	Animate.play("attack")

func sneak_attack(atk_mult, sprun_loss) -> void:
	
	# note that this doesn't use the take_damage function, like above
	# this prevents the enemy from being killed, since it doesn't check if it's at 0 hp
	action_victim.current_hp -= attack_stat * atk_mult 
	
	set_sprun(sprun_active - sprun_loss)
	Animate.play("attack")
