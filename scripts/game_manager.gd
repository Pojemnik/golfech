extends Node

var current_hit_count: int  = 0;
var max_hit_count: int  = 0;
var level_end: bool = false;

signal hit_count_set(count: int);
signal level_finished;
signal start_level(max_hit_count: int);


func set_hit_count(count: int):
	current_hit_count = count;
	hit_count_set.emit(current_hit_count);


func on_flag_reached():
	if current_hit_count <= max_hit_count and !level_end:
		current_hit_count = 0;
		level_end = true;
		level_finished.emit();


func call_level_start(count: int):
	max_hit_count = count;
	current_hit_count = 0;
	level_end = false;
	start_level.emit(max_hit_count);
