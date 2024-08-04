extends Sprite2D
class_name Corpse

var values_set = false
var seconds

func _ready():
	if values_set:
		$QueueFree.start(seconds)
	else:
		push_error("Never set the values on the corpse")

func set_corpse(pos : Vector2, corpse_texture : Texture2D, sec : int):
	global_position = pos
	texture = corpse_texture
	seconds = sec
	values_set = true

func _on_queue_free_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_callback(queue_free)
