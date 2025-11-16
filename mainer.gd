extends Control

func _process(delta: float) -> void:
	$Main.position.x = get_viewport().size.x / 2 - $Main.size.x / 2
	$Main.position.y = get_viewport().size.y / 2 - $Main.size.y / 2
