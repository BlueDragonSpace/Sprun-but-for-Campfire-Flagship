extends TextureRect

# effectively like ActionButton, but cannot be pressed
# (and character select's buttons, but those could be pressed...)

@export var de_buff_name = 'stronged'
@export var info = 'minor texts'

const NOTIF = preload("uid://ccl3stwaax0r3")

func debuff_info(main, sub):
	var notif = NOTIF.instantiate()
	notif.main_text = main
	notif.sub_text = sub
	add_child(notif)

func _on_mouse_entered() -> void:
	debuff_info(de_buff_name, info)


func _on_mouse_exited() -> void:
	# makes all notifs fade away (or none, if there aren't any somehow)
	for child in get_children():
		child.Animate.play('fade_up')
