class_name GlobalNPC
extends Resource

## Main class of all NPCs in the game.
## This resource is just the data of each player_type, no matter what dimension

const DIMENSION = 'ZERO, ONE, TWO, THREE, FOUR'

@export_group("NPC") # wish this was a category...
@export var name : String = "Hi! My Name Is!"
@export var speed_stat : int = 5
@export var attack_stat : int = 6
@export var defend_stat : int = 5
@export var max_hp : int = 22
@export var is_player : bool = false
@export var actions : Array[Action] = []
@export_custom(PROPERTY_HINT_FLAGS, DIMENSION) var dimension_exist : int = 0
@export var npc_script : Script

@export_subgroup("1D Exclusive")
@export var icon : Texture2D

@export_subgroup("2D Exclusive")
@export var move_distance = 8
@export var size = Vector2(1, 1)

@export_subgroup("3D Exclusive")
@export var mesh : Mesh
