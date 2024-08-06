extends Node2D

var fight_volume = -30
var value = 1

func _ready():
	$FightingBGM.volume_db = linear_to_db(db_to_linear(fight_volume) * value)

func _on_timer_timeout():
	if fight_volume < 0:
		fight_volume += 1
	$FightingBGM.volume_db = linear_to_db(db_to_linear(fight_volume) * value)
	print($FightingBGM.volume_db)
	print($MainBGM.volume_db)
	$Timer.start()

func start_game():
	$Timer2.start()

func set_volume(val):
	value = val
	$FightingBGM.volume_db = linear_to_db(db_to_linear(fight_volume) * value)
	$MainBGM.volume_db = linear_to_db(value)

func _on_timer_2_timeout():
	$Timer.start()

func _on_main_bgm_finished():
	$MainBGM.play()

func _on_fighting_bgm_finished():
	$FightingBGM.play()
