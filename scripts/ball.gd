extends RigidBody2D

@export var spawnpoint: Node2D;
@export var max_force_input: float;
@export var height_ratio: float;
@export var max_height_diff: float;
@export var max_rolling_speed: float;

var start_vector = null;
var current_vector = Vector2.ZERO;
var teleported = false;
var tools_manager: Tools;
var last_sleep_state: bool = true;
var rolling: bool = false;
var ball_sprite: Sprite2D;

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
	ball_sprite = $Ball;
	tools_manager = get_node("/root/Main/ToolsManager");
	

func _process(delta: float) -> void:
	_process_movement();

var vertical_valocity = 0.0;
var vertical_height = 0.0;

func _process_movement():
	if Input.is_action_just_pressed("lmb") and !rolling and !tools_manager.selected_brush:
		start_vector = get_viewport().get_mouse_position();
	
	if start_vector and !tools_manager.selected_brush:
		current_vector = (get_viewport().get_mouse_position() - start_vector);
		current_vector = current_vector.normalized() * clamp(current_vector.length(), 0, max_force_input)
		$Line2D.points = [Vector2.ZERO, current_vector];
	else:
		$Line2D.points = [];
	
	if Input.is_action_just_released("lmb") and start_vector and !tools_manager.selected_brush:
		var impulse = -current_vector * tools_manager.get_current_bat_force()
		apply_impulse(impulse);
		rolling = true;
		start_vector = null;
		vertical_valocity = 0.002 * impulse.length()


func _physics_process(delta: float) -> void:
	if !last_sleep_state and sleeping and rolling:
		GameManager.set_hit_count(GameManager.current_hit_count + 1);
		rolling = false;
	last_sleep_state = sleeping;
	handle_height(delta);


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
		GameManager.set_hit_count(GameManager.current_hit_count + 1);


func flag_hit():
	print("Flag hit");
	GameManager.on_flag_reached();


func handle_height(delta: float):
	vertical_height = max(vertical_height + vertical_valocity, 0.0)
	vertical_valocity -= delta * 4.0
	ball_sprite.position.y = -vertical_height


func _input(event):
	if event.is_action_pressed("restart_level"):
		respawn();
		GameManager.set_hit_count(0);
