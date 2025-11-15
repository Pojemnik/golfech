extends Area2D

@export var output: Node2D;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		body.teleport(output.position)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("ball"):
		body.teleported = false;
