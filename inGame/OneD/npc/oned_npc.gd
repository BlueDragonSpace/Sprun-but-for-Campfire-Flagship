@abstract ## means that the npc class is not supposed to be utilized on it's own
class_name OneDNPC
extends GlobalNPC

# scene for every NPC represented in OneD

@onready var IntentBar: HBoxContainer = $VBoxContainer/IntentBar
@onready var Intent: TextureRect = $VBoxContainer/IntentBar/Intent
@onready var IntentLabel: Label = $VBoxContainer/IntentBar/Intent/IntentLabel
@onready var IntendedTargetIcon: TextureRect = $VBoxContainer/IntentBar/IntendedTargetIcon
@onready var IntentAnimate: AnimationPlayer = $VBoxContainer/IntentBar/IntentAnimate

@onready var Icon: TextureRect = $VBoxContainer/Icon
@onready var HP: TextureProgressBar = $VBoxContainer/LowerBar/HP
@onready var CurrentHp: Label = $VBoxContainer/LowerBar/HP/HPBar/CurrentHP
@onready var MaxHp: Label = $VBoxContainer/LowerBar/HP/HPBar/MaxHP

#@onready var Sound: AudioStreamPlayer = $Sound

#@export var NPC_resource : GlobalNPC # base stats
#@onready var NPC_instance = NPC_resource.duplicate(true): # stats in use
	#set(new):
		#NPC_instance = new
		#set_max_hp(NPC_instance.max_hp)

#@onready var current_hp: int = NPC_instance.current_hp:
	#set(new):
		#current_hp = clamp(new, 0, NPC_instance.max_hp)
		#NPC_instance.current_hp = current_hp
		#
		#if HP.value > current_hp:
			#visual_hp(current_hp)
		#elif HP.value < current_hp:
			#visual_hp(current_hp)
#
#@export var attack_stat : int = 3
#@export var defend_stat : int = 5

var current_intent = Action.INTENT.ATTACK
var intent_notif_info = ['None', 'No intent has been set yet.']
const NOTIF = preload("uid://ccl3stwaax0r3")
const AUTO_FADE_NOTIF = preload("uid://dr7fpgloton5f")

#@export var is_player : bool = false
#
#@export var actions : Array[Action]

# bad code: is it Npc or Character!
# and worst of all: Characters are contolled by Player, meaning that they are literal PCs instead of NPCs
enum CHARACTER_TYPE {ENEMY, PLAYER, NUHUH}
var npc_type = CHARACTER_TYPE.NUHUH # this class isn't intended to be used on it's own...

#var size_transition = 0.0:
	#set(new):
		#size_transition = new
		#size_flags_stretch_ratio = size_transition
		#set_deferred("HP.size_flags_stretch_ratio", size_transition)

func _ready() -> void:
	
	# intial setting up from global_npc_script
	DeBuffs = get_node("VBoxContainer/DeBuffs")
	Animate = get_node("Animate")
	Sound = get_node("Sound")
	
	# reading in 
	set_max_hp(NPC_instance.max_hp)
	Icon.texture = NPC_instance.icon
	name = NPC_instance.name
	
	#size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#size_flags_stretch_ratio = size_transition
	#HP.size_flags_stretch_ratio = size_transition
	
	add_ready()

# this function is meant to be added on to the ready function, by children, so they don't have to redefine ready
#@abstract
func add_ready() -> void:
	pass

func visual_hp(new_hp : int) -> void:
	
	var tween = create_tween()
	tween.tween_method(set_current_hp_text, HP.value, new_hp, 0.4)  # tweens the text
	# uses HP.value as from because that value currently hasn't been changed yet
	
	var other_tween = create_tween()
	other_tween.tween_property(HP, "value", new_hp, 0.3)

func set_current_hp_text(new_hp : int) -> void:
	CurrentHp.text = str(new_hp)

func set_max_hp(new_hp : int) -> void:
	
	NPC_instance.max_hp = new_hp
	current_hp = NPC_instance.max_hp # when max_hp is set, refill hp to full
	visual_hp(current_hp)
	HP.max_value = new_hp
	MaxHp.text = str(new_hp)

func visual_dfd(new_dfd: int) -> void:
	if new_dfd <= 0:
		$VBoxContainer/LowerBar/Shield.visible = false
	else:
		$VBoxContainer/LowerBar/Shield.visible = true
	$VBoxContainer/LowerBar/Shield/ShieldNum.text = str(new_dfd)

func visual_action_victim(victim: Node) -> void:
	IntendedTargetIcon.texture = victim.NPC_instance.icon

func visual_notif(_action_resource: Action) -> void:
	var notif = AUTO_FADE_NOTIF.instantiate()
	# displays name of move and it's number
	notif.text = intent_notif_info[0] # + "\n" + IntentLabel.text
	add_child(notif)

#for some reason, if you call a Callable as a Callable, the function doesn't go through

#func take_damage(damage, attacker = null, ignore_shield = false) -> void:
	#
	#if damage > 0:
		#if ignore_shield:
			#current_hp -= damage
			#Animate.play("take_hit")
		#else:
			#if current_defense > 0:
				#var undefended_damage = damage - current_defense
				#current_defense = clamp(current_defense - damage, 0, INF)
				#
				#if undefended_damage > 0:
					#current_hp -= undefended_damage
					#Animate.play("take_hit")
				#else:
					#$DefendAttack.play()
			#else:
				#current_hp -= damage
				#
		#if current_hp <= 0:
			#die()
			#
		#if attacker != null:
			#add_take_damage(attacker)
	#else:
		## it's a healing move
		#current_hp -= damage
		#Animate.play("heal")
#
#func add_take_damage(_attacker): # additional stuff I add to take_damage() in other classes (like enemy)
	#pass

func visual_intent(action: Action, visible: bool = true) -> void:
	
	if visible:
		IntentAnimate.play("show_intent")
		
		match(action.intent_type):
			Action.INTENT.ATTACK:
				IntentLabel.text = str(int(NPC_instance.attack_stat * action.atk_mult))
			Action.INTENT.DEFEND:
				IntentLabel.text = str(int(NPC_instance.defend_stat * action.dfd_mult))
			# wonder if there's a "or" statement for match statements...
			Action.INTENT.HEAL:
				IntentLabel.text = str(int(NPC_instance.defend_stat * action.dfd_mult))
			_:
				IntentLabel.text = '' # by default, there is no text on the Intent
		
		if action.show_target_intent:
			IntendedTargetIcon.visible = true
		else:
			IntendedTargetIcon.visible = action.show_target_intent
		Intent.texture = action.icon
		intent_notif_info = [action.name, action.button_info]
		
		if not NPC_instance.is_player:
			if not NPC_instance.show_intent:
				IntentBar.visible = false
				# lazy? probably. But it works
	else: # need to hide intent, likely from doing the action
		IntentAnimate.play("hide_intent")

func intent_info(main, sub):
	var notif = NOTIF.instantiate()
	notif.main_text = main
	notif.sub_text = sub
	Intent.add_child(notif)

func hide_intent() -> void:
	IntentAnimate.play("hide_intent")

# utilizing about the same code for DeBuffRect for displaying a Notif for intents
func _on_intent_mouse_entered() -> void:
	intent_info(intent_notif_info[0], intent_notif_info[1])

func _on_intent_mouse_exited() -> void:
	for child in Intent.get_children():
		if child.name == 'IntentLabel':
			pass
		else:
			child.Animate.play('fade_up')
