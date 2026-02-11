#@abstract ## means that the npc class is not supposed to be utilized on it's own
extends Control

## This thing is now depreciated! This was NPC before making it take a Chara Resource from the Root

@onready var OneDRoot = get_tree().get_current_scene().get_child(0)

@onready var IntentBar: HBoxContainer = $VBoxContainer/IntentBar
@onready var Intent: TextureRect = $VBoxContainer/IntentBar/Intent
@onready var IntentLabel: Label = $VBoxContainer/IntentBar/Intent/IntentLabel
@onready var IntendedTargetIcon: TextureRect = $VBoxContainer/IntentBar/IntendedTargetIcon
@onready var IntentAnimate: AnimationPlayer = $VBoxContainer/IntentBar/IntentAnimate

@onready var Icon: TextureRect = $VBoxContainer/Icon
@onready var HP: TextureProgressBar = $VBoxContainer/LowerBar/HP
@onready var CurrentHp: Label = $VBoxContainer/LowerBar/HP/HPBar/CurrentHP
@onready var MaxHp: Label = $VBoxContainer/LowerBar/HP/HPBar/MaxHP
@onready var DeBuffs: HBoxContainer = $VBoxContainer/DeBuffs

@onready var Animate: AnimationPlayer = $Animate
#
## Character Icon
#@export var icon = Image
#
## stats
#@export var speed_stat : int = 12
#
#@export var max_hp: int = 40

@export var NPC_resource : GlobalNPC # base stats
@onready var NPC_instance = NPC_resource.duplicate(true) # stats in use

@onready var current_hp: int = NPC_instance.max_hp:
	set(new):
		current_hp = clamp(new, 0, NPC_instance.max_hp)
		
		if HP.value > current_hp:
			visual_hp(current_hp)
		elif HP.value < current_hp:
			visual_hp(current_hp)
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

# preload actions
const STUNNED = preload("uid://dsldqq7ppqvn6")

# bad code: is it Npc or Character!
# and worst of all: Characters are contolled by Player, meaning that they are literal PCs instead of NPCs
enum CHARACTER_TYPE {ENEMY, PLAYER, NUHUH}
var npc_type = CHARACTER_TYPE.NUHUH # this class isn't intended to be used on it's own...

var current_defense : int = 0:
	set(new):
		if new <= 0:
			$VBoxContainer/LowerBar/Shield.visible = false
		else:
			$VBoxContainer/LowerBar/Shield.visible = true
		$VBoxContainer/LowerBar/Shield/ShieldNum.text = str(new)
		current_defense = new

var intended_action = Callable(Global, "empty_function")
var intended_action_resource : Action
var action_victim : Node = null:
	set(new):
		action_victim = new
		IntendedTargetIcon.texture = action_victim.NPC_instance.icon

var is_dead = false
var size_transition = 0.0:
	set(new):
		size_transition = new
		size_flags_stretch_ratio = size_transition
		set_deferred("HP.size_flags_stretch_ratio", size_transition)

const DE_BUFF_RECT = preload("uid://b2tkettp813ev")

func _ready() -> void:
	set_max_hp(NPC_instance.max_hp)
	Icon.texture = NPC_instance.icon
	name = NPC_instance.name
	
	#size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_stretch_ratio = size_transition
	HP.size_flags_stretch_ratio = size_transition
	
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
	current_hp = new_hp
	visual_hp(new_hp)
	HP.max_value = new_hp
	MaxHp.text = str(new_hp)

func check_debuff(debuff_in_question) -> Node: # returns if the debuff exists, and the Node connected to it
	var node = null
	
	for debuff_child in DeBuffs.get_children():
		if debuff_child.debuff.debuff_type == debuff_in_question:
			node = debuff_child
			break
	
	return node

func take_debuff(debuff_resource, add_expiration):
	var node_with_debuff = check_debuff(debuff_resource.debuff_type)
	
	if node_with_debuff: # already has that debuff, just add the number
		node_with_debuff.expiration += add_expiration
	else:
		var salve = check_debuff(DeBuff.DEBUFF.SALVE)
		if debuff_resource.is_bad and salve: # prevent bad debuff from salve
			salve.expiration = 0 
			# the "bad" debuff never gets added in the first place
		else: 
			# add the debuff
			var child = DE_BUFF_RECT.instantiate()
			child.debuff = debuff_resource
			DeBuffs.add_child(child)
			child.expiration = add_expiration
	

func set_intended_action(action: Action, callable : Callable = Callable(self, action.func_name), random: bool = false) -> void:
	
	# callable is passed in separately to action in case I need to .bind() something to the Callable
	# Keep in mind that Action is just a resource; a sheet of data
	# Callables are the actual functions that do the thing
	
	# this has nothing to do with the action_victim,
	# that must be set by other means (selction scene for charas, mostly randomly for enemies)
	
	if random:
		# generally, random is used for enemies. 
		# certain enemies have more complex attack patterns, but this is generally their code only
		var random_action = NPC_instance.actions[randi_range(0, NPC_instance.actions.size() - 1)]
		
		intended_action = Callable(self, random_action.func_name)
		set_intent(random_action, random_action.show_target_intent)
		intended_action_resource = random_action
	else:
		intended_action = callable
		set_intent(action)
		intended_action_resource = action
	
	# if stunned, just overrule all of this junk
	if check_debuff(DeBuff.DEBUFF.STUN):
		set_intent(STUNNED)
		intended_action = Callable(Global, "empty_function")
		intended_action_resource = STUNNED
	
	add_set_intended_action()

func add_set_intended_action() -> void: # virtual function, though actual virtual functions don't work the way I like...
	pass

#for some reason, if you call a Callable as a Callable, the function doesn't go through
func do_intended_action() -> void:
	
	current_defense = 0
	hide_intent()
	
	var notif = AUTO_FADE_NOTIF.instantiate()
	# displays name of move and it's number
	notif.text = intent_notif_info[0] # + "\n" + IntentLabel.text
	add_child(notif)
	
	if intended_action_resource.attack_all:
		# is it a player or an enemy?
		if NPC_instance.is_player:
			for enemy in OneDRoot.Enemies.get_children():
				action_victim = enemy
				intended_action.call()
		else:
			for chara in OneDRoot.Charas.get_children():
				action_victim = chara
				intended_action.call()
	else:
		intended_action.call()
 
func take_damage(damage, attacker = null, ignore_shield = false) -> void:
	
	if ignore_shield:
		current_hp -= damage
		Animate.play("take_hit")
	else:
		if current_defense > 0:
			var undefended_damage = damage - current_defense
			current_defense = clamp(current_defense - damage, 0, INF)
			
			if undefended_damage > 0:
				current_hp -= undefended_damage
				Animate.play("take_hit")
			else:
				$DefendAttack.play()
		else:
			current_hp -= damage
			
	if current_hp <= 0:
		die()
		
	if attacker != null:
		add_take_damage(attacker)

func add_take_damage(_attacker): # additional stuff I add to take_damage() in other classes (like enemy)
	pass

func defend():
	self.current_defense += NPC_instance.defend_stat
	Animate.play("defend")
	$DoDefend.play() 

func attack() -> void:
	if action_victim:
		action_victim.take_damage(NPC_instance.attack_stat, self)
		Animate.play("attack")
		$Attack.play()

func big_attack():
	if action_victim:
		action_victim.take_damage(NPC_instance.attack_stat * 2.5, self)
		Animate.play("attack")
		$Attack.play()

func passing() -> void:
	Global.empty_function()

func die() -> void:
	
	# you can only die once
	if is_dead == false:
		is_dead = true
		OneDRoot.remove_dead_actions(self)
		Animate.call_deferred("play", "die")
	
	$Death.play()

func set_intent(action: Action, target_visible : bool = false) -> void:
	
	IntentAnimate.play("show_intent")
	
	match(action.intent_type):
		Action.INTENT.ATTACK:
			IntentLabel.text = str(int(NPC_instance.attack_stat * action.atk_mult))
		Action.INTENT.DEFEND:
			IntentLabel.text = str(int(NPC_instance.defend_stat * action.dfd_mult))
		Action.INTENT.HEAL:
			IntentLabel.text = str(int(action.other_num))
		_:
			IntentLabel.text = '' # by default, there is no text on the Intent
	
	if target_visible:
		IntendedTargetIcon.visible = target_visible
	else:
		IntendedTargetIcon.visible = action.show_target_intent
	Intent.texture = action.icon
	intent_notif_info = [action.name, action.button_info]
	
	if not NPC_instance.is_player:
		if not NPC_instance.show_intent:
			IntentBar.visible = false
			# lazy? probably. But it works

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
