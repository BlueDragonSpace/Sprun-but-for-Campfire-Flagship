extends HBoxContainer

var characters_selected = 0
var character_array = []

@onready var BigIcon: TextureRect = $VBoxContainer/BigIcon
@onready var Info: Label = $VBoxContainer/Info
@onready var SubInfo: Label = $VBoxContainer/SubInfo

@onready var CharacterChoosing: GridContainer = $VBoxContainer/CharacterChoosing

func button_info(info: String, sub_info: String, info_icon: Texture = preload("res://placeholderArt/myPixelArt/Bigg-1.png.png")) -> void:
	BigIcon.texture = info_icon
	Info.text = info
	SubInfo.text = sub_info

func load_characters() -> void:
	for child in CharacterChoosing.get_children():
		if child.button_pressed:
			character_array.push_back(child.linked_character)

func check_characters_selected() -> void:
	characters_selected = 0
	
	for child in CharacterChoosing.get_children():
		if child.button_pressed:
			characters_selected += 1

func too_many_characters() -> void:
	button_info('NO.', 'Please choose 3 characters.')

func nice_try_buddy() -> void:
	# 0 Characters Selected
	# would probably throw an error if I allowed it
	button_info('Nice try.', 'Select a character, or else imma')

# end character select button is located in the root
# might be bad code
