class_name AStarManhattan
extends AStar3D

# automatically calcuates for 3D
# Manhattan Distance
# how to link this thing? I have no idea, looking for support here
# by extent, calculating cost of a certain axis as free would be easy to implement, no?

@export var x_weight = 1.0
@export var y_weight = 1.0
@export var z_weight = 1.0

func _compute_cost(u, v):
	var u_pos = get_point_position(u)
	var v_pos = get_point_position(v)
	return abs(u_pos.x - v_pos.x) * x_weight + abs(u_pos.y - v_pos.y) * y_weight + abs(u_pos.z - v_pos.z) * z_weight

func _estimate_cost(u, v):
	return _compute_cost(u,v)

#func search(center: Vector3i, cube_size: int):
	## adds all points around in a cube for searching, and calculates the cost of going to each point
	#add_point(center)
	##
	##var path = get_point_path(0, 

func find_path(center: Vector3i, end: Vector3i, blocks: Array[Vector3i]) -> Array:
	add_point(0, center)
	add_point(1, end)
	
	# technically would be more economical to use a sphere, but this is easier
	var x_dist = abs(center.x - end.x) * x_weight
	var y_dist = abs(center.y - end.y) * y_weight
	var z_dist = abs(center.z - end.z) * z_weight
	var cube_size = max(x_dist, y_dist, z_dist) # takes the furthest distance along any axis
	
	var point_index = 2
	
	# plot points in a cube shape through the entire thing
	for x in range(-cube_size, cube_size + 1):
		for y in range(-cube_size, cube_size + 1):
			for z in range(-cube_size, cube_size + 1):
				
				for block in blocks:
					if Vector3i(x,y,z) == block:
						continue
				
				add_point(point_index, Vector3i(x, y, z))
				connect_points(point_index, get_closest_point(Vector3(x, y, z)))
				
				point_index += 1
	
	var path = get_point_path(0, 1)
	return path
