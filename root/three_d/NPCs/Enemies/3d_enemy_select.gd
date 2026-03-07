extends Area3D

# selects an enemy in 3D space

@onready var mesh_instance_3D: MeshInstance3D = $MeshInstance3D

func _on_mouse_entered() -> void:
	mesh_instance_3D.mesh.material.albedo_color.a = 0.3


func _on_mouse_exited() -> void:
	mesh_instance_3D.mesh.material.albedo_color.a = 0.15
