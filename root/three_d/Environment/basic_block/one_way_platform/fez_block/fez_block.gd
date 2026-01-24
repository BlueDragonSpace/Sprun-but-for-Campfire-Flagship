extends "res://root/three_d/Environment/basic_block/one_way_platform/one_way_platform.gd"

var defaultSz = null
var defaultPos = null
const player_y_safety = 1.601

@onready var CameraHandler = get_tree().get_first_node_in_group("CameraHandler")
@onready var area_collider: CollisionShape3D = $Area3D/CollisionShape3D

func _ready() -> void:
	defaultSz = sz
	defaultPos = position
	CameraHandler.connect("camera_view_changing", camera_change)
	CameraHandler.connect("camera_view_changed", camera_change_after)
	
	if %CameraHandler.CurrentCamera.name == "Bird":
		position.y = 0 # Fez Blocks aren't real

func camera_change(direction, previous_direction) -> void:
	
	#changes hitbox size
	sz = defaultSz
	position = defaultPos
	match(direction):
		CameraHandler.DIR.X:
			
			# reset position of rays
			$Rays/XRay.target_position.x = 0.6
			$Rays/XnRay.target_position.x = -.6
			
			while $Rays/XRay.is_colliding() == false and $Rays/XnRay.is_colliding() == false and sz.x < 100:
				$Rays/XRay.target_position.x += 0.5
				$Rays/XRay.force_raycast_update()
				
				$Rays/XnRay.target_position.x -= 0.5
				$Rays/XnRay.force_raycast_update()
				
				sz.x += 1
		CameraHandler.DIR.Y:
			sz.y = 0.1
			#position.y = 0.0 # after camera moves change position
		CameraHandler.DIR.Z:
			$Rays/ZRay.target_position.z = .6
			$Rays/ZnRay.target_position.z = -.6
			while $Rays/ZRay.is_colliding() == false and $Rays/ZnRay.is_colliding() == false and sz.z < 100:
				$Rays/ZRay.target_position.z += 0.5
				$Rays/ZRay.force_raycast_update()
				
				$Rays/ZnRay.target_position.z -= 0.5
				$Rays/ZnRay.force_raycast_update()
				
				sz.z += 1
	change_size(sz, true) #changes the hitbox and collider, but not the mesh art
	
	# teleports the player to be on the middle of this block, when the camera moves, if they're on it
	# only moves in the direction the camera can't see currently
	
	# I'm pretty sure this is related to the order of the cameras, (the previous direction, rather than the current one)
	if body_on_block:
		match (previous_direction):
		#match(direction):
			#"x":
				#Player.position.z = global_position.z
			#"y":
				#Player.position.x = global_position.x
			#"z":
				#pass
		#Player.position.y = global_position.y + player_y_safety #makes sure player lands on top of platform
			CameraHandler.DIR.X:
				body_on_block.position.x = global_position.x
			CameraHandler.DIR.Y:
				#Player.position.z = global_position.z
				pass
			CameraHandler.DIR.Z:
				body_on_block.position.z = global_position.z
				
			## Bird direction is y (previous was Head90 -> X)
			## Head dir -> Z (Previous was Bird -> y)
			## Head 90 -> X
		body_on_block.position.y = global_position.y + player_y_safety #makes sure player lands on top of platform
	if player_inside_block and previous_direction == CameraHandler.DIR.Y:
		body_on_block.position.y = global_position.y + player_y_safety #makes sure player lands on top of platform

func camera_change_after(direction) -> void:
	
	#gets restarted at the start(ing function)
	
	if direction == CameraHandler.DIR.Y and body_on_block:
		body_on_block.global_position.y = 0.5
		position.y = 0
