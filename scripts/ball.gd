extends RigidBody2D

@export var spawnpoint: Node2D;

var start_vector = null;
var current_vector = Vector2.ZERO;
var teleported = false;


func respawn() -> void:
	teleport(spawnpoint.position)
	stop();
	teleported = false;
	

func teleport(pos: Vector2):
	if (!teleported):
		teleported = true;
		PhysicsServer2D.body_set_state(
			get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(pos)
		);

func stop() -> void:
	linear_velocity = Vector2.ZERO;
	angular_velocity = 0;
	

func _ready() -> void:
	respawn();
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lmb") and sleeping:
		start_vector = get_viewport().get_mouse_position();
	
	if (start_vector):
		current_vector = (get_viewport().get_mouse_position() - start_vector);
		$Line2D.points = [Vector2.ZERO, current_vector];
	else:
		$Line2D.points = [];
	
	if Input.is_action_just_released("lmb") and start_vector:
		apply_impulse(-current_vector);
		start_vector = null;


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("sticky"):
		var dir = -linear_velocity.normalized()
		var from = global_position - dir * 5;
		var to = from + dir * 10.0
		var query_params = PhysicsRayQueryParameters2D.create(from, to, 0xFFFFFFFF, [get_rid()]);
			
		var result = get_world_2d().direct_space_state.intersect_ray(query_params);
		if result:
			global_position = result.position - dir * 2
			
		stop()
