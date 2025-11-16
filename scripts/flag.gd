extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		$AudioStreamPlayerFlag.play()
		body.flag_hit();
