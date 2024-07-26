extends CanvasLayer

func _on_attack_pressed():
	get_parent().on_attack()

func _on_defend_pressed():
	get_parent().on_defend()
