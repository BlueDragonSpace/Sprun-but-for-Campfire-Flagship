extends "res://inGame/OneD/npc/npc.gd"


#
#@onready var Intent: TextureRect = $VBoxContainer/IntentBar/Intent
#@onready var IntentLabel: Label = $VBoxContainer/IntentBar/Intent/IntentLabel
#@onready var IntendedTargetIcon: TextureRect = $VBoxContainer/IntentBar/IntendedTargetIcon
#

var node_is_ready = false # a small get around for INTENTS.ATTACK
var last_attacker : Node = null # remembers the last player to attack it


#@export var intent = Action.INTENT.ATTACK
#const NOTIF = preload("uid://ccl3stwaax0r3")
#
## intent textures
#const SWORD_ART = preload("uid://cl4v4yeo1gn2m")
#const SHIELD_ART = preload("uid://bvhkmrse4oqmm")
#const ATTENTIONS_ART = preload("uid://depk6jpfx32yl")

# random other icons
const BIGG_BLUE_1_PNG = preload("uid://bpyet5t7bpkww")
const LITTLE_BLUE_1_PNG = preload("uid://dtkrx4fskgr5r")
const RATTTTTTT_1_PNG = preload("uid://dmidkhslqal7n")

@export var hp_range = 5
@export var speed_middle_value = 3
@export var speed_range = 5
@export var attack_middle_value = 7
@export var attack_range = 2
@export var defend_middle_value = 5
@export var defend_range = 3
# REFERENCE: randi_range(middle_value + range, middle_value - range)


func add_ready() -> void:
	npc_type = CHARACTER_TYPE.ENEMY
	node_is_ready = true
	#set_max_hp(randi_range(max_hp - hp_range, max_hp + hp_range))
	
	# a really not good way to check which enemy type this is
	if randi_range(0, 3) > 2:
		if NPC_instance.max_hp < 25:
			NPC_instance.icon = LITTLE_BLUE_1_PNG
			
			if randi_range(0, 3) == 2:
				NPC_instance.icon = RATTTTTTT_1_PNG # like, 1 in 16 chance of this happening. Funny times. Yes this is a joke
				Icon.modulate.g = 0.2
				Icon.modulate.b = 0.2
		else:
			NPC_instance.icon = BIGG_BLUE_1_PNG

func add_take_damage(attacker) -> void:
	last_attacker = attacker

#func set_intended_action(victim: Node) -> void:
	## where *all* the magic happens
	#
	#speed_stat = randi_range(speed_middle_value - speed_range, speed_middle_value + speed_range)
	#
	##match(randi_range(0,1)):
		##0:
			##intended_action = Callable(self, "attack")
			###IntendedTargetIcon.visible = true
			###Intent.texture = SWORD_ART
			###intent = Action.INTENT.ATTACK
			###IntentLabel.text = str(attack_stat)
			##attack_stat = randi_range(attack_middle_value - attack_range, attack_middle_value + attack_range)
			##
		##1:
			##intended_action = Callable(self, "defend")
			##IntendedTargetIcon.visible = false
			##Intent.texture = SHIELD_ART
			##intent = Action.INTENT.DEFEND
			##IntentLabel.text = str(defend_stat)
			##defend_stat = randi_range(defend_middle_value - defend_range, defend_middle_value + defend_range)
			##
		##_:
			##print('unknown  (liek for realz) enemy attack type ')
	#
	#if last_attacker != null:
		#victim = last_attacker
		#last_attacker = null
	#
	#IntendedTargetIcon.texture = victim.icon
	#action_victim = victim
	#
	#add_set_intended_action()
#
#func add_set_intended_action() -> void:
	#pass

#func intent_info(main, sub):
	#var notif = NOTIF.instantiate()
	#notif.main_text = main
	#notif.sub_text = sub
	#Intent.add_child(notif)

#
## utilizing about the same code for DeBuffRect for displaying a Notif for intents
#func _on_intent_mouse_entered() -> void:
	#match intent:
		#INTENT.ATTACK:
			#intent_info('Attack', 'This enemy intends to attack.')
		#INTENT.DEFEND:
			#intent_info('Defend', 'This enemy intends to defend fromm damage.')
		#INTENT.CHARGING:
			#intent_info('Charging', 'Something big is coming...')
		#_:
			#intent_info('Unknown Intent', 'Please report this as a bug! This is an error safety case!')
#
#func _on_intent_mouse_exited() -> void:
	#for child in Intent.get_children():
		#if child.name == 'IntentLabel':
			#pass
		#else:
			#child.Animate.play('fade_up')
