extends Line2D

@export var trail_length: int;

var ball: Sprite2D;


func _ready() -> void:
	ball = $"../Ball/Ball";


func _physics_process(delta: float) -> void:
	var pos = to_local(ball.global_position);
	add_point(pos);
	if points.size() > trail_length:
		remove_point(0);
	
