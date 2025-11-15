extends Node

var current_hit_count: int  = 0;
var max_hit_count: int  = 0;

signal hit_count_increased(count: int);
signal game_over;
signal level_finished;
signal level_started(max_hit_count: int);


func increase_hit_count():
	current_hit_count += 1;
	hit_count_increased.emit(current_hit_count);


func on_flag_reached():
	current_hit_count = 0;
	level_finished.emit();


func call_game_over():
	current_hit_count = 0;
	game_over.emit();


func call_level_start(count: int):
	max_hit_count = count;
	current_hit_count = 0;
	level_started.emit(max_hit_count);
