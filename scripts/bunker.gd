extends Area2D
var fade_tween: Tween
const FADE_IN_TIME := 0.2
const FADE_OUT_TIME := 0.2
func _redy():
	$AudioStreamPlayer.set_loop(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		body.movement_sound_signal.connect(on_rolling_changed);
		#$AudioStreamPlayer.play()
		fade_in_fade_out()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("ball"):
		body.movement_sound_signal.disconnect(on_rolling_changed)

func on_rolling_changed(state):
	if !state:
		print("stopping rolling")
		#$AudioStreamPlayer.stop()
	else:
		print("start rolling")
		#$AudioStreamPlayer.play()
		fade_in_fade_out()
		
func fade_in_fade_out():
	if fade_tween:
		fade_tween.kill()
	$AudioStreamPlayer.volume_db = -40
	$AudioStreamPlayer.play()
	fade_tween = create_tween()
	fade_tween.tween_property($AudioStreamPlayer, "volume_db", 0, 0.10)
	fade_tween.tween_property($AudioStreamPlayer, "volume_db", -40, 0.30)
	fade_tween.finished.connect( func(): $AudioStreamPlayer.stop() )
