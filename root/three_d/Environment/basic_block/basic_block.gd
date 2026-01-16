@tool
extends StaticBody3D

@export var sz = Vector3(1.0, 1.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	change_size(sz)

func change_size(size) -> void:
	$CollisionShape3D.shape.size = size
	$MeshInstance3D.mesh.size = size
