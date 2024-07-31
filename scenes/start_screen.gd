extends CanvasLayer

@export var MainScene : PackedScene

var has_condition = "none"

func set_as_end_screen(condition : String):
	has_condition = condition

func _on_start_button_up():
	get_parent().add_child(MainScene.instantiate())
	AudioHandler.start_game()
	queue_free()

func _ready():
	match has_condition:
		"win":
			$Control/Start.visible = false
			$Control/Win.visible = true
			$Control/Loss.visible = false
		"lost":
			$Control/Start.visible = false
			$Control/Win.visible = false
			$Control/Loss.visible = true
		"none":
			$Control/Start.visible = true
			$Control/Win.visible = false
			$Control/Loss.visible = false
