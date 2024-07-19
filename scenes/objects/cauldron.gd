extends Area2D

func _ready():
	input_pickable = true

func _on_input_event(viewport : Node, event : InputEvent, shape_idx : int):
	if Input.is_action_just_pressed("interact"):
		print("interacted with cauldron")

func _on_button_drop(pos : Vector2, node : Moveable):
	if pos.distance_to(global_position) <= 14:
		node.reduce_number()
		add_ingredient(node.data)

func add_ingredient(data : Item):
	pass
