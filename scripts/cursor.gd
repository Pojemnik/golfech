extends Sprite2D

var target_position = Vector2.ZERO

func _process(delta: float) -> void:
	global_position = lerp(global_position, target_position, 0.2)
