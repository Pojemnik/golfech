extends Area2D

func _ready() -> void:
	GameManager.reached_move_max.connect(disapear)
	GameManager.restarted_level.connect(appear)

var t = 0.3

func disapear():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color.TRANSPARENT, t)
	tween.set_parallel(true)
	tween.tween_property($Sprite, "position", Vector2(0.0, -10.0), t)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Sprite2, "modulate", Color.TRANSPARENT, t)
	tween2.set_parallel(true)
	tween2.tween_property($Sprite2, "position", Vector2(0.0, 11.0), t)
	tween2.set_trans(Tween.TRANS_QUAD)
	tween2.set_ease(Tween.EASE_IN)

func appear():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color.WHITE, t)
	tween.set_parallel(true)
	tween.tween_property($Sprite, "position", Vector2(0.0, -4.0), t)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Sprite2, "modulate", Color.WHITE, t)
	tween2.set_parallel(true)
	tween2.tween_property($Sprite2, "position", Vector2(0.0, 5.0), t)
	tween2.set_trans(Tween.TRANS_QUAD)
	tween2.set_ease(Tween.EASE_IN)

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("rmb"):
		#disapear()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		$AudioStreamPlayerFlag.play()
		body.flag_hit();
