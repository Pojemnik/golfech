extends RigidBody2D

@export var spawnpoint: Node2D;
@export var max_force_input: float;

var start_vector = null;
var current_vector = Vector2.ZERO;
var teleported = false;
var tools_manager: Tools;
var last_sleep_state: bool = true;
var rolling: bool = false;

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
	last_sleep_state = true;
	rolling = false;
	

func _ready() -> void:
	respawn();
	tools_manager = get_node("/root/Main/ToolsManager");
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lmb") and !rolling and !tools_manager.selected_brush:
		start_vector = get_viewport().get_mouse_position();
	
	if start_vector and !tools_manager.selected_brush:
		current_vector = (get_viewport().get_mouse_position() - start_vector);
		current_vector = current_vector.normalized() * clamp(current_vector.length(), 0, max_force_input)
		$Line2D.points = [Vector2.ZERO, current_vector];
	else:
		$Line2D.points = [];
	
	if Input.is_action_just_released("lmb") and start_vector and !tools_manager.selected_brush:
		apply_impulse(-current_vector * tools_manager.get_current_bat_force());
		rolling = true;
		start_vector = null;


func _physics_process(delta: float) -> void:
	if !last_sleep_state and sleeping and rolling:
		GameManager.increase_hit_count();
		rolling = false;
	last_sleep_state = sleeping;


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
	
	if body.is_in_group("water"):
		respawn();


func flag_hit():
	print("Flag hit");
	GameManager.on_flag_reached();
