@tool
extends StaticBody3D

@onready var NavObs: NavigationObstacle3D = $NavigationObstacle3D


@export var sz = Vector3(1.0, 1.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	change_size(sz)

func change_size(size) -> void:
	$CollisionShape3D.shape.size = size
	$MeshInstance3D.mesh.size = size
	#$NavigationObstacle3D.vertices = []
	set_navigation_mesh(size)

func set_navigation_mesh(_size: Vector3) -> void:
	NavObs.vertices.clear()
	
	NavObs.vertices = [Vector3(2, 0, 3), Vector3(4, 0, 3), Vector3(27, 0, 1)]
	#print(NavObs.vertices)
