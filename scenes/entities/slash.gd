extends Area2D
class_name Slash

var starting_position : Vector2
var targeted_entity : Entity
var dmg : int
var tween : Tween

func set_target(start_pos : Vector2, target : Entity, cause : Entity):
	global_position = start_pos
	targeted_entity = target
	dmg = cause.stats["damage"]

func _ready():
	if global_position.distance_to(targeted_entity.projectile_target.global_position) > 55:
		queue_free()
		return
	
	$AnimationPlayer.play("spin_up")

func _on_animation_finished(anim_name):
	if anim_name == "spin_up":
		if !is_instance_valid(targeted_entity):
			queue_free()
			return
		$TTL.start()
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", targeted_entity.projectile_target.global_position, 1)
		$AnimationPlayer.play("fire")
	elif anim_name == "break":
		queue_free()

func _on_ttl_timeout():
	if tween != null && tween.is_running():
		tween.stop()
	
	if is_instance_valid(targeted_entity):
		if global_position.distance_to(targeted_entity.projectile_target.global_position) < 5:
			targeted_entity.take_damage(dmg)
	$AnimationPlayer.play("break")
