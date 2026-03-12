@abstract
class_name GlobalNPC
extends Node

## core functionalities in action of all NPCs across the game
# I reccomend looking at the Inheritance Chart in the placeholder art if this doesn't serve as good
# - explaination for what this is
# gets inherited by the NPCs for all dimensions, which those in turn get inherited and turned into players or enemies later down the line
# this script isn't ever applied to a node / scene, but the ones specific to dimensions are

### ALL NPCs must have these nodes to be an NPC
# aka they all get defined later by the dimension 
# aka they are @abstract NodePaths i guess?
var DeBuffs : Node = null # container for DeBuffs
var Animate : AnimationPlayer = null # AnimationPlayer: must contain die, (lol forgot to add)
var Sound : Node = null # Any node that plays sound (interestingly, they aren't linked in the tree, and are separate by dimension...)

#########################################################################333333 </3

# variables
@export var NPC_resource : GlobalNPCResource # base stats
@onready var NPC_instance = NPC_resource.duplicate(true): # stats in use
	set(new):
		NPC_instance = new
		set_max_hp(NPC_instance.max_hp)

var intended_action = Callable(Global, "empty_function") # the actual code function part of the action
var intended_action_resource : Action # data for the intended_action

var action_victim : Node = null:
	set(new):
		action_victim = new
		visual_action_victim(action_victim)

var is_dead = false
@onready var current_hp: int = NPC_instance.current_hp:
	set(new):
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

# remembers the last action you took
var previous_action : Action.ACTION_TYPE = Action.ACTION_TYPE.OTHER

# this thing
@onready var OneDRoot = get_tree().get_first_node_in_group("OneDRoot")

# constants
const DE_BUFF_RECT = preload("uid://b2tkettp813ev") # Scene: notif for debuff
const STUNNED = preload("uid://dsldqq7ppqvn6") # Action: basically pass (this isn't the DeBuff)

## Functions
func check_debuff(debuff_type) -> Node: # returns if the debuff exists, and the Node connected to it
	var node = null
	
	for debuff_child in DeBuffs.get_children():
		if debuff_child.debuff.debuff_type == debuff_type:
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

func clease_deduffs(only_bad: bool = true):
	print('plz note this function is not tested yet!')
	
	for debuff_child in DeBuffs.get_children():
		
		if not debuff_child.debuff.is_bad and only_bad:
			pass # either it's a buff, or only_bad is off and it's cleasing all, good or bad
		else:
			debuff_child.debuff.expiration = 0

func remove_debuff(debuff_type):
	var node = check_debuff(debuff_type)
	node.expiration = 0

func die() -> void:
	
	# you can only die once (I don't reccomend trying to twice either)
	if is_dead == false:
		is_dead = true
		OneDRoot.remove_dead_actions(self)
		Animate.call_deferred("play", "die")

func do_intended_action() -> void:
	
	# visual_intent
	# visual_notif
	# OneDRoot to current_dimension (defined by Root)
	
	# if not fortified, lose all defense
	if not check_debuff(DeBuff.DEBUFF.FORTIFIED):
		current_defense = 0
	
	visual_intent(intended_action_resource, false)
	
	if intended_action_resource.sound:
		Sound.stream = intended_action_resource.sound
		Sound.play()
	
	# I don't really think the notif is necessary
	#visual_notif(intended_action_resource)
	
	
	if intended_action_resource.attack_all:
		# is it a player or an enemy?
		# is it targeting allies or the opposing side?
		
		# this is an XOR gate actually... too bad i don't know the keywords for one
		
		if (NPC_instance.is_player and not intended_action_resource.ally_target) or (not NPC_instance.is_player and intended_action_resource.ally_target):
			for enemy in OneDRoot.Enemies.get_children():
				action_victim = enemy
				intended_action.call()
		else:
			for chara in OneDRoot.Charas.get_children():
				action_victim = chara
				intended_action.call()
	else:
		intended_action.call()
	
	add_do_intended_action(intended_action_resource)

func set_intended_action(action: Action, callable : Callable = Callable(self, action.func_name), random: bool = false) -> void:
	
	# callable is passed in separately to action in case I need to .bind() something to the Callable
	# Keep in mind that Action is just a resource; a sheet of data
	# Callables are the actual functions that do the thing
	
	# this has nothing to do with the action_victim,
	# that must be set by other means (selction scene for charas, mostly randomly for enemies)
	
	if random:
		# generally, random is used for enemies. 
		# certain enemies have more complex attack patterns, but this is generally their code only
		
		var possible_actions = NPC_instance.actions.duplicate(true)
		
		# prevents defending twice in a row (defend must always be the second action for this to work right)
		if previous_action == Action.ACTION_TYPE.DEFEND:
			possible_actions.remove_at(1)
		
		var random_action = possible_actions[randi_range(0, possible_actions.size() - 1)]
		
		intended_action = Callable(self, random_action.func_name)
		visual_intent(random_action)
		intended_action_resource = random_action
	else:
		intended_action = callable
		visual_intent(action)
		intended_action_resource = action
	
	previous_action = intended_action_resource.action_type
	
	# if stunned, just overrule all of this junk
	if check_debuff(DeBuff.DEBUFF.STUN):
		visual_intent(STUNNED)
		intended_action = Callable(Global, "empty_function")
		intended_action_resource = STUNNED
	
	add_set_intended_action()

# basic Action actions lol
func defend():
	self.current_defense += NPC_instance.defend_stat
	Animate.play("defend")

func attack() -> void:
	if action_victim:
		action_victim.take_damage(NPC_instance.attack_stat, self)
		Animate.play("attack")

func big_attack():
	if action_victim:
		action_victim.take_damage(NPC_instance.attack_stat * 2.5, self)
		Animate.play("attack")

func passing() -> void:
	Global.empty_function()

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

# these should be abstract, but they're not always utilized (technically virtual, but I can't add custom virtual functions without GDExtension junk)
func add_take_damage(_attacker): # additional stuff I add to take_damage() in other classes (like enemy)
	pass

func add_do_intended_action(_action_res: Action):
	# for enemies, randomizes their stats
	# for players, spends sprun
	# at least in OneD (maybe I'll change for 3D)
	pass

func add_set_intended_action() -> void:
	pass

@abstract
func set_max_hp(new_hp: int) -> void # sets the max_hp, such as upon Kitty's Reflection
@abstract
func visual_hp(new_hp: int) -> void # displays the current_hp, instantly or by tween
@abstract
func visual_dfd(new_dfd: int) -> void # displays current defense
@abstract
func visual_action_victim(victim: Node) # OneD, changes intent, ThreeD looks at the victim
@abstract
func visual_intent(action: Action, visible: bool = true) # displays intent
@abstract
func visual_notif(action_resource: Action) # upon doing action, shows something on screen
