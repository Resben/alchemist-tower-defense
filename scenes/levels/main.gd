extends Node2D

var CAMERA_SPEED = 10
var HALF_WIDTH = 320

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		if $CameraController/Camera2D.limit_left + HALF_WIDTH < $CameraController.global_position.x:
			$CameraController.global_position.x -= CAMERA_SPEED
	if Input.is_action_pressed("right"):
		if $CameraController/Camera2D.limit_right - HALF_WIDTH > $CameraController.global_position.x:
			$CameraController.global_position.x += CAMERA_SPEED
