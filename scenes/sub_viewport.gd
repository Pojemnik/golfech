extends SubViewport

@export var vp: SubViewport

func _unhandled_input(event: InputEvent) -> void:
	# to jest zjebane to propaguje eventy ktorych nie zlapalo ui do gry
	vp.push_input(event)
