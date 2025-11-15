extends Node
class_name Tools	

@export var bat_forces: Array[float];
@export var chipper: TextureButton 
@export var driver: TextureButton
@export var paintbrush: Sprite2D
@export var grass_button: TextureButton
@export var bunker_button: TextureButton

var selected_brush: bool = false;
var selected_bat: int;
var selected_paint: Vector2i;

signal brush_selected;
signal bat_selected(bat_idx: int);
signal paint_selected(paint_idx: Vector2i);

func _input(event):
	if event.is_action_pressed("select_brush"):
		select_brush()
	elif event.is_action_pressed("select_bat_1"):
		select_bat(0)
	elif event.is_action_pressed("select_bat_2"):
		select_bat(1)
	elif event.is_action_pressed("select_paint_grass"):
		select_paint(Vector2i(0,0))
	elif event.is_action_pressed("select_paint_bunker"):
		select_paint(Vector2i(1,0))


func _ready():
	select_bat(0);

func select_bat(idx: int):
	if idx > bat_forces.size() or idx < 0:
		idx = 0;
	selected_bat = idx;
	selected_brush = false;
	bat_selected.emit(idx);
	print("Selected bat: ", selected_bat);
	
	
func get_current_bat_force():
	return bat_forces[selected_bat];

func get_current_paint():
	return selected_paint

func select_brush():
	selected_brush = true;
	brush_selected.emit();
	print("Selected brush");

func select_paint(idx: Vector2i):
	selected_paint = idx;
	paint_selected.emit(idx);
	print("Selected paint");

func _on_driver_pressed() -> void:
	chipper.button_pressed = false
	paintbrush.visible = false
	select_bat(0);

func _on_chipper_pressed() -> void:
	driver.button_pressed = false
	paintbrush.visible = false
	select_bat(1);

func _on_grass_pressed() -> void:
	paintbrush.visible = true
	chipper.button_pressed = false
	driver.button_pressed = false
	select_brush()
	select_paint(Vector2i(0,0))
	paintbrush.global_position = grass_button.global_position + Vector2(-10.0, 3.5 )

func _on_bunker_pressed() -> void:
	paintbrush.visible = true
	chipper.button_pressed = false
	driver.button_pressed = false
	select_brush()
	select_paint(Vector2i(1,0))
	paintbrush.global_position = bunker_button.global_position + Vector2(-10.0, 3.5 )
