class_name GlobalChara
extends GlobalNPC

@export var sprun_slots = 1
@export var sprun_active = 0

@export var new_action : Array[Action]
@export_custom(PROPERTY_HINT_FLAGS, Action.PLAYER_TYPE) var player_type : int = 0


@export_group("1D Exclusive")
@export var frying_wires = 'little toot toot train'
# possible: ATK, DFD, SPD, upgrade costs (but first get this working)

@export_group("2D_exclusive")
@export var placeholder2d = "awesometastic"

@export_group("3D exclusive")
@export var placehodler3d = 'mspling iz fnu'


# automatically sets the actions for the player, since custom player actions are in new_actions instead
const ATTACK = preload("uid://fe6kckp853qt")
const BIG_ATK = preload("uid://c0se36fsmgo7o")
const BUFF = preload("uid://ds1u2a18cppdb")
const DEFEND = preload("uid://bfl5bur20t3il")
const PASSING = preload("uid://ckrxohf0inp4t")
const SPRUN = preload("uid://46w2r3n41yw6")
const STUNNED = preload("uid://dsldqq7ppqvn6")

#var actions = []

func _init() -> void:
	# somehow, there isn't a resource equivalent to Node's _ready() function
	# weird
	# https://github.com/godotengine/godot-proposals/issues/296
	call_deferred("resource_ready")

func resource_ready()-> void:
	actions = [ATTACK, DEFEND, PASSING, SPRUN, BUFF, BIG_ATK, STUNNED]
