extends "res://root/global_npc_script.gd"

@onready var ThreeDRoot : Node3D = get_tree().get_first_node_in_group("ThreeDRoot")
@onready var CameraHandler : Node3D = ThreeDRoot.get_node("CameraHandler")

@onready var HPtext: MeshInstance3D = $HPtext

@export var NPC_resource : GlobalNPC
@onready var NPC_instance = NPC_resource.duplicate(true) # stats in use

@onready var Icon: Sprite3D = $Icon

const SPEED = 20.0
const JUMP_VELOCITY = 4.5

# redefining 3D properties because this initially inherits from a Node script
var position = Vector3(0,0,0)

var can_jump = true #this is actually based on camera lol

func _ready() -> void:
	name = NPC_instance.name
	Icon.texture = NPC_instance.icon
	
	HPtext.mesh.text = str(NPC_instance.current_hp)
