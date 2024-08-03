extends Sprite2D
class_name Corpse

func set_corpse(pos : Vector2, corpse_texture : Texture2D, seconds : int):
	global_position = pos
	texture = corpse_texture
	$QueueFree.start(seconds)

func _on_queue_free_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_callback(queue_free)
