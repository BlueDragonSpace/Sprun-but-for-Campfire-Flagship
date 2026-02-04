extends CheckBox

@export var info = 'baseplate textign'
@export var sub_info = 'less information cuz boring stats'
@export var info_icon = Texture2D
@export var linked_character = preload("uid://bd0auisdvfagw")

# Very similar in utilization to the ActionButton: Displays text on hover, does something when clicked
@onready var CharacterSelect = %CharacterSelect

func _on_mouse_entered() -> void:
	CharacterSelect.button_info(info, sub_info, info_icon)
