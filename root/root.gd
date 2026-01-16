extends Node

var dimension = 1

@onready var OneDRoot: Control = $OneDRoot
# @onready var ThreeDRoot: Node3D = $ThreeDRoot

@onready var Animate: AnimationPlayer = $Animate

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dimension_shift"):
		Animate.play("dimension_shift_in")

# close eye animation needed upon 3D Ortho to/from Perspective
# 1 <-> 3 / 2: Background / Environment fades, character sprites *tween* to new position
# 2 <-> 3: Ortho screws everything up... needs pre

func dimension_shift(new_dimension : int) -> void:
	
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
	
	dimension = new_dimension
