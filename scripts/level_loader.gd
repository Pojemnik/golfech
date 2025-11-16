extends SubViewport
class_name LevelLoader;

@export var levels: LevelList;

var level: Node = null;
var current_level_idx = null;


func _ready() -> void:
	GameManager.level_finished.connect(clear_level);
	GameManager.reached_move_max.connect(set_reset_text);
	GameManager.restarted_level.connect(set_top_level_title);
	if !level:
		load_level(0);


func next_level():
	if current_level_idx != null:
		load_level(current_level_idx + 1);


func load_level(level_idx: int):
	if $LevelComplete.bg_visible:
		$LevelComplete.change_text("Hole %d \"%s\"\npar %d" % [level_idx + 1, levels.levels[level_idx].name, levels.levels[level_idx].hit_count])
	else:
		$LevelComplete.show_with_text("Hole %d \"%s\"\npar %d" % [level_idx + 1, levels.levels[level_idx].name, levels.levels[level_idx].hit_count])
	await $LevelComplete.tween_end;
	$LevelComplete.fade_out(true, true);
	current_level_idx = level_idx;
	set_top_level_title();
	if (level_idx >= levels.levels.size()):
		print("Game finished");
		return;
	var instance = levels.levels[level_idx].scene.instantiate();
	print("Load level ", levels.levels[level_idx].scene.resource_path);
	$LevelParent.call_deferred("add_child", instance);
	level = instance;
	GameManager.call_level_start(levels.levels[level_idx].hit_count);


func clear_level():
	$LevelComplete.show_with_text(get_level_end_message());
	await $LevelComplete.tween_end;
	$LevelComplete.fade_out(true, false);
	await $LevelComplete.tween_end;
	if level:
		level.queue_free();
		level = null;
		next_level();


func get_level_end_message():
	if GameManager.current_hit_count < 1:
		return "Hole complete\nHole in one!"
	else:
		return "Hole complete";


func set_reset_text():
	$"../../UiViewport/SubViewport/Control/LevelTitle".text = "R to reset";
	

func set_top_level_title():
	$"../../UiViewport/SubViewport/Control/LevelTitle".text = levels.levels[current_level_idx].name;
