extends "res://inGame/npc/player/player.gd"

var rodent_names = ['Four', 'Casper', 'Rockton', 'Chrispytopher', 'Tortus, Archiduke of Portland', 'Hello', 'Yellow', 'Snuffles', 'Baxter', 'Porky', 'Without', 'Wan']

var rodent_count = 1

const RAT = preload("uid://c02utralqt5h")
const MOUSE = preload("uid://cuf5mh0vx3yms")
const HAMSTER = preload("uid://dvjh2m6c71u78")

func call_rat(sprun_cost : int) -> void:
	
	var rat = RAT.instantiate()
	rat.name = recieve_name("Rat ")
	OneDRoot.Charas.add_child(rat)
	set_sprun(sprun_active - sprun_cost)
	# poison damage? currently implemented as a separate move
	
	$RatSpawning.play()

func call_mouse(sprun_cost : int) -> void:
	var mouse = MOUSE.instantiate()
	mouse.name = recieve_name("Mouse ")
	OneDRoot.Charas.add_child(mouse)
	set_sprun(sprun_active - sprun_cost)
	
	$RatSpawning.play()

func call_hamster(sprun_cost : int) -> void:
	
	var hamster = HAMSTER.instantiate()
	hamster.name = recieve_name("Hamster ")
	OneDRoot.Charas.add_child(hamster)
	set_sprun(sprun_active - sprun_cost)
	
	$RatSpawning.play()

func recieve_name(base: String) -> String:
	
	var return_name = null
	
	if rodent_names.size() > 0:
		var num = randi_range(0, rodent_names.size())
		return_name = rodent_names[num]
		rodent_names.remove_at(num) # makes sure the name doesn't reappear
	else:
		return_name = base + str(rodent_count)
		rodent_count += 1
	
	return return_name
