extends "res://inGame/OneD/npc/enemy/enemy.gd"

const POISON = preload("uid://cs3h8bsxt7jx4")

func engross() -> void:
	
	action_victim.take_debuff(POISON, NPC_instance.attack_stat)
