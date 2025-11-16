extends RigidBody2D

@export var spawnpoint: Node2D;
@export var max_force_input: float;
@export var height_ratio: float;
@export var max_height_diff: float;
@export var max_rolling_speed: float;

signal restart
signal movement_sound_signal(state: bool)

var start_vector = null;
var current_vector = Vector2.ZERO;
var teleported = false;
var tools_manager: Tools;
var last_sleep_state: bool = true;
var rolling: bool = false;
var ball_sprite: Sprite2D;


func respawn() -> void:
	restart.emit()
	teleport(spawnpoint.position)
	stop();
	teleported = false;
	visible = true


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
	tools_manager = get_node("/root/Mainer/Main/ToolsManager");
	GameManager.restarted_level.connect(respawn);
	$Strength.visible = false
	

func _process(delta: float) -> void:
	if $Line2D.points.size() > 1:
		$Strength.visible = true
	else:
		$Strength.visible = false

var vertical_valocity = 0.0;
var vertical_height = 0.0;


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb") and !rolling and tools_manager.selected_tool == 'club':
		start_vector = get_viewport().get_mouse_position();
	
	if start_vector and tools_manager.selected_tool == 'club':
		if $Line2D.points.size() == 0:
			$AudioStreamPlayerStretch.pitch_scale = 1.0 + randf() * 0.1
			$AudioStreamPlayerStretch.play()
		current_vector = (get_viewport().get_mouse_position() - start_vector);
		current_vector = current_vector.normalized() * clamp(current_vector.length(), 0, max_force_input)
		$Line2D.points = [Vector2.ZERO, current_vector];
		
		#fwifhweoifbwefwef
		$Strength.position = current_vector
		$Strength.scale =  Vector2(0.5, 0.5) + Vector2(current_vector.length(),current_vector.length()) * 0.025
	else:
		$Line2D.points = [];
		
	if event.is_action_released("lmb") and start_vector and tools_manager.selected_tool == "club":
		var impulse = -current_vector * tools_manager.get_current_bat_force()
		apply_impulse(impulse);
		rolling = true;
		$Line2D.points = [];

		movement_sound_signal.emit(rolling)
		start_vector = null;
		vertical_valocity = 0.005 * impulse.length()
		$AudioStreamPlayerBigBonk.play(0.09)


	if event.is_action_released("lmb"):
		start_vector = null


func _physics_process(delta: float) -> void:
	if !last_sleep_state and sleeping and rolling:
		GameManager.set_hit_count(GameManager.current_hit_count + 1);
		movement_sound_signal.emit(false)
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
		
		GameManager.set_hit_count(GameManager.current_hit_count + 1);
		stop()
		$AudioStreamPlayerStickyWall.play()
	else:
		$AudioStreamPlayerSmallBonk.play()



func flag_hit():
	visible = false
	linear_velocity = Vector2.ZERO
	GameManager.on_flag_reached();


func handle_height(delta: float):
	vertical_height = max(vertical_height + vertical_valocity, 0.0)
	vertical_valocity -= delta * 4.0
	ball_sprite.position.y = -vertical_height
