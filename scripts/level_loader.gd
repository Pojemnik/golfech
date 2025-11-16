extends SubViewport
class_name LevelLoader;

@export var levels: Array[LevelData]

var level: Node = null;
var current_level_idx = null;


func _ready() -> void:
	GameManager.level_finished.connect(func(): clear_level(true));
	GameManager.flag_reached_without_finish.connect(func(): clear_level(false));
	if !level:
		load_level(0);


func next_level():
	if current_level_idx != null:
		load_level(current_level_idx + 1);


func load_level(level_idx: int):
	if $LevelComplete.bg_visible:
		$LevelComplete.change_text("Level %d\n%s" % [level_idx + 1, levels[level_idx].name])
	else:
		$LevelComplete.show_with_text("Level %d\n%s" % [level_idx + 1, levels[level_idx].name])
	await $LevelComplete.tween_end;
	$LevelComplete.fade_out(true, true);
	$"../../UiViewport/SubViewport/Control/LevelTitle".text = levels[level_idx].name;
	if (level_idx >= levels.size()):
		print("Game finished");
		return;
	var instance = levels[level_idx].scene.instantiate();
	print("Load level ", levels[level_idx].scene.resource_path);
	$LevelParent.call_deferred("add_child", instance);
	level = instance;
	current_level_idx = level_idx;
	GameManager.call_level_start(levels[level_idx].hit_count);


func clear_level(level_complete: bool):
	$LevelComplete.show_with_text(get_level_end_message(level_complete));
	await $LevelComplete.tween_end;
	$LevelComplete.fade_out(true, false);
	await $LevelComplete.tween_end;
	if level:
		level.queue_free();
		level = null;
	if level_complete:
		next_level();
	else:
		load_level(current_level_idx);


func get_level_end_message(level_complete: bool):
	if level_complete:
		if GameManager.current_hit_count < 1:
			return "Level complete\nHole in one!"
		else:
			return "Level complete";
	return "Try again"; 
