extends "res://inGame/npc/enemy/enemy.gd"

var rats_spawned = 1

var rat_names = ["Jimmy", "Angela", "Thomas", "Borborygmi", "Floo", "Quark", "Gertrude", "Pumpernickel", "Slight", "Compromise", "Deernose", "Iro"]

const EVIL_RAT = preload("uid://yb81wdv11231")

func spawn_evil_rat() -> void:
	
	var rattt = EVIL_RAT.instantiate()
	
	if rat_names.size() > 0:
		var num = randi_range(0, rat_names.size() - 1)
		rattt.name = rat_names[num]
		rat_names.remove_at(num) # makes sure the name can't be used again
	else:
		rattt.name = "EVIL Rat " + rats_spawned
		rats_spawned += 1
	
	OneDRoot.Enemies.add_child(rattt)
