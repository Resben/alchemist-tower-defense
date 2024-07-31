extends Sprite2D

var direction : Vector2

func set_direction(pos):
	direction = pos

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", global_position + (direction * 50), 1)
	tween.tween_callback(queue_free)
