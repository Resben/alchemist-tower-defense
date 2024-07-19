extends Area2D

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("interact"):
		print("interacted with cauldron")
