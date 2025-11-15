extends Node
class_name Tools	

@export var bat_forces: Array[float];

var selected_brush: bool = false;
var selected_bat: int;
var selected_paint: int;

func _input(event):
	if event.is_action_pressed("select_brush"):
		select_brush();
	elif event.is_action_pressed("select_bat_1"):
		select_bat(0);
	elif event.is_action_pressed("select_bat_2"):
		select_bat(1);


func _ready():
	select_bat(0);

func select_bat(idx: int):
	if idx > bat_forces.size() or idx < 0:
		idx = 0;
	selected_bat = idx;
	selected_brush = false;
	print("Selected bat: ", selected_bat);
	
	
func get_current_bat_force():
	return bat_forces[selected_bat];


func select_brush():
	selected_brush = true;
	print("Selected brush");


func select_paint(idx: int):
	pass;
