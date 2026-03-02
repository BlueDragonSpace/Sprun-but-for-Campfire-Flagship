extends Node

@export var Charas : Array[GlobalChara]
@export var Enemies : Array[GlobalEnemy]
#@export var Stats : Array[Resource]

enum DIMENSION {
	ZERO, # an infinite possibility
	ONE, # UI focus
	TWO, # can be bird-eye or head-on
	THREE, # a wild time
	FOUR, # an Angel's Wrath
}
@export var dimension = DIMENSION.ONE

@export var disable_dimension_shifting = true

@onready var OneDRoot: Control = $OneDRoot
@onready var ThreeDRoot: Node3D = $ThreeDRoot

@onready var Animate: AnimationPlayer = $Animate
@onready var MouseClick: AudioStreamPlayer = $MouseClick
@onready var MouseRelease: AudioStreamPlayer = $MouseRelease
@onready var KeyClick: AudioStreamPlayer = $KeyClick
@onready var KeyRelease: AudioStreamPlayer = $KeyRelease

const ONE_D_PLAYER = preload("uid://bd0auisdvfagw")
const ONE_D_ENEMY = preload("uid://cmoedndryju2o")

const THREE_D_PLAYER = preload("uid://crwqeuod3418")
const THREE_D_ENEMY = preload("uid://f25l2rpvo2h3")


#const OneDScriptBasicPlayer = preload("uid://sj0wnis8wnpb") # basic Player Script
#const OneDScriptKitty = preload("uid://dxc2eww7oejej") # Kitty's SCRIPT
#const OneDScriptWizerd = preload("uid://c22h5dc4inak1")


func _ready() -> void:
	
	change_dimension(dimension, null)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			MouseClick.play()
		elif event.is_released():
			MouseRelease.play()
	
	if Input.is_action_just_pressed("disable_mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("dimension_shift") and not disable_dimension_shifting:
		match dimension:
			DIMENSION.ONE:
				change_dimension(DIMENSION.THREE, dimension)
			DIMENSION.THREE:
				change_dimension(DIMENSION.ONE, dimension)
	
		# silly little click and release sound effects (Kinito.PET !!)
	if not event is InputEventMouseButton and not event is InputEventMouseMotion:
		if event and not event.is_echo() and not event.is_released():
			if not event.keycode > 200:
				KeyClick.pitch_scale = event.keycode / 100.0
			else:
				KeyClick.pitch_scale = 1.0
			KeyClick.play()
		elif event.is_released():
			if not event.keycode > 200:
				KeyRelease.pitch_scale = (event.keycode + 25.0) / 100.0
			else:
				KeyRelease.pitch_scale = 1.0
			KeyRelease.play()

# close eye animation needed upon 3D Ortho to/from Perspective
# 1 <-> 3 / 2: Background / Environment fades, character sprites *tween* to new position
# 2 <-> 3: Ortho screws everything up... needs pre

func change_dimension(next_dimension, prev_dimension) -> void:
	
	# if null, don't read anything new, just pass in whatever is in the Charas and Enemies data already
	if prev_dimension != null:
		Charas.clear()
		Enemies.clear()
	
	# puts the info in the local dimension, puts it in the root to read by the next dimension
	match(prev_dimension):
		DIMENSION.ONE: # woah emoji 😒😒😒😒💕💕
			# do charas
			for child in OneDRoot.Charas.get_children():
				Charas.append(child.NPC_instance)
				child.queue_free()
			# do enemies
			for child in OneDRoot.Enemies.get_children():
				Enemies.append(child.NPC_instance)
				child.queue_free()
			
			#OneDRoot.process_mode = Node.PROCESS_MODE_DISABLED
		
		DIMENSION.THREE:
			# do charas
			for child in ThreeDRoot.Charas.get_children():
				Charas.append(child.NPC_instance)
				child.queue_free()
			# do enemies
			for child in ThreeDRoot.Enemies.get_children():
				Enemies.append(child.NPC_instance)
				child.queue_free()
			
			ThreeDRoot.process_mode = Node.PROCESS_MODE_DISABLED
			
	
	
	# reads the info in the root, matches it to the current dimension
	match(next_dimension):
		DIMENSION.ONE:
			OneDRoot.process_mode = Node.PROCESS_MODE_INHERIT
			for chara in Charas:
				var child = ONE_D_PLAYER.instantiate()
				child.set_script(chara.one_d_script)
				child.NPC_resource = chara
				
				OneDRoot.Charas.add_child(child)
				child.set_max_hp(child.NPC_resource.max_hp)
			for enemy in Enemies:
				var child = ONE_D_ENEMY.instantiate()
				child.set_script(enemy.one_d_script)
				child.NPC_resource = enemy
				
				OneDRoot.Enemies.add_child(child)
				
			dimension = DIMENSION.ONE
			
			# set up the OneDRoot
			OneDRoot.Animate.play_backwards("global_transition_out")
			OneDRoot.initialize_game()
			
		DIMENSION.THREE:
			ThreeDRoot.process_mode = Node.PROCESS_MODE_INHERIT
			for chara in Charas:
				var child = THREE_D_PLAYER.instantiate()
				child.NPC_resource = chara
				child.position = Vector3(randi_range(10, 15), randi_range(3, 8), 0)
				
				ThreeDRoot.Charas.add_child(child)
			
			for enemy in Enemies:
				var child = THREE_D_ENEMY.instantiate()
				child.NPC_resource = enemy
				child.position = Vector3(-randi_range(10, 15), randi_range(3, 8), 0)
				
				ThreeDRoot.Enemies.add_child(child)
			
			dimension = DIMENSION.THREE
			
			OneDRoot.Animate.play("global_transition_out")
			OneDRoot.initialize_for_other_dimension(ThreeDRoot)
