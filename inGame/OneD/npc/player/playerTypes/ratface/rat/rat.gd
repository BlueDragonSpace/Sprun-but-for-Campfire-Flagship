extends "res://inGame/OneD/npc/player/player.gd"

const POISON = preload("uid://cs3h8bsxt7jx4")

func bite(atk_mult) -> void:
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult)
	
	action_victim.take_debuff(POISON, 2)
