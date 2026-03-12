extends Control

#0.8 :P:
	#Make sure when updating any stat, overrides the instance, doesn't override the base
	#I'd presume you would need to put local to scene if this isn't automatic
	#i.e. : attack_stat is increased for the character for this run, doesn't increase attack_stat for every run
	
# make sure stuff plz thanks

#const CHILL = preload("uid://crwrne4qrwn6y")
@export var CHILL : Action

var instant = null

func _ready() -> void:
	print(CHILL.sprun_loss)
	
	# says that false makes a shallow copy, but seems to always return deep copies
	# works for me anyway
	instant = CHILL.duplicate(true)
	
	print(instant.sprun_loss)

func _on_button_pressed() -> void:
	print('pressed button!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
	instant.sprun_loss += 1
	# 2 should be unaffected
	print(instant.sprun_loss)
	print(CHILL.sprun_loss)
