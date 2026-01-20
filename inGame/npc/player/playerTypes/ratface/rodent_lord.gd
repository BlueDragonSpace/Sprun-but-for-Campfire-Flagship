extends "res://inGame/npc/player/player.gd"

#func call_mouse() -> void:
	## cannot attack or dfd
	#pass
#
#func call_hamster() -> void:
	## chunky
	#pass

var rat_count = 1
var mouse_count = 1

const RAT = preload("uid://c02utralqt5h")
const MOUSE = preload("uid://cuf5mh0vx3yms")


func call_rat(sprun_cost : int) -> void:
	
	var rat = RAT.instantiate()
	rat.name = "Rat " + str(rat_count)
	OneDRoot.Charas.add_child(rat)
	set_sprun(sprun_active - sprun_cost)
	# poison damage?
	
	rat_count += 1
	$RatSpawning.play()

func call_mouse(sprun_cost : int) -> void:
	var mouse = MOUSE.instantiate()
	mouse.name = "Mouse " + str(mouse_count)
	OneDRoot.Charas.add_child(mouse)
	set_sprun(sprun_active - sprun_cost)
	
	mouse_count += 1
	$RatSpawning.play()
