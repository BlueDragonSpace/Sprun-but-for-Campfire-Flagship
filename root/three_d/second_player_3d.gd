extends CharacterBody3D

@onready var ThreeDRoot = get_tree().get_first_node_in_group("ThreeDRoot")

const AStarManhattanScript = preload("uid://tgfyjj5ftu2k")
@onready var AStarManhattanAccess = AStarManhattanScript.new()

@onready var Nav: NavigationAgent3D = $Nav
@onready var LineOfSight: RayCast3D = $LineOfSight

@onready var Player: Node3D = %Player

const GREEN_CIRCLE = preload("uid://dco50bis2p58v")
const YELLOW_LINE = preload("uid://cjpw7x1tm1uou")

@export var use_auto_timer := true

const SPEED = 20.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	## BASEPLATE (probably delete later in favor of ordering in terms of the camera)
	var input_dir = Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		position += Vector3(input_dir.x, input_dir.y, 0.0) * %CameraHandler.CurrentCamera.global_basis * SPEED * delta
	
	#if LineOfSight.is_colliding():
		#print('line of sight is colliding')

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("display_path"):
		print('displaying path')
		var path = AStarManhattanAccess.find_path(self.position, Player.position, ThreeDRoot.block_indexes)
		print(path)
		
		var prev_point = null
		
		# for debug display purposes
		for point in path:
			var circle = GREEN_CIRCLE.instantiate()
			circle.position = point
			add_child(circle)
			
			if prev_point:
				var line = YELLOW_LINE.instantiate()
				line.curve.add_point(point)
				line.curve.add_point(prev_point)
				add_child(line)


func _on_timer_timeout() -> void:
	
	if use_auto_timer:
		# navigation + pathfinding
		Nav.set_target_position(Player.global_position)
		Nav.get_final_position()
		
		# line of sight
		LineOfSight.target_position = Player.global_position - global_position
