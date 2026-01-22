extends "res://inGame/npc/player/player.gd"

const POISON = preload("uid://cs3h8bsxt7jx4")

func bite(atk_mult, _sprun_cost) -> void:
	action_victim.take_damage(atk_mult * attack_stat)
	
	action_victim.take_debuff(POISON, 2)
