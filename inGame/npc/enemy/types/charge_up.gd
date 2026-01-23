extends "res://inGame/npc/enemy/enemy.gd"


var turns_charging = 0

# like the little wizard enemy of Slay the Spire!

func add_set_intended_action() -> void:
	# basically overrules everything set previously
	
	if turns_charging >= 2: #charged long enough, time to fire
		intended_action = Callable(self, "attack")
		IntendedTargetIcon.visible = true
		Intent.texture = SWORD_ART
		intent = INTENT.ATTACK
		attack_stat = randi_range(attack_middle_value - attack_range, attack_middle_value + attack_range)
		IntentLabel.text = str(attack_stat)
		turns_charging = 0
	else:
		intended_action = Callable(Global, "empty_function")
		IntendedTargetIcon.visible = false
		Intent.texture = ATTENTIONS_ART
		intent = INTENT.CHARGING
		if turns_charging == 1:
			Intent.self_modulate = Color(1.0, 0.0, 0.0, 1.0)
		else:
			Intent.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		intent = Action.ACTION_TYPE.OTHER
		IntentLabel.text = ''
		turns_charging += 1
