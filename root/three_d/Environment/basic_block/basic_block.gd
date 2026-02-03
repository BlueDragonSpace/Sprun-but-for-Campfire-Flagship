@tool
extends StaticBody3D

@onready var NavObs: NavigationObstacle3D = $NavObs
@onready var NavReg: NavigationRegion3D = $NavReg


@export var sz = Vector3(1.0, 1.0, 1.0):
	set(new):
		sz = new
		
		if is_node_ready():
			change_size(sz)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	change_size(sz)
	pass
func change_size(size) -> void:
	$CollisionShape3D.shape.size = size
	$MeshInstance3D.mesh.size = size
	set_navigation_mesh(size)

func set_navigation_mesh(size: Vector3) -> void:
	
	# setting the navigation obstacle
	NavObs.vertices.clear()
	
	
	## on default 1x1x1:
#	 .5,   .5
#	-.5,   .5
#	-.5,  -.5
#	 .5,  -.5
	var x_sz = size.x / 2
	var z_sz = size.z / 2
	
	NavObs.vertices = [Vector3(x_sz, 0, z_sz), Vector3(-x_sz, 0, z_sz), Vector3(-x_sz, 0, -z_sz), Vector3(x_sz, 0, -z_sz)]
	
	# setting the navigation region
	NavReg.position.y = size.y - 0.5
	NavReg.scale.x = sz.x
	NavReg.scale.z = sz.z
	
