extends RigidBody2D

@export var spawnpoint: Node2D;

var start_vector = null;
var current_vector = Vector2.ZERO;
var teleported = false;

func respawn() -> void:
	teleport(spawnpoint.position)
	linear_velocity = Vector2.ZERO;
	teleported = false;
	
func teleport(pos: Vector2):
	if (!teleported):
		teleported = true;
		PhysicsServer2D.body_set_state(
			get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(pos)
		);

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lmb") and sleeping:
		start_vector = get_viewport().get_mouse_position();
	
	if (start_vector):
		current_vector = (get_viewport().get_mouse_position() - start_vector) / 3;
		$Line2D.points = [Vector2.ZERO, current_vector];
	else:
		$Line2D.points = [];
	
	if Input.is_action_just_released("lmb") and start_vector:
		apply_impulse(-current_vector);
		start_vector = null;
