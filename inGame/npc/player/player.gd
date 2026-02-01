extends "res://inGame/npc/npc.gd"

@onready var SprunContainer: Control = $VBoxContainer/Icon/SprunContainer

@export var sprun_slots = 8 # ONLY CHANGE with set_sprun_slots()!!!!!!!!!!
@export_range(0, 360) var sprun_container_angle = 135
@export var sprun_distance = 0 ## wow that's pretty cool
const SPRUN = preload("uid://b6wgjet502thq")
@export var sprun_active: int = 0 # ONLY CHANGE WITH set_sprun(new_sprun_count)!!!!!!!!!! 
# they would be an automatically set method in code but Godot throws errors on ready

@export var new_action: Array[Action]
@export_custom(PROPERTY_HINT_FLAGS, Action.PLAYER_TYPE) var player_type : int = 0

const ACTION_BUTTON = preload("uid://drtw4kuprkapi")
 
# costs are listed in Sprun USD all purchases sold separately
var atk_upgrade_cost = 3
var dfd_upgrade_cost = 3
var spd_upgrade_cost = 3


func add_ready() -> void:
	npc_type = CHARACTER_TYPE.PLAYER
	
	set_sprun_slots(sprun_slots)
	
	call_deferred("add_actions", new_action)
	
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
		
		# why I didn't just link the resource? I have no idea
		# probably gonna end up refactoring this down the line cuz this is pretty awful
		
		@warning_ignore("standalone_expression")
		var lambda = func() : null
		
		match(this_action.action_type):
			0: ## ATTACK
				var callable = Callable(self, this_action.func_name).bind(this_action.atk_mult, this_action.sprun_loss)
				
				 
				# hmmmmmmmm... refactor
				if not this_action.is_quick:
					lambda = func(): 
						add_lambda(this_action, callable)
						
						if this_action.needs_target:
							OneDRoot.initiate_select_enemy()
						else:
							OneDRoot.player_pass_turn()
				else:
					lambda = func():
						add_lambda(this_action, callable)
						
						if this_action.needs_target:
							OneDRoot.initiate_select_enemy(true)
						else:
							OneDRoot.player_pass_turn()
							
				
			1: ## DEFEND
				lambda = func():
					var callable = Callable(self, this_action.func_name).bind(this_action.dfd_mult, this_action.sprun_loss)
					
					add_lambda(this_action, callable)
					
					if this_action.needs_target:
						if this_action.ally_target:
							OneDRoot.initiate_select_ally()
						else:
							OneDRoot.initiate_select_enemy()
					else:
						OneDRoot.player_pass_turn()
			#2: ## SPRUN
				#lambda = func():
					#intended_action = Callable(self, this_action.func_name)
					#OneDRoot.player_pass_turn()
			_:
				lambda = func():
					
					var callable = Callable(self, this_action.func_name).bind(this_action.sprun_loss)
					
					add_lambda(this_action, callable)
					
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
func add_lambda(func_action: Action, callable: Callable) -> void:
	set_intended_action(func_action, callable)
	set_intent(func_action)

func set_sprun(new_sprun_count):
	## I *would* set this as the set(new) method for active_sprun, but then it calls before ready and gives me an error
	
	sprun_active = new_sprun_count
	
	# goes through and sets the individual spruns to be active or not
	for num in range(0, sprun_slots):
		if num < sprun_active:
			SprunContainer.get_child(num).active = true
		else:
			SprunContainer.get_child(num).active = false
	
	if sprun_active > sprun_slots:
		print('wow you over charged on sprun congrats')
		
	sprun_active = clamp(sprun_active, 0, sprun_slots)

func set_sprun_slots(slots) -> void:
	
	sprun_slots = slots
	
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
		if sprun_slots > 1:
			@warning_ignore("integer_division")
			sprun.visual_rotation += deg_to_rad(slot * sprun_container_angle / (sprun_slots - 1))
	set_sprun(sprun_active)
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
	set_sprun(sprun_active - 1)
	
	action_victim.take_damage(int(attack_stat * 2.5), self)
	Animate.play("attack")
	$BigAttack.play()
func focus():
	set_sprun(sprun_active + 1)
	$SprunGet.play()

func increase_sprun_slots():
	set_sprun(0)
	set_sprun_slots(sprun_slots + 1)

func upgrade_atk():
	@warning_ignore("narrowing_conversion")
	attack_stat *= 1.5
	set_sprun(sprun_active - atk_upgrade_cost)
	atk_upgrade_cost += 2
	Animate.play("buff")

func upgrade_dfd():
	@warning_ignore("narrowing_conversion")
	defend_stat *= 1.5
	set_sprun(sprun_active - dfd_upgrade_cost)
	dfd_upgrade_cost += 2
	Animate.play("buff")

func upgrade_spd():
	@warning_ignore("narrowing_conversion")
	speed_stat *= 1.5
	set_sprun(sprun_active - spd_upgrade_cost)
	spd_upgrade_cost += 2
	Animate.play("buff")
