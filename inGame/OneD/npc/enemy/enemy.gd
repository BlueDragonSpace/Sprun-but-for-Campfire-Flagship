extends "res://inGame/OneD/npc/npc.gd"

var node_is_ready = false # a small get around for INTENTS.ATTACK
var last_attacker : Node = null # remembers the last player to attack it
var last_action : Action.ACTION_TYPE = Action.ACTION_TYPE.OTHER # prevents defending twice in a row

# random other icons
const BIGG_BLUE_1_PNG = preload("uid://bpyet5t7bpkww")
const LITTLE_BLUE_1_PNG = preload("uid://dtkrx4fskgr5r")
const RATTTTTTT_1_PNG = preload("uid://dmidkhslqal7n")


func add_ready() -> void:
	npc_type = CHARACTER_TYPE.ENEMY
	
	randomize_stats(true)

func add_take_damage(attacker) -> void:
	last_attacker = attacker

# REFERENCE: randi_range(middle_value + range, middle_value - range)
func add_do_intended_action() -> void:
	
	randomize_stats()

func randomize_stats(include_max_hp: bool = false):
	# REFERENCE: randi_range(middle_value + range, middle_value - range)
	
	# also keep in mind that NPC_instance is the currently set properties
	# NPC_resource is the base set properties, where the instance comes from
	
	# i made these var names too long lol
	var inst = NPC_instance
	var res = NPC_resource
	
	inst.defend_stat = randi_range(res.defend_stat + inst.defend_range, res.defend_stat - inst.defend_range) * inst.wave_scaling
	inst.attack_stat = randi_range(res.attack_stat + inst.attack_range, res.attack_stat - inst.attack_range) * inst.wave_scaling
	inst.speed_stat = randi_range(res.speed_stat + inst.speed_range, res.speed_stat - inst.speed_range) * inst.wave_scaling
	
	if include_max_hp:
		set_max_hp(randi_range(res.max_hp + res.hp_range, res.max_hp - res.hp_range))
