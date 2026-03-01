extends "res://root/global_npc_script.gd"

@onready var ThreeDRoot : Node3D = get_tree().get_first_node_in_group("ThreeDRoot")
@onready var CameraHandler : Node3D = ThreeDRoot.get_node("CameraHandler")

@onready var HPtext: MeshInstance3D = $HPtext
@onready var HPGreen: MeshInstance3D = $HPBar/Green
@onready var HPRed: MeshInstance3D = $HPBar/HPRed

@onready var Shield: MeshInstance3D = $Shield


@onready var Icon: Sprite3D = $Icon

const SPEED = 20.0
const JUMP_VELOCITY = 4.5

# redefining 3D properties because this initially inherits from a Node script
var position = Vector3(0,0,0)

var can_jump = true #this is actually based on camera lol

func _ready() -> void:
	
	# intial setting up from global_npc_script
	DeBuffs = get_node("DeBuffs")
	Animate = get_node("Animate")
	
	name = NPC_instance.name
	Icon.texture = NPC_instance.icon
	
	HPtext.mesh.text = str(NPC_instance.current_hp)
	Shield.visible = false

# abstract functions from global_npc_script
func set_max_hp(new_hp : int) -> void:
	
	NPC_instance.max_hp = new_hp
	
	# for every 10 hp, the bar increases in size by 1 meter
	HPRed.mesh.size.x = float(new_hp) / 10.0

func visual_hp(new_hp: int) -> void: # displays the current_hp, instantly or by tween
	HPGreen.mesh.size.x = float(new_hp) / 10.0

func visual_dfd(new_dfd: int) -> void: # displays current defense:
	if new_dfd <= 0:
		Shield.visible = false
	else:
		Shield.visible = true
