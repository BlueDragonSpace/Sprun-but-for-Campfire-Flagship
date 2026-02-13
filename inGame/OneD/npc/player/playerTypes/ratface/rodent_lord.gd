extends "res://inGame/OneD/npc/player/player.gd"

var rodent_names = ['Four', 'Casper', 'Rockton', 'Chrispytopher', 'Tortus, Archiduke of Portland', 'Hello', 'Yellow', 'Snuffles', 'Baxter', 'Porky', 'Without', 'Wan']

var rodent_count = 1

#const RAT = preload("uid://c02utralqt5h")
const PLAYER = preload("uid://bd0auisdvfagw")
const RAT_CHARA = preload("uid://c6xyom6hfsfnk")
const HAMSTER_CHARA = preload("uid://bugkb3icjvkwe")
const MOUSE_CHARA = preload("uid://b4a4w1fiyg3jt")

func call_rat() -> void:
	
	var rat = PLAYER.instantiate()
	rat.NPC_resource = RAT_CHARA
	OneDRoot.Charas.add_child(rat)
	rat.NPC_instance.name = recieve_name("Rat ")
	# the poison damage? currently implemented as a separate move

func call_mouse() -> void:
	var mouse = PLAYER.instantiate()
	mouse.NPC_resource = MOUSE_CHARA
	OneDRoot.Charas.add_child(mouse)
	mouse.NPC_instance.name = recieve_name("Mouse ")

func call_hamster() -> void:
	
	var hamster = PLAYER.instantiate()
	hamster.NPC_resource = HAMSTER_CHARA
	OneDRoot.Charas.add_child(hamster)
	hamster.NPC_instance.name = recieve_name("Hamster ")

func recieve_name(base: String) -> String:
	
	var return_name = null
	
	if rodent_names.size() > 0:
		var num = randi_range(0, rodent_names.size() - 1)
		return_name = rodent_names[num]
		rodent_names.remove_at(num) # makes sure the name doesn't reappear
	else:
		return_name = base + str(rodent_count)
		rodent_count += 1
	
	return return_name
