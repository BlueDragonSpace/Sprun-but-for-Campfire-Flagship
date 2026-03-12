extends Button

# surprisingly, this thing isn't directly correlated in code with the 
# -Action class or Resource
# (probably should be)

# info for the info bar
@onready var OneDRoot = get_tree().get_first_node_in_group("OneDRoot")

@export_multiline var info: String = 'default text... uwu'
@export var sprun_cost : int = 0
@export var atk_mult : float = 0.0
@export var dfd_mult : float = 0.0
@export var display_speed : bool = false
var display_heal : bool = false

@export_custom(PROPERTY_HINT_FLAGS, Action.PLAYER_TYPE) var usable_on_player: int = 0
@export var minion_num: int = 0 # 0 for not a minion, anything past is a minion
@export var prep_disable = false
@export var ally_target = false
var is_custom = false # was created as a part of a player script,

func check_cost(sprun: int) -> void:
	if sprun >= sprun_cost:
		disabled = false
	else:
		disabled = true

func send_info() -> void:
	$Focus.play()
	OneDRoot.button_info(info, sprun_cost, atk_mult, dfd_mult, display_speed, display_heal)

func _on_focus_entered() -> void:
	send_info()
func _on_mouse_entered() -> void:
	send_info()


func _on_pressed() -> void:
	$Click.play()
