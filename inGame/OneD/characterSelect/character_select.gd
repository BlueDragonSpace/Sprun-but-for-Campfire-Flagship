extends HBoxContainer

var characters_selected = 0
var character_array = []

# displaying stats upon button hover
@onready var BigIcon: TextureRect = $VBoxContainer/BigIcon
@onready var Info: Label = $VBoxContainer/Info
@onready var SubInfo: Label = $VBoxContainer/SubInfo
@onready var Stats: HBoxContainer = $VBoxContainer/Stats
@onready var ATK: Label = $VBoxContainer/Stats/VBoxContainer/HBoxContainer/ATK
@onready var DFD: Label = $VBoxContainer/Stats/VBoxContainer/HBoxContainer2/DFD
@onready var SPD: Label = $VBoxContainer/Stats/VBoxContainer/HBoxContainer3/SPD
@onready var MHP: Label = $VBoxContainer/Stats/VBoxContainer/HBoxContainer4/MHP
@onready var Moves: VBoxContainer = $VBoxContainer/Stats/Moves

@onready var CharacterChoosing: GridContainer = $VBoxContainer/CharacterChoosing

const CHARACTER_MOVE_DISPLAY = preload("uid://6xrqwkwvr6jp")

func _ready() -> void:
	Stats.visible = false

func button_info(info: String, sub_info: String, info_icon: Texture = preload("res://placeholderArt/myPixelArt/Bigg-1.png.png"), character_resource: GlobalCharaResource = null) -> void:
	BigIcon.texture = info_icon
	Info.text = info
	SubInfo.text = sub_info
	
	# whether or not there's a character resource, remove all the data
	for child in Moves.get_children():
		child.queue_free()
	
	if not character_resource == null:
		Stats.visible = true
		
		ATK.text = str(character_resource.attack_stat)
		DFD.text = str(character_resource.defend_stat)
		SPD.text = str(character_resource.speed_stat)
		MHP.text = str(character_resource.max_hp)
		
		for action in character_resource.new_action:
			var child = CHARACTER_MOVE_DISPLAY.instantiate()
			
			Moves.add_child(child)
			
			child.Icon.texture = action.icon
			child.Name.text = action.name
			child.Info.text = action.button_info
	else:
		Stats.visible = false

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
	button_info('Nice try.', 'Select a character, or else')

# end character select button is located in the root
# might be bad code


func _on_random_pressed() -> void:
	# chooses three random numbers from the total characters, then applies those to the buttons
	var total = CharacterChoosing.get_child_count() # the last button is the random button and doesn't count
	var array = []
	
	# adds nums to array (and deselects all buttons
	for num in range(total - 1):
		array.push_back(num)
		CharacterChoosing.get_child(num).button_pressed = false
	
	# deletes random nums in array until correct size
	for num in range(total - 4):
		array.pop_at(randi_range(0, array.size() - 1))
	
	# selects the characters not deleted
	for num in array:
		CharacterChoosing.get_child(num).button_pressed = true
