class_name ThreeDNPC
extends GlobalNPC

@onready var ThreeDRoot : Node3D = get_tree().get_first_node_in_group("ThreeDRoot")
@onready var CameraHandler : Node3D = ThreeDRoot.get_node("CameraHandler")

@onready var Art: Node3D = $Art
@onready var Intent: Sprite3D = $Art/Intent
@onready var HPText: MeshInstance3D = $HPText
@onready var HPGreen: MeshInstance3D = $HPBar/HPGreen
@onready var HPRed: MeshInstance3D = $HPBar/HPRed
@onready var Shield: MeshInstance3D = $Shield

# added for necessity of the OneDRoot
@onready var Icon: Sprite3D = $Art/Icon
@onready var IntendedTargetIcon: Sprite3D = $Art/IntendedTargetIcon


const SPEED = 20.0
const JUMP_VELOCITY = 4.5

# redefining 3D properties because this initially inherits from a Node script
# this does, in fact, change the properties on the 3D part of the Node3D, while changing the variable at the same time
#var position = Vector3(0,0,0)

var can_jump = true #this is actually based on camera lol

func _ready() -> void:
	
	# intial setting up from global_npc_script
	DeBuffs = get_node("DeBuffs")
	Animate = get_node("Animate")
	Sound = get_node("Sound")
	Intent = get_node("Art/Intent")
	
	name = NPC_instance.name
	Icon.texture = NPC_instance.icon
	
	HPText.mesh.text = str(NPC_instance.current_hp)
	Shield.visible = false

# abstract functions from global_npc_script
func set_max_hp(new_hp : int) -> void:
	
	NPC_instance.max_hp = new_hp
	
	# for every 10 hp, the bar increases in size by 1 meter
	HPRed.mesh.size.x = float(new_hp) / 10.0

func visual_hp(new_hp: int) -> void: # displays the current_hp, instantly or by tween
	HPGreen.mesh.size.x = float(new_hp) / 10.0
	HPText.mesh.text = str(new_hp)

func visual_dfd(new_dfd: int) -> void: # displays current defense:
	if new_dfd <= 0:
		Shield.visible = false
	else:
		Shield.visible = true

func visual_action_victim(_victim: Node):
	pass
	## rotates the entire character, but hey, it gets the point across
	#Art.look_at(victim.position)

func visual_intent(action: Action, visible: bool = true): # displays intent
	## HERE
	# later on, the symbol for the Action taken by players is gonna be displayed
	# - either on their symbol for the TurnQueue (or next to their physical location)
	# - for now this is just displaying it right on the player
	
	Intent.visible = visible
	Intent.texture = action.icon
	

func visual_notif(_action_resource: Action): # upon doing action, shows something on screen:
	# actually I don't really think I need this for 3D
	# it seems kinda unncessary for 1D as well since it's so hard to see, and it should be 
	# - fairly obvious what the action is given the visuals and sound from Animate
	pass
