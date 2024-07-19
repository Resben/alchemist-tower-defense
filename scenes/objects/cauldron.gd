extends Area2D

func _ready():
	input_pickable = true

func _on_input_event(viewport : Node, event : InputEvent, shape_idx : int):
	if Input.is_action_just_pressed("interact"):
		print("interacted with cauldron")
