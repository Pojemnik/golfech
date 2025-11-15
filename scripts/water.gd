extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("bruh")
	if body.is_in_group("ball"):
		body.respawn()
