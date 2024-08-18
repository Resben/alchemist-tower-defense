extends CharacterBody2D
class_name Entity

signal _on_death

@export var corpse_texture : Texture2D

var navRegion : NavigationRegion2D
@onready var nav : NavigationAgent2D = $NavigationAgent2D

var is_dead = false

var direction : Vector2
var team : String
var attack_direction : int

var defense_position : Vector2
var targeted_enemy : Node2D

var enemy_cauldron : Cauldron
var friendly_cauldron : Cauldron

var spawn_pos : Vector2
var is_ready = false

var is_attacking = false

@onready var projectile_target : Node2D = $Target

var stats = {
	"hp" : 5,
	"max_hp" : 5,
	"damage" : 1,
	"base_speed" : 40,
	"speed" : 40,
	"has_range" : false,
	"effects" : {}
}

func _ready():
	is_ready = true
	navRegion = get_parent().navRegion
	call_deferred("setup")

func setup():
	pass

func _physics_process(_delta):
	if is_dead:
		return
	
	if nav.is_navigation_finished():
		return
	
	var next_path_position = nav.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * stats["speed"]
	direction = new_velocity
	
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()
	
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

func set_team(cauldron_to_defend : Cauldron, cauldron_to_attack : Cauldron):
	enemy_cauldron = cauldron_to_attack
	friendly_cauldron = cauldron_to_defend
	defense_position = cauldron_to_defend.global_position
	spawn_pos = global_position
	
	attack_direction = sign(cauldron_to_defend.global_position.direction_to(cauldron_to_attack.global_position).x)
	
	team = cauldron_to_defend.team
	add_to_group(team)

func set_defense_position(r : int, c : int, d_pos : Vector2):
	if is_instance_of(self, Miner):
		defense_position = spawn_pos
		return
	
	var y_value = 0
	match r:
		0:
			y_value = 0 + d_pos.y
		1:
			y_value = 10 + d_pos.y
		2:
			y_value = 20 + d_pos.y
		3:
			y_value = 30 + d_pos.y
	
	defense_position = Vector2(d_pos.x - (c * 36), y_value)
	print(defense_position)

func take_damage(dmg : int):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.CRIMSON, 0.5)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.5)
	
	_on_take_damage(dmg)
	
	stats["hp"] -= dmg
	
	if stats["hp"] <= 0:
		_on_death.emit(self)
		$AnimationPlayer.play("die")
		is_dead = true
		friendly_cauldron.passive_reference.erase(self)
		friendly_cauldron.hostile_references.erase(self)

func _on_take_damage(_dmg : int):
	pass

####################### SIGNALS #######################

func _on_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
	elif anim_name == "mine":
		if is_instance_valid(targeted_enemy) && is_instance_of(targeted_enemy, Mineable):
			targeted_enemy.on_hit(team)
	elif anim_name == "die":
		var corpse = load("res://scenes/entities/corpse.tscn").instantiate() as Corpse
		corpse.set_corpse(global_position, corpse_texture, 15)
		get_parent().add_child(corpse)
		queue_free()

####################### HELPERS #######################

func get_opposite_group() -> String:
	match team:
		"player":
			return "cpu"
		"cpu":
			return "player"
	
	return "na"
