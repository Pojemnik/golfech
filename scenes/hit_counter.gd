extends Label

var hit_count: int = 0;
var max_hit_count: int = 0;


func _ready() -> void:
	max_hit_count = GameManager.max_hit_count;
	GameManager.hit_count_set.connect(_on_hit_count_set);
	GameManager.level_started.connect(_on_level_stared);
	_update_label();
	

func _on_level_stared(max_hits: int):
	max_hit_count = max_hits;
	hit_count = 0;
	print("level started");
	_update_label();


func _on_hit_count_set(count: int):
	hit_count = count;
	_update_label();


func _update_label():
	var label_format = "%d/%d";
	text = label_format % [hit_count, max_hit_count];
	
