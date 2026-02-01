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

func shield(defend_mult, sprun_loss : int) -> void:
	action_victim.current_defense += defend_stat * defend_mult
	
	set_sprun(sprun_active - sprun_loss)

const FIRE = preload("uid://ddyfivxukty2j")

func fireball(atk_mult, sprun_loss : int) -> void:
	action_victim.take_damage(attack_stat * atk_mult)
	
	action_victim.take_debuff(FIRE, 2)
	
	set_sprun(sprun_active - sprun_loss)

const FREEZE = preload("uid://bl67tpbwsavb3")

func chill(atk_mult, sprun_loss : int) -> void:
	action_victim.take_damage(attack_stat * atk_mult)
	action_victim.take_debuff(FREEZE, 2)
	set_sprun(sprun_active - sprun_loss)
# the move "Blizzard" uses the exact same code as the action for "Chill"
