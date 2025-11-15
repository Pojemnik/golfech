extends Area2D

@export var output: Node2D;

func _on_body_entered(body: Node2D) -> void:
	body.teleport(output.position)

func _on_body_exited(body: Node2D) -> void:
	body.teleported = false;
