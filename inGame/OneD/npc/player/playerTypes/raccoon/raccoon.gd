extends "res://inGame/OneD/npc/player/player.gd"

func daggers(atk_mult) -> void:
	
	for victim in OneDRoot.Enemies.get_children():
		victim.take_damage(NPC_instance.attack_stat * atk_mult)
	
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult)
	
	Animate.play("attack")

func sneak_attack(atk_mult) -> void:
	
	# note that this doesn't use the take_damage function, like above
	# this prevents the enemy from being killed, since it doesn't check if it's at 0 hp
	#action_victim.current_hp -= attack_stat * atk_mult 
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult, self, true) # ignores shields
	
	Animate.play("attack")

const POISON = preload("uid://cs3h8bsxt7jx4")

func inject_poison(atk_mult) -> void:
	
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult)
	
	action_victim.take_debuff(POISON, 3)
	
	Animate.play("attack")

const STUN = preload("uid://bqtkaq1hjyf3q")

func flashbang(_atk_mult) -> void:
	# doesn't deal damage
	action_victim.take_debuff(STUN, 1)
