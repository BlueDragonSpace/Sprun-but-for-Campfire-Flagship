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

@onready var OneDRoot: Control = $OneDRoot
@onready var ThreeDRoot: Node3D = $ThreeDRoot

@onready var Animate: AnimationPlayer = $Animate
@onready var MouseClick: AudioStreamPlayer = $MouseClick
@onready var MouseRelease: AudioStreamPlayer = $MouseRelease
@onready var KeyClick: AudioStreamPlayer = $KeyClick
@onready var KeyRelease: AudioStreamPlayer = $KeyRelease

const ONE_D_PLAYER = preload("uid://bd0auisdvfagw")
const THREE_D_PLAYER = preload("uid://crwqeuod3418")

const OneDScriptBasicPlayer = preload("uid://sj0wnis8wnpb") # basic Player Script
const OneDScriptKitty = preload("uid://dxc2eww7oejej") # Kitty's SCRIPT
const OneDScriptWizerd = preload("uid://c22h5dc4inak1")


func _ready() -> void:
	
	ThreeDRoot.process_mode = Node.PROCESS_MODE_DISABLED
	
	match(dimension):
		DIMENSION.ONE:
			OneDRoot.process_mode = Node.PROCESS_MODE_INHERIT
			for chara in Charas:
				var child = ONE_D_PLAYER.instantiate()
				
				child.set_script(chara.one_d_script)
				
				child.NPC_resource = chara
				
				
				OneDRoot.Charas.add_child(child)
		DIMENSION.THREE:
			ThreeDRoot.process_mode = Node.PROCESS_MODE_INHERIT
			for chara in Charas:
				var child = THREE_D_PLAYER.instantiate()
				child.NPC_resource = chara
				child.position = Vector3(randi_range(10, 15), randi_range(3, 8), 0)
				
				ThreeDRoot.Charas.add_child(child)
			
			OneDRoot.Animate.play("global_transition_out")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			MouseClick.play()
		elif event.is_released():
			MouseRelease.play()
	
	if Input.is_action_just_pressed("disable_mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dimension_shift"):
		dimension_shift(dimension, DIMENSION.TWO)
	
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

func dimension_shift(_from, to) -> void:
	
	#new_dimension : int
	
	# turn off previous dimension
	match(to):
		DIMENSION.ONE:
			pass
		DIMENSION.TWO:
			OneDRoot.Animate.play('global_transition_out')
		3:
			pass
		4:
			print('out of the fourth')
		_:
			print('illegal dimension entered, what did you do')
	
	#dimension = new_dimension
