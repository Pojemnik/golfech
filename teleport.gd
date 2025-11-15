extends Area2D

@export var output: Node2D;

func _on_body_entered(body: Node2D) -> void:
	if (!body.teleported):
		body.teleported = true;
		PhysicsServer2D.body_set_state(
			body.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(output.position)
		);


func _on_body_exited(body: Node2D) -> void:
	body.teleported = false;
