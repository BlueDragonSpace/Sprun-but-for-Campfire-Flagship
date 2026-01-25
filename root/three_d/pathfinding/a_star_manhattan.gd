class_name AStarManhattan
extends AStar3D

# automatically calcuates for 3D
# Manhattan Distance
# how to link this thing? I have no idea, looking for support here
# by extent, calculating cost of a certain axis as free would be easy to implement, no?

func _compute_cost(u, v):
	var u_pos = get_point_position(u)
	var v_pos = get_point_position(v)
	return abs(u_pos.x - v_pos.x) + abs(u_pos.y - v_pos.y) + abs(u_pos.z - v_pos.z)

func _estimate_cost(u, v):
	var u_pos = get_point_position(u)
	var v_pos = get_point_position(v)
	return abs(u_pos.x - v_pos.x) + abs(u_pos.y - v_pos.y) + abs(u_pos.z - v_pos.z)
