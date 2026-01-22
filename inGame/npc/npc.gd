#@abstract ## means that the npc class is not supposed to be utilized on it's own
extends Control

@onready var OneDRoot = get_tree().get_current_scene().get_child(0)

@onready var Icon: TextureRect = $VBoxContainer/Icon
@onready var HP: TextureProgressBar = $VBoxContainer/LowerBar/HP
@onready var CurrentHp: Label = $VBoxContainer/LowerBar/HP/HPBar/CurrentHP
@onready var MaxHp: Label = $VBoxContainer/LowerBar/HP/HPBar/MaxHP
@onready var DeBuffs: HBoxContainer = $VBoxContainer/DeBuffs

@onready var Animate: AnimationPlayer = $Animate

# Character Icon
@export var icon = Image

# stats
@export var speed_stat : int = 12

@export var max_hp: int = 40
var current_hp: int = max_hp:
	set(new):
		current_hp = clamp(new, 0, max_hp)
		
		if HP.value > current_hp:
			visual_hp(current_hp)
		elif HP.value < current_hp:
			visual_hp(current_hp)

@export var attack_stat : int = 3
@export var defend_stat : int = 5


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
var action_victim : Node

var is_dead = false
var size_transition = 0.0:
	set(new):
		size_transition = new
		size_flags_stretch_ratio = size_transition
		set_deferred("HP.size_flags_stretch_ratio", size_transition)

const DE_BUFF_RECT = preload("uid://b2tkettp813ev")

func _ready() -> void:
	set_max_hp(max_hp)
	Icon.texture = icon
	
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
	
	max_hp = new_hp
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

#for some reason, if you call a Callable as a Callable, the function doesn't go through
func do_intended_action() -> void:
	current_defense = 0
	
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

func take_debuff(debuff_resource, add_expiration):
	var node_with_debuff = check_debuff(debuff_resource.debuff_type)
	
	if node_with_debuff:
		node_with_debuff.expiration += add_expiration
	else:
		var child = DE_BUFF_RECT.instantiate()
		child.debuff = debuff_resource
		DeBuffs.add_child(child)
		child.expiration = add_expiration
	

func defend():
	self.current_defense += defend_stat
	Animate.play("defend")
	$DoDefend.play() 

func attack() -> void:
	if action_victim:
		action_victim.take_damage(attack_stat, self)
		Animate.play("attack")
		$Attack.play()


func die() -> void:
	# lol keep in mind the wizard's death is unique
	# just because I wanted to add a dumb sound
	
	# you can only die once
	if is_dead == false:
		is_dead = true
		OneDRoot.remove_dead_actions(self)
		Animate.call_deferred("play", "die")
	
	$Death.play()
