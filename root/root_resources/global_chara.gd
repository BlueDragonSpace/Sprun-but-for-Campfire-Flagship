class_name GlobalChara
extends GlobalNPC

@export var sprun_slots = 1
@export var sprun_active = 0

@export var new_actions : Array[Action]
@export_custom(PROPERTY_HINT_FLAGS, Action.PLAYER_TYPE) var player_type : int = 0


@export_group("1D Exclusive")
@export var frying_wires = 'little toot toot train'

@export_group("2D_exclusive")
@export var placeholder2d = "awesometastic"

@export_group("3D exclusive")
@export var placehodler3d = 'mspling iz fnu'
