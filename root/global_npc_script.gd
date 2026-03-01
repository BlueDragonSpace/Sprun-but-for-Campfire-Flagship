@abstract
extends Node

## core functionalities in action of all NPCs across the game
# I reccomend looking at the Inheritance Chart in the placeholder art if this doesn't serve as good
# - explaination for what this is
# gets inherited by the NPCs for all dimensions, which those in turn get inherited and turned into players or enemies later down the line
# this script isn't ever applied to a node / scene, but the ones specific to dimensions are

## ALL NPCs must have these things to be an NPC
var DeBuffs = null

# constants
const DE_BUFF_RECT = preload("uid://b2tkettp813ev")

## Functions
func check_debuff(debuff_in_question) -> Node: # returns if the debuff exists, and the Node connected to it
	var node = null
	
	for debuff_child in DeBuffs.get_children():
		if debuff_child.debuff.debuff_type == debuff_in_question:
			node = debuff_child
			break
	
	return node

func take_debuff(debuff_resource, add_expiration):
	var node_with_debuff = check_debuff(debuff_resource.debuff_type)
	
	if node_with_debuff: # already has that debuff, just add the number
		node_with_debuff.expiration += add_expiration
	else:
		var salve = check_debuff(DeBuff.DEBUFF.SALVE)
		if debuff_resource.is_bad and salve: # prevent bad debuff from salve
			salve.expiration = 0 
			# the "bad" debuff never gets added in the first place
		else: 
			# add the debuff
			var child = DE_BUFF_RECT.instantiate()
			child.debuff = debuff_resource
			DeBuffs.add_child(child)
			child.expiration = add_expiration
	
