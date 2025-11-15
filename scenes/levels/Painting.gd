extends TileMapLayer

var tools_manager = null
func _ready() -> void:
	tools_manager = get_node("/root/Main/ToolsManager");

func _process(delta: float) -> void:
	if not tools_manager.selected_tool == "brush":
		return
	
	if Input.is_action_pressed("lmb"):
		var mouse_vector = to_local(get_viewport().get_mouse_position())
		var cell = local_to_map(mouse_vector);
		print(cell)
		for i in range(5):
			for j in range(5):
				set_cell(cell + Vector2i(i - 2, j - 2), 0, tools_manager.get_current_paint())
