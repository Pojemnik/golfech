extends SubViewport

var level: Node = null;
@export var levels: Array[PackedScene]
var current_level_idx = null;
var flags;


func _ready() -> void:
	if (get_child_count() > 0):
		level = get_child(0);
	if !level:
		load_level(0)
	else:
		set_flag_triggers()
		

func load_level(level_idx: int):
	if (level_idx >= levels.size()):
		print("Game finished");
		return;
	if level:
		level.queue_free();
	var instance = levels[level_idx].instantiate();
	call_deferred("add_child", instance);
	level = instance;
	current_level_idx = level_idx;
	call_deferred("set_flag_triggers");


func set_flag_triggers():
	flags = get_tree().get_nodes_in_group("flag")
	for flag in flags:
		if !flag.body_entered.is_connected(on_flag_reached):
			flag.body_entered.connect(on_flag_reached);


func on_flag_reached(body: Node2D):
	if !body.is_in_group("ball"):
		return;
		
	if current_level_idx != null:
		load_level(current_level_idx + 1);
	else:
		print("Level finished");
	
