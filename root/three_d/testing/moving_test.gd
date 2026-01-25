extends CharacterBody3D

@onready var pathfind: NavigationAgent3D = $NavigationAgent3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	
	
	var path = pathfind.get_next_path_position()
	
	
	#position += velocity * delta
	position = path

func _on_timer_timeout() -> void:
	print('timer out')
	pathfind.target_position = %Player3D.global_position
	print(pathfind.target_position)
	print(%Player3D.global_position)
	print(pathfind.get_final_position())
	print(pathfind.is_navigation_finished())
	print("------")



func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	print('set_velocity')
	velocity = safe_velocity
