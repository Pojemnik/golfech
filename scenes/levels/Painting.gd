extends TileMapLayer

var tools_manager = null
func _ready() -> void:
	tools_manager = get_node("/root/Mainer/Main/ToolsManager");

var last_mouse_position = null

func draw_stroke(cell: Vector2i):
	for i in range(5):
		for j in range(5):
			set_cell(cell + Vector2i(i - 2, j - 2), 0, tools_manager.get_current_paint())
		

func _process(delta: float) -> void:
	if not tools_manager.selected_tool == "brush":
		return
	
	if Input.is_action_pressed("lmb"):
		var mouse_vector = to_local(get_viewport().get_mouse_position())
		var cell = local_to_map(mouse_vector);
		draw_stroke(cell)
		if last_mouse_position:
			var distance = mouse_vector.distance_to(last_mouse_position)
			var direction = mouse_vector.direction_to(last_mouse_position)
			for i in range(int(distance)):
				draw_stroke(local_to_map(mouse_vector + direction * float(i)))
			
		last_mouse_position = mouse_vector
	else:
		last_mouse_position = null
