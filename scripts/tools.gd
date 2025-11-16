extends Node
class_name Tools	

@export var bat_forces: Array[float];
@export var chipper: TextureButton 
@export var driver: TextureButton
@export var paintbrush: Sprite2D
@export var grass_button: TextureButton
@export var bunker_button: TextureButton
@export var wall_button: TextureButton
@export var water_button: TextureButton

var selected_tool = 'club'
var selected_club = null
var selected_paint = Vector2i(1, 0)

func _ready():
	select_bat(0);
	paintbrush.target_position = driver.global_position

func select_bat(idx: int):
	selected_tool = 'club'
	selected_club = bat_forces[idx]
	
func select_paint(idx: Vector2i):
	selected_paint = idx;
	selected_tool = 'brush'

func get_current_bat_force():
	return selected_club;

func get_current_paint():
	return selected_paint

func _on_driver_pressed() -> void:
	chipper.button_pressed = false
	paintbrush.visible = false
	select_bat(0);
	paintbrush.visible = true
	paintbrush.target_position = driver.global_position

func _on_chipper_pressed() -> void:
	driver.button_pressed = false
	paintbrush.visible = false
	select_bat(1);
	paintbrush.visible = true
	paintbrush.target_position = chipper.global_position

func _on_grass_pressed() -> void:
	paintbrush.visible = true
	chipper.button_pressed = false
	driver.button_pressed = false
	select_paint(Vector2i(0,0))
	paintbrush.target_position = grass_button.global_position

func _on_bunker_pressed() -> void:
	paintbrush.visible = true
	chipper.button_pressed = false
	driver.button_pressed = false
	select_paint(Vector2i(1,0))
	paintbrush.target_position = bunker_button.global_position

func _on_water_pressed() -> void:
	paintbrush.visible = true
	chipper.button_pressed = false
	driver.button_pressed = false
	select_paint(Vector2i(0,1))
	paintbrush.target_position = water_button.global_position

func _on_wall_pressed() -> void:
	paintbrush.visible = true
	chipper.button_pressed = false
	driver.button_pressed = false
	select_paint(Vector2i(1,1))
	paintbrush.target_position = wall_button.global_position
