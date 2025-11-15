extends Area2D

@export var force: float;

var ball;
var disable = false;

func _physics_process(delta: float) -> void:
	if ball:
		var distance_squared = (global_position - ball.global_position).length_squared();
		var f = (global_position - ball.global_position).normalized() * force * delta * (1.0 / distance_squared);
		ball.apply_force(f);


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		ball = body as RigidBody2D;


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("ball"):
		ball = null;
