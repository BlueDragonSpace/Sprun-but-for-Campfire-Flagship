extends "res://inGame/OneD/npc/enemy/enemy.gd"

var rats_spawned = 1

var rat_names = ["Jimmy", "Angela", "Thomas", "Borborygmi", "Floo", "Quark", "Gertrude", "Pumpernickel", "Slight", "Compromise", "Deernose", "Iro"]

const ONE_D_ENEMY = preload("uid://cmoedndryju2o")
const EVIL_RAT = preload("uid://b3cp265u1omur") # resource for it, rather than a scene


func spawn_evil_rat() -> void:
	
	var rattt = ONE_D_ENEMY.instantiate()
	
	rattt.NPC_resource = EVIL_RAT
	OneDRoot.Enemies.add_child(rattt)
	
	if rat_names.size() > 0:
		var num = randi_range(0, rat_names.size() - 1)
		rattt.name = rat_names[num]
		rat_names.remove_at(num) # makes sure the name can't be used again
	else:
		rattt.name = "EVIL Rat " + rats_spawned
		rats_spawned += 1
