extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var start_vector = null;
var current_vector = Vector2.ZERO;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lmb") and sleeping:
		start_vector = get_viewport().get_mouse_position()
	
	if (start_vector):
		current_vector = (get_viewport().get_mouse_position() - start_vector) / 3
		$Line2D.points = [Vector2.ZERO, current_vector]
	else:
		$Line2D.points = []
	
	if Input.is_action_just_released("lmb") and start_vector:
		apply_impulse(-current_vector)
		start_vector = null;
