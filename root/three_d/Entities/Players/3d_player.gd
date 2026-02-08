extends CharacterBody3D

@onready var ThreeDRoot : Node3D = get_tree().get_first_node_in_group("ThreeDRoot")
@onready var CameraHandler : Node3D = ThreeDRoot.get_node("CameraHandler")

@export var NPC_resource : GlobalChara
@onready var NPC_instance = NPC_resource.duplicate(true) # stats in use

@onready var Icon: Sprite3D = $Icon

const SPEED = 20.0
const JUMP_VELOCITY = 4.5

var can_jump = true #this is actually based on camera lol

func _ready() -> void:
	name = NPC_instance.name
	Icon.texture = NPC_instance.icon

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	## BASEPLATE (probably delete later in favor of ordering in terms of the camera)
	var input_dir = Input.get_vector("3DPlayerLeft", "3DPlayerRight", "3DPlayerForward", "3DPlayerBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and CameraHandler:
		position += Vector3(input_dir.x, input_dir.y, 0.0) * CameraHandler.CurrentCamera.global_basis * SPEED * delta
	
	if Input.is_action_just_pressed("3DJump") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()
