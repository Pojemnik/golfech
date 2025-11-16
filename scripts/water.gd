extends Area2D

@export var splash_particles: PackedScene;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		$AudioStreamPlayerWaterPlum.play()
		body.respawn()
		var instance = splash_particles.instantiate();
		add_child(instance);
		instance.global_position = body.global_position;
