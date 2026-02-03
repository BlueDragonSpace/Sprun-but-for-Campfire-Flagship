extends Node3D

@onready var CurrentCamera : Camera3D = %CameraHandler.CurrentCamera
@onready var PathfindBot: CharacterBody3D = $PathfindBot


### Currently not in use
 #all blocks send their deepest regards to the root
 #in which the sorrowfully declare;
 #no pathfinding nor movement shall occur here
#var block_indexes : Array[Vector3i] = [] 

## yes this is in use 

# allows the mouse to click to pathfind (this was stolen from the official Godot 3D pathfind tutorial lol)
# to make this work you should probably turn off use_auto_timer
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Get closest point on navmesh for the current mouse cursor position.
		var mouse_cursor_position = event.position
		var camera_ray_length := 1000.0
		var camera_ray_start := CurrentCamera.project_ray_origin(mouse_cursor_position)
		var camera_ray_end := camera_ray_start + CurrentCamera.project_ray_normal(mouse_cursor_position) * camera_ray_length

		var closest_point_on_navmesh := NavigationServer3D.map_get_closest_point_to_segment(
			get_world_3d().navigation_map,
			camera_ray_start,
			camera_ray_end
			)
		PathfindBot.Nav.set_target_position(closest_point_on_navmesh)
		PathfindBot.Nav.get_final_position()
