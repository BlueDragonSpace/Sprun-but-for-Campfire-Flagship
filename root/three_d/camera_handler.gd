extends Node3D

@export var camera_speed = 20
var camera_zoom = 10.0:
	set(new):
		camera_zoom = new
		CurrentCamera.size = camera_zoom

@onready var Cameras: Node = $Cameras
@onready var InBetweenPath: Path3D = $InBetweenPath
@onready var InBetweenPathFollow: PathFollow3D = $InBetweenPath/PathFollow3D
@onready var InBetweenCamera: Camera3D = $InBetweenPath/PathFollow3D/InBetweenCamera
@onready var Animate: AnimationPlayer = $Animate

# short for direciton
enum DIR {X, Y, Z, NONE}
var invisible_direction = DIR.NONE

var CurrentCamera: Camera3D = null

var camera_type = 0
var camera_between_start_rotation = Vector3.ZERO # temp var for camera switch

enum CAMERA_DIRECTIONS {
	OVERHEAD,
	FORWARD,
	RIGHT,
}
@export var camera_direction = CAMERA_DIRECTIONS.OVERHEAD

signal camera_view_changing(direction, prev_direction)
signal camera_view_changed(direction)

func _ready() -> void:
	CurrentCamera = Cameras.get_child(camera_type)
	CurrentCamera.current = true
	CurrentCamera.size = camera_zoom
	invisible_direction = find_camera_direction(CurrentCamera.name) as DIR
	
	# prevents the pathFollow from rotating the cammera unnessesarily
	InBetweenPathFollow.rotation_mode = PathFollow3D.ROTATION_NONE 

func _process(delta: float) -> void:
	
	# Moving the Camera!!!!
	var input_dir = Input.get_vector("3DLeft", "3DRight", "3DBackward", "3DForward")
	var camera_dir = CurrentCamera.global_basis
	
	# looking down, UP/DOWN is wrong
	# looking forward, both are correct
	# looking right, LEFT/RIGHT is wrong
	
	match(invisible_direction):
		DIR.X:
			input_dir.x = -input_dir.x
		DIR.Y:
			input_dir.y = -input_dir.y
		# no case for Z-axis, since I can't really move the camera like dat
	
	position += Vector3(input_dir.x, input_dir.y, 0.0) * camera_dir * camera_speed * delta
	
	## Zooming the camera
	if Input.is_action_pressed("3DZoomIn"):
		camera_zoom -= delta * 3
	elif Input.is_action_pressed("3DZoomOut"):
		camera_zoom += delta * 3

func _unhandled_input(_event: InputEvent) -> void:
	
	# Switch the Camera
	if Input.is_action_just_pressed("CameraSwitch") and InBetweenCamera.current == false:
		camera_switch(null)

func camera_switch(_new_camera):
	
	InBetweenCamera.current = true
	InBetweenCamera.size = camera_zoom
	
	InBetweenCamera.rotation = CurrentCamera.rotation
	InBetweenPath.curve.clear_points()
	InBetweenPath.curve.add_point(CurrentCamera.position) ## Something with the next part of the code, not lerping yet, use a tween
	
	camera_between_start_rotation = CurrentCamera.rotation 
	
	var prev_camera_direction = CurrentCamera
	
	camera_type += 1
	if camera_type > Cameras.get_child_count() - 1:
		camera_type = 0
	
	CurrentCamera = Cameras.get_child(camera_type) # this is the next camera, now we have to switch to it
	CurrentCamera.size = camera_zoom
	
	InBetweenPath.curve.add_point(CurrentCamera.position)
	
	# if I remade this I wouldn't use this code...
	var bad_direction = find_camera_direction(CurrentCamera.name)
	
	camera_view_changing.emit(bad_direction, find_camera_direction(prev_camera_direction.name))
	
	# makes sure that the path follow doesn't curve in the direction of the path the inbetween camera takes
	InBetweenPathFollow.set_deferred("rotation", Vector3.ZERO)
	InBetweenPathFollow.rotation = Vector3.ZERO
	
	var tween = create_tween()
	tween.tween_property(InBetweenCamera, "rotation", CurrentCamera.rotation, 1.0)
	Animate.play("InBetweenCamera")

func finish_camera_switch():
	
	CurrentCamera.current = true
	CurrentCamera.rotation = InBetweenCamera.rotation
	
	invisible_direction = find_camera_direction(CurrentCamera.name) as DIR
	camera_view_changed.emit(invisible_direction)

func find_camera_direction(camera_name) -> int:
	
	# in relation to fez blocks, these are the three fez cameras
	
	var non_existant_direction_in_relation_to_the_camera = null
	
	match(camera_name):
		"Bird":
			non_existant_direction_in_relation_to_the_camera = DIR.Y
		"Head":
			non_existant_direction_in_relation_to_the_camera = DIR.Z
		"Head90":
			non_existant_direction_in_relation_to_the_camera = DIR.X
		_:
			non_existant_direction_in_relation_to_the_camera = DIR.NONE
	return non_existant_direction_in_relation_to_the_camera

##region AMALGAMATE CODE REFERENCE
#
##@onready var Animate: AnimationPlayer = $Animate
#
#### CAMERA stuff
##@export var camera_type = 0
##@export var fez_camera = false
##@export var camera_mouse_rotate = true
##@export var camera_lerp_speed = 0.12
##
##@onready var Cameras: Node = $Cameras
##@onready var InBetweenCamera: Camera3D = $InBetweenPath/PathFollow3D/InBetweenCamera
##@onready var InBetweenPath: Path3D = $InBetweenPath
##@onready var InBetweenPathFollow: PathFollow3D = $InBetweenPath/PathFollow3D
##var camera_between_start_rotation = Vector3.ZERO 
##enum CAMERA_DIRECTIONS {
	##OVERHEAD,
	##FORWARD,
	##RIGHT,
##}
##var camera_to_player_direction = CAMERA_DIRECTIONS.FORWARD
#
##signal camera_view_changing
##signal camera_view_changed
#
##var CurrentCamera: Camera3D = null
#@export_category("ANIMATION ONLY EXPORTS")
#@export var cameraAnimatePosition = 0.0 #from 0 to 1, aids in rotation and other value tweening
#
### End Camara stuff
#var can_jump = true #this is actually based on camera lol
#
##func _ready() -> void:
	##CurrentCamera = Cameras.get_child(camera_type)
	## HERE the camera isn't in Cameras so the CurrentCamera isn't correct
	#
	## clears the path3D (I would just leave it empty, but it causes an annoying error when I save)
	##InBetweenPath.curve.clear_points()
	##
	##if can_jump and CurrentCamera.name == "Bird":
		##print_rich("[color=red][b]Player can jump on start when they really shouldn't![/b][/color]")
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#
	### BASEPLATE (probably delete later in favor of ordering in terms of the camera)
	#var input_dir = Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
	### END BASEPLATE
	#
	##var input_dir = null
	## Get the input direction and handle the movement/deceleration.
	##if fez_camera:
		##CurrentCamera.rotation.x = clamp(CurrentCamera.rotation.x, -PI/2, PI/2)
		##
		##match(camera_to_player_direction):
			##CAMERA_DIRECTIONS.FORWARD:
				##input_dir = Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
				###move_camera(global_position.x, global_position.y)
			##CAMERA_DIRECTIONS.RIGHT:
				##input_dir = Input.get_vector("3DForward", "3DBackward", "3DRight", "3DLeft")
				###move_camera(-global_position.z, global_position.y)
			##CAMERA_DIRECTIONS.OVERHEAD:
				##input_dir = Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
				###move_camera(global_position.x, -global_position.z)
	##else:
		##input_dir = Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
	##var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	##if direction and CurrentCamera.current:
		##velocity.x = direction.x * SPEED
		##velocity.z = direction.z * SPEED
	##else:
		##velocity.x = move_toward(velocity.x, 0, SPEED)
		##velocity.z = move_toward(velocity.z, 0, SPEED)
	##
	##for child in Cameras.get_children():
		##match(child.name):
			##"Head":
				##move_camera(child, global_position.x, global_position.y)
			##"Head90":
				##move_camera(child, -global_position.z, global_position.y)
			##"Bird":
				##move_camera(child, global_position.x, -global_position.z)
	##
	## Handle jump.
	#if Input.is_action_just_pressed("3DJump") and is_on_floor() and can_jump:
		#velocity.y = JUMP_VELOCITY
	#move_and_slide()
	#
#
##func _process(_delta: float) -> void:
	##
	##if Input.is_action_just_pressed("Click"):
		##Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	##elif Input.is_action_just_pressed("Escape"):
		##Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	##
	##if Input.is_action_just_pressed("CameraSwitch"):
		##
		##InBetweenCamera.current = true
		##InBetweenCamera.rotation = CurrentCamera.rotation
		##InBetweenPath.curve.clear_points()
		##InBetweenPath.curve.add_point(CurrentCamera.position)
		##
		##camera_between_start_rotation = CurrentCamera.rotation 
		##
		##var prev_camera_direction = CurrentCamera
		##
		##camera_type += 1
		##if camera_type > Cameras.get_child_count() - 1:
			##camera_type = 0
		##CurrentCamera = Cameras.get_child(camera_type) #switches from before camera to after camera
		##
		##InBetweenPath.curve.add_point(CurrentCamera.position)
		##
		##var non_existant_direction_in_relation_to_the_camera = null
		###man how do I reline a single line again (like // or something?)
		##non_existant_direction_in_relation_to_the_camera = find_camera_direction(CurrentCamera.name)
		##camera_view_changing.emit(non_existant_direction_in_relation_to_the_camera,find_camera_direction(prev_camera_direction.name))
		##
		##Animate.play("InBetweenCamera")
	##
	### animating camera still
	### lerps the camera from start rotation to end rotation, based on it's ratio of being finished in the timeline
	##if Animate.current_animation == "InBetweenCamera":
		##InBetweenCamera.rotation = camera_between_start_rotation.lerp(CurrentCamera.rotation, cameraAnimatePosition)
		##
	### makes sure that the path follow doesn't curve in the direction of the path the inbetween takes
	##InBetweenPathFollow.set_deferred("rotation", Vector3.ZERO)
	##
	#
##func _input(event) -> void:
	#
	## this depends on the camera type...
	##if event is InputEventMouseMotion and InBetweenCamera.current == false:
	##if event is InputEventMouseMotion and camera_mouse_rotate:
		##rotation.y += -event.relative.x * .001
		##CurrentCamera.rotation.x += -event.relative.y * .001
##
##func finishCameraSwitch() -> void:
	##CurrentCamera.current = true
	##CurrentCamera.rotation = InBetweenCamera.rotation
	##
	##can_jump = true
	##
	##match(CurrentCamera.name):
		##"Head90":
			##camera_to_player_direction = CAMERA_DIRECTIONS.RIGHT
			##
		##"Head":
			##camera_to_player_direction = CAMERA_DIRECTIONS.FORWARD
			##
		##"Bird":
			##camera_to_player_direction = CAMERA_DIRECTIONS.OVERHEAD
			##
			##can_jump = false
	##
	##var temp_camera_direction = find_camera_direction(CurrentCamera.name)
	##camera_view_changed.emit(temp_camera_direction)
##
##func find_camera_direction(camera_name) -> String:
	##var non_existant_direction_in_relation_to_the_camera = null
	##match(camera_name):
		##"Bird":
			##non_existant_direction_in_relation_to_the_camera = "y"
		##"Head":
			##non_existant_direction_in_relation_to_the_camera = "z"
		##"Head90":
			##non_existant_direction_in_relation_to_the_camera = "x"
		##_:
			##non_existant_direction_in_relation_to_the_camera = "none"
	##return non_existant_direction_in_relation_to_the_camera
##
##func move_camera(camera, globalX, globalY) -> void:
	##camera.h_offset = move_toward(camera.h_offset, globalX, abs((camera.h_offset - globalX) * camera_lerp_speed))
	##camera.v_offset = move_toward(camera.v_offset, globalY, abs((camera.v_offset - globalY) * camera_lerp_speed))
##endregion
