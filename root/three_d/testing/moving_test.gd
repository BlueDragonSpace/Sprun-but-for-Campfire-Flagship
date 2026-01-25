extends CharacterBody3D

@onready var pathfind: NavigationAgent3D = $NavigationAgent3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(_delta: float) -> void:
	
	
	var path = pathfind.get_next_path_position()
	
	
	#position += velocity * delta
	position = path

func _on_timer_timeout() -> void:
	pathfind.target_position = %Player3D.global_position


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
