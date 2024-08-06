extends Control

signal _on_close

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/HSlider.value = AudioHandler.value

func _on_volume_slider_changed(value):
	AudioHandler.set_volume(value)

func _on_exit_pressed():
	_on_close.emit()
