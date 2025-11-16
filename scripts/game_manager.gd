extends Node

var current_hit_count: int  = 0;
var max_hit_count: int  = 0;
var level_end: bool = false;

signal hit_count_set(count: int);
signal level_finished;
signal start_level(max_hit_count: int);
signal flag_reached_without_finish;
signal reached_move_max
signal restarted_level


func set_hit_count(count: int):
	current_hit_count = count;
	hit_count_set.emit(current_hit_count);
	if current_hit_count == 0:
		restarted_level.emit()
	if current_hit_count >= max_hit_count:
		reached_move_max.emit()


func on_flag_reached():
	if current_hit_count < max_hit_count and !level_end:
		level_finished.emit();
		current_hit_count = 0;
		level_end = true;
	else:
		flag_reached_without_finish.emit();


func call_level_start(count: int):
	max_hit_count = count;
	current_hit_count = 0;
	level_end = false;
	start_level.emit(max_hit_count);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level") and !level_end:
		set_hit_count(0);
