extends Area2D

func _on_summoning_toolrack_shadow_drop(pos, id):
	if pos.distance_to(global_position) <= 30 || pos == Vector2(-999, -999):
		get_parent().spawn_entity("miner", global_position)
		$"../Summoning".moveable_used(id)
