extends ColorRect


@onready var MainText: Label = $VBoxContainer/MainText
@onready var SubText: Label = $VBoxContainer/SubText
@onready var Animate: AnimationPlayer = $Animate

var main_text = 'wow'
var sub_text = 'home'

func _ready() -> void:
	MainText.text = main_text
	SubText.text = sub_text
