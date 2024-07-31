extends CanvasLayer

@export var MainScene : PackedScene

func _on_start_button_up():
	get_parent().add_child(MainScene.instantiate())
	AudioHandler.start_game()
	queue_free()
