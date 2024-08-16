extends Node2D

func set_value(val):
	$Panel.material.set_shader_parameter("value", val)
