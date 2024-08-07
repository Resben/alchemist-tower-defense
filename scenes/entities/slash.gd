extends Area2D

var starting_position : Vector2
var targeted_entity : Entity
var projectile_cause : Entity
var tween : Tween

func set_target(start_pos : Vector2, target : Entity, cause : Entity):
	global_position = start_pos
	targeted_entity = target
	projectile_cause = cause

func _ready():
	if global_position.distance_to(targeted_entity.projectile_target.global_position) > 55:
		queue_free()
		return
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", targeted_entity.projectile_target.global_position, 3)
	tween.tween_callback(queue_free)

func _on_body_entered(body):
	if body == targeted_entity:
		if tween != null && tween.is_running():
			tween.stop()
		targeted_entity.take_damage(projectile_cause.stats["damage"])
		queue_free()
