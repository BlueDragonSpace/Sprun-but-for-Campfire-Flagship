extends Area3D

# selects an enemy in 3D space

signal clicked

@onready var mesh_instance_3D: MeshInstance3D = $MeshInstance3D

func _on_mouse_entered() -> void:
	mesh_instance_3D.mesh.material.albedo_color.a = 0.3


func _on_mouse_exited() -> void:
	mesh_instance_3D.mesh.material.albedo_color.a = 0.15


func _on_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("select"):
		clicked.emit()
