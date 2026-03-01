@abstract
extends Node

## core functionalities in action of all NPCs across the game
# I reccomend looking at the Inheritance Chart in the placeholder art if this doesn't serve as good
# - explaination for what this is
# gets inherited by the NPCs for all dimensions, which those in turn get inherited and turned into players or enemies later down the line
# this script isn't ever applied to a node / scene, but the ones specific to dimensions are

### ALL NPCs must have these nodes to be an NPC
# aka they all get defined later by the dimension 
# aka they are @abstract NodePaths i guess?
var DeBuffs = null # container for DeBuffs
var Animate = null # AnimationPlayer: must contain die, 
# funny enough I always rename my AnimationPlayer nodes to Animate, just a quirk

#########################################################################333333 </3

# variables
@export var NPC_resource : GlobalNPC # base stats
@onready var NPC_instance = NPC_resource.duplicate(true): # stats in use
	set(new):
		NPC_instance = new
		set_max_hp(NPC_instance.max_hp)

var is_dead = false
@onready var current_hp: int = NPC_instance.current_hp:
	set(new):
		print(new)
		current_hp = clamp(new, 0, NPC_instance.max_hp)
		NPC_instance.current_hp = current_hp
		
		if display_hp > current_hp:
			visual_hp(current_hp)
		elif display_hp < current_hp:
			visual_hp(current_hp)
@onready var display_hp: int = current_hp

var current_defense : int = 0:
	set(new):
		current_defense = new
		visual_dfd(current_defense)

# this thing
@onready var OneDRoot = get_tree().get_first_node_in_group("OneDRoot")

# constants
const DE_BUFF_RECT = preload("uid://b2tkettp813ev") # Scene: notif for debuff
const STUNNED = preload("uid://dsldqq7ppqvn6") # Action: basically pass (this isn't the DeBuff)

## Functions
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

@abstract
func set_max_hp(new_hp: int) -> void # sets the max_hp, such as upon Kitty's Reflection
@abstract
func visual_hp(new_hp: int) -> void # displays the current_hp, instantly or by tween
@abstract
func visual_dfd(new_dfd: int) -> void # displays current defense

func die() -> void:
	
	# you can only die once (I don't reccomend trying to twice either)
	if is_dead == false:
		is_dead = true
		OneDRoot.remove_dead_actions(self)
		Animate.call_deferred("play", "die")

func take_damage(damage, attacker = null, ignore_shield = false) -> void:
	
	if damage > 0:
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
	else:
		# it's a healing move
		current_hp -= damage
		Animate.play("heal")

func add_take_damage(_attacker): # additional stuff I add to take_damage() in other classes (like enemy)
	pass
