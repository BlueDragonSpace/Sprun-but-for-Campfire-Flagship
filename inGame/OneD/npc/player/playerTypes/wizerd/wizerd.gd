extends "res://inGame/OneD/npc/player/player.gd"


func mega_lazer(atk_mult, sprun_loss) -> void:
	
	# link the static 7 to the number in the action!!!
	## Currently working on adding ATK and DFD values to the info bar
	
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult)
	#WizerdAnimate.play("mega_lazer")
	
	set_sprun(NPC_instance.sprun_active - sprun_loss) # ? blunder, this should be set inside of the action...

func heal() -> void:
	action_victim.current_hp += 10

func shield(defend_mult) -> void:
	action_victim.current_defense += NPC_instance.defend_stat * defend_mult

const FIRE = preload("uid://ddyfivxukty2j")

func fireball(atk_mult) -> void:
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult)
	
	action_victim.take_debuff(FIRE, 2)

const FREEZE = preload("uid://bl67tpbwsavb3")

func chill(atk_mult) -> void:
	action_victim.take_damage(NPC_instance.attack_stat * atk_mult)
	action_victim.take_debuff(FREEZE, 2)
# the move "Blizzard" uses the exact same code as the action for "Chill"
