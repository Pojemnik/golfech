extends SubViewport

var level: Node;
@export var levels: Array[PackedScene]
var current_level_idx = null;


func _ready() -> void:
	level = $Level
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
	add_child(instance);
	level = instance;
	current_level_idx = level_idx;
	set_flag_triggers();


func set_flag_triggers():
	var flags = get_tree().get_nodes_in_group("flag")
	for flag in flags:
		flag.body_entered.connect(on_flag_reached);


func on_flag_reached(body: Node2D):
	if !body.is_in_group("ball"):
		return;
		
	if current_level_idx != null:
		load_level(current_level_idx + 1);
	else:
		print("Level finished");
	
