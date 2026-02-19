extends "res://inGame/OneD/npc/npc.gd"

@onready var SprunContainer: Control = $VBoxContainer/Icon/SprunContainer

# Most export qualities are handled in the NPC_resource now

#@export var sprun_slots = 8 # ONLY CHANGE with set_sprun_slots()!!!!!!!!!!
@export_range(0, 360) var sprun_container_angle = 135
@export var sprun_distance = 60 ## wow that's pretty cool
const SPRUN = preload("uid://b6wgjet502thq")
#@export var sprun_active: int = 0 # ONLY CHANGE WITH set_sprun(new_sprun_count)!!!!!!!!!! 
# they would be an automatically set method in code but Godot throws errors on ready

const ACTION_BUTTON = preload("uid://drtw4kuprkapi")
 
# costs are listed in Sprun USD all purchases sold separately
var atk_upgrade_cost = 3
var dfd_upgrade_cost = 3
var spd_upgrade_cost = 3

# prevent adding new actions (such as when there are duplicate characters on purpose, such as rats)
var add_actions_bool = true

func add_ready() -> void:
	npc_type = CHARACTER_TYPE.PLAYER
	
	set_sprun_slots(NPC_instance.sprun_slots)
	
	if add_actions_bool:
		call_deferred("add_actions", NPC_instance.new_action)
		print('we addedah the actionah')
	else:
		print('refusing to add the actions')
	
	double_add_ready()

func double_add_ready() -> void:
	# at this point we may as well make this a running joke
	pass

func add_actions(custom_actions : Array) -> void:
	# every player has basics:
			# attack, defend, focus, pass
			# they also all have back button but that isn't controlled here
	
	for this_action in custom_actions:
		var new_button = ACTION_BUTTON.instantiate()
		new_button.info = this_action.button_info
		new_button.sprun_cost = this_action.sprun_necessary
		new_button.text = this_action.name
		new_button.usable_on_player = this_action.player_type
		new_button.prep_disable = this_action.prep_disable
		new_button.visible = false # Button needs to be visible for it to be used
		new_button.atk_mult = this_action.atk_mult
		new_button.dfd_mult = this_action.dfd_mult
		new_button.ally_target = this_action.ally_target
		
		if this_action.intent_type == Action.INTENT.HEAL:
			new_button.display_heal = true
		else:
			new_button.display_heal = false
		
		# why I didn't just link the resource? I have no idea
		# probably gonna end up refactoring this down the line cuz this is pretty awful
		
		@warning_ignore("standalone_expression")
		var lambda = func() : null
		var callable = Callable(self, this_action.func_name)
		
		match(this_action.action_type):
			0: ## ATTACK
				callable = callable.bind(this_action.atk_mult)
				
				# the callable is exclusively linked to the player that created it
				# even if another player had the same move, it calls the callable of the player that created it, instead of the current_player
				# I need a way to pass in the current_player that pressed it, in a similar way to the basic character actions
				
				
				# hmmmmmmmm... refactor
				if not this_action.is_quick:
					lambda = func(): 
						@warning_ignore("confusable_capture_reassignment")
						# confusing? yes
						# necessary for duplicate characters? also yes
						callable = add_lambda(this_action, callable)
						
						if this_action.needs_target:
							OneDRoot.initiate_select_enemy()
						else:
							OneDRoot.player_pass_turn()
				else:
					lambda = func():
						@warning_ignore("confusable_capture_reassignment")
						callable = add_lambda(this_action, callable)
						
						if this_action.needs_target:
							OneDRoot.initiate_select_enemy(true)
						else:
							OneDRoot.player_pass_turn()
							
				
			1: ## DEFEND
				callable = callable.bind(this_action.dfd_mult)
				lambda = func():
					@warning_ignore("confusable_capture_reassignment")
					callable = add_lambda(this_action, callable)
					
					if this_action.needs_target:
						if this_action.ally_target:
							OneDRoot.initiate_select_ally()
						else:
							OneDRoot.initiate_select_enemy()
					else:
						OneDRoot.player_pass_turn()
			_:
				lambda = func():
					@warning_ignore("confusable_capture_reassignment")
					callable = add_lambda(this_action, callable)
					
					if this_action.needs_target:
						if this_action.ally_target:
							OneDRoot.initiate_select_ally()
						else:
							OneDRoot.initiate_select_enemy()
					else:
						OneDRoot.player_pass_turn()
				
		new_button.connect("pressed", lambda)
		
		# 0 is Back Button, so everything past that is fair game
		OneDRoot.Actions.get_child(this_action.action_type + 1).add_child(new_button)

# additional things I call on *every* action getting call
func add_lambda(func_action: Action, callable: Callable) -> Callable:
	
	# detect the current player that is using the button, since it might not be the same as the one that made the button
	# especially important in terms of duplicates, like multiple Rat Bites
	
	#var callable = Callable(self, this_action.func_name)
	var da_player = OneDRoot.current_player
	print(da_player.name)
	var new_callable = Callable(da_player, func_action.func_name)
	
	# then do the boring stuff
	da_player.set_intended_action(func_action, callable)
	da_player.set_intent(func_action)
	
	return new_callable


func add_do_intended_action(action_res: Action) -> void:
	
	set_sprun(NPC_instance.sprun_active - action_res.sprun_loss)

func set_sprun(new_sprun_count):
	## I *would* set this as the set(new) method for active_sprun, but then it calls before ready and gives me an error
	
	NPC_instance.sprun_active = new_sprun_count
	
	# goes through and sets the individual spruns to be active or not
	for num in range(0, NPC_instance.sprun_slots):
		if num < NPC_instance.sprun_active:
			SprunContainer.get_child(num).active = true
		else:
			SprunContainer.get_child(num).active = false
	
	if NPC_instance.sprun_active > NPC_instance.sprun_slots:
		print('wow you over charged on sprun congrats')
		
	NPC_instance.sprun_active = clamp(NPC_instance.sprun_active, 0, NPC_instance.sprun_slots)

func set_sprun_slots(slots) -> void:
	
	NPC_instance.sprun_slots = slots
	
	# delete all intial sprun container children
	for child in SprunContainer.get_children():
		child.queue_free()
	
	for slot in range(0, slots):
		var sprun = SPRUN.instantiate()
		
		
		SprunContainer.add_child(sprun)
		sprun.pivot_offset.y -= sprun_distance
		sprun.position.y += sprun_distance
		@warning_ignore("integer_division")
		#sprun.position -= Vector2(128 / 2, 128 / 2) # 128 comes from the Godot Sprite's original dimensions
		
		
		@warning_ignore("integer_division")
		#sprun.visual_rotation += deg_to_rad(45/2)
		@warning_ignore("integer_division")
		sprun.visual_rotation += deg_to_rad(-sprun_container_angle/2)
		if NPC_instance.sprun_slots > 1:
			@warning_ignore("integer_division")
			sprun.visual_rotation += deg_to_rad(slot * sprun_container_angle / (NPC_instance.sprun_slots - 1))
	set_sprun(NPC_instance.sprun_active)
# player has it's intended actions set by the OneDRoot (because it's from input from the UI)

#func initiate_attack(action_name: String):
	#
	##self.intended_action = Callable(self, action_name)
	##set_intended_action()
	#OneDRoot.initiate_select_enemy()

func set_intent_target(image: Texture) -> void:
	IntendedTargetIcon.visible = true
	IntendedTargetIcon.texture = image

func big_attack():
	set_sprun(NPC_instance.sprun_active - 1)
	
	action_victim.take_damage(int(NPC_instance.attack_stat * 2.5), self)
	Animate.play("attack")
	$BigAttack.play()
func focus():
	set_sprun(NPC_instance.sprun_active + 1)
	$SprunGet.play()

func increase_sprun_slots():
	set_sprun(0)
	set_sprun_slots(NPC_instance.sprun_slots + 1)

func upgrade_atk():
	@warning_ignore("narrowing_conversion")
	NPC_instance.attack_stat *= 1.5
	set_sprun(NPC_instance.sprun_active - atk_upgrade_cost)
	atk_upgrade_cost += 2
	Animate.play("buff")

func upgrade_dfd():
	@warning_ignore("narrowing_conversion")
	NPC_instance.defend_stat *= 1.5
	set_sprun(NPC_instance.sprun_active - dfd_upgrade_cost)
	dfd_upgrade_cost += 2
	Animate.play("buff")

func upgrade_spd():
	@warning_ignore("narrowing_conversion")
	NPC_instance.speed_stat *= 1.5
	set_sprun(NPC_instance.sprun_active - spd_upgrade_cost)
	spd_upgrade_cost += 2
	Animate.play("buff")
