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
	
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("spin_up")

func _on_body_entered(body):
	if body == targeted_entity:
		if tween != null && tween.is_running():
			tween.stop()
		targeted_entity.take_damage(projectile_cause.stats["damage"])
		$AnimationPlayer.play("break")
		$CollisionShape2D.disabled = true
		$TTL.paused = true

func _on_animation_finished(anim_name):
	if anim_name == "spin_up":
		if !is_instance_valid(targeted_entity):
			queue_free()
			return
		$TTL.paused = false
		$TTL.start()
		$CollisionShape2D.disabled = false
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", targeted_entity.projectile_target.global_position, 2)
		$AnimationPlayer.play("fire")
	elif anim_name == "break":
		queue_free()

func _on_ttl_timeout():
	if tween != null && tween.is_running():
		tween.stop()
	
	$AnimationPlayer.play("break")
	$CollisionShape2D.disabled = true
