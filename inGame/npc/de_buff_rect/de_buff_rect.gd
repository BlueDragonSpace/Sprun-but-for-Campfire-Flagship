extends TextureRect

# effectively like ActionButton, but cannot be pressed
# (and character select's buttons, but those could be pressed...)

# needs a DeBuff resource to function properly
@export var debuff = Resource

#@export var de_buff_name = 'stronged'
#@export var info = 'minor texts'

const NOTIF = preload("uid://ccl3stwaax0r3")

func _ready() -> void:
	texture = debuff.icon

func debuff_info(main, sub):
	var notif = NOTIF.instantiate()
	notif.main_text = main
	notif.sub_text = sub
	add_child(notif)

func _on_mouse_entered() -> void:
	debuff_info(debuff.display_name, debuff.info)


func _on_mouse_exited() -> void:
	# makes all notifs fade away (or none, if there aren't any somehow)
	for child in get_children():
		if child.name == 'Animate':
			pass
		else:
			child.Animate.play('fade_up')
