extends Node

var dimension = 1

@onready var OneDRoot: Control = $OneDRoot
# @onready var ThreeDRoot: Node3D = $ThreeDRoot

@onready var Animate: AnimationPlayer = $Animate
@onready var MouseClick: AudioStreamPlayer = $MouseClick
@onready var MouseRelease: AudioStreamPlayer = $MouseRelease
@onready var KeyClick: AudioStreamPlayer = $KeyClick
@onready var KeyRelease: AudioStreamPlayer = $KeyRelease

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			MouseClick.play()
		elif event.is_released():
			MouseRelease.play()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dimension_shift"):
		Animate.play("dimension_shift_in")
	
		# click and release sound effect (Kinito.PET !!)
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

func dimension_shift() -> void:
	
	#new_dimension : int
	
	# turn off previous dimension
	match(dimension):
		1:
			OneDRoot.Animate.play('global_transition_out')
		2:
			pass
		3:
			pass
		4:
			print('out of the fourth')
		_:
			print('illegal dimension entered, what did you do')
	
	#dimension = new_dimension
