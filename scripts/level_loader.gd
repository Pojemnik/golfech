extends SubViewport
class_name LevelLoader;

var level: Node = null;
@export var levels: Array[LevelData]
var current_level_idx = null;


func _ready() -> void:
	GameManager.level_finished.connect(next_level);
	if !level:
		load_level(0);


func next_level():
	if current_level_idx != null:
		load_level(current_level_idx + 1);
		
		
func reload_level():
	load_level(current_level_idx);


func load_level(level_idx: int):
	if (level_idx >= levels.size()):
		print("Game finished");
		return;
	if level:
		level.queue_free();
	var instance = levels[level_idx].scene.instantiate();
	print("Load level ", levels[level_idx].scene.resource_path);
	call_deferred("add_child", instance);
	level = instance;
	current_level_idx = level_idx;
	GameManager.call_level_start(levels[level_idx].hit_count);
