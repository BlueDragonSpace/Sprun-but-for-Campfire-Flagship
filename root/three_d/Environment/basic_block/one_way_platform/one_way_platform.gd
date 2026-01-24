@warning_ignore("missing_tool")
extends "res://root/three_d/Environment/basic_block/basic_block.gd"

@export var disable_one_way = false

# by default, this platform doesn't collide with the player.
# it takes the player interacting with it to turn it on.

var body_on_block : Node = null 
var player_on_block = false #on top of, as in the collider is on
var player_inside_block = false # inside of, as in it should move player on y-axis

@export var area_margin = 0.01 # the area is slightly larger than the collider

@onready var collider: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not disable_one_way:
		collider.set_deferred("disabled", true)

func change_size(size: Vector3, ignore_mesh: bool = false) -> void:
	$CollisionShape3D.shape.size = size
	if ignore_mesh == false:
		$MeshInstance3D.mesh.size = size
	
	$Area3D/CollisionShape3D.shape.size = Vector3(size) + Vector3(area_margin, area_margin * 2, area_margin) #this is why the function is redefined


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_on_block = body
	player_inside_block = true
	
	# if heading upward or not moving in the y-axis, turn the collider off
	if body.velocity.y < 0:
		collider.set_deferred("disabled", false)
		player_on_block = true
	else:
		collider.set_deferred("disabled", true)
	
	if disable_one_way:
		collider.set_deferred("disabled", false)

func _on_area_3d_body_exited(_body: Node3D) -> void:
	body_on_block = null
	player_inside_block = false
	
	# makes sure the collider is set to disabled when they come back to the platform
	collider.set_deferred("disabled", true)
	player_on_block = false
