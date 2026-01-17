extends "res://inGame/player/player.gd"

func daggers(atk_mult, sprun_loss) -> void:
	
	for victim in OneDRoot.Enemies.get_children():
		victim.take_damage(attack_stat * atk_mult)
	
	action_victim.take_damage(attack_stat * atk_mult)
	
	set_sprun(sprun_active - sprun_loss)
	
	Animate.play("attack")
