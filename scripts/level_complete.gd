extends ColorRect

@export var tween_duration: float = 0.4;

signal tween_end;

var text_visible: bool;
var bg_visible: bool;
var next_text;
const bg_color = Color("ffffeb");

func on_tween_end():
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	tween_end.emit();


func set_shader_value(value):
	$Label.material.set_shader_parameter("color", value)


func show_with_text(text: String):
	var tween = get_tree().create_tween();
	$Label.text = text;
	tween.tween_property(self, "modulate", bg_color, tween_duration);
	tween.set_parallel(true);
	tween.tween_method(set_shader_value, Color.TRANSPARENT, Color.BLACK, tween_duration);
	tween.set_parallel(false);
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(on_tween_end);
	text_visible = true;
	bg_visible = true;


func fade_out(text: bool, bg: bool):
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT)
	if text:
		tween.tween_method(set_shader_value, Color.BLACK, Color.TRANSPARENT, tween_duration);
		if bg:
			tween.set_parallel(true);
	if bg:
		tween.tween_property(self, "modulate", Color.TRANSPARENT, tween_duration);
	tween.set_parallel(false);
	if text:
		text_visible = false;
	if bg:
		bg_visible = false;
	tween.tween_callback(on_tween_end);
	

func change_text(text: String):
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT)
	if text_visible:
		next_text = text;
		tween.tween_method(set_shader_value, Color.BLACK, Color.TRANSPARENT, tween_duration * 3);
		tween.tween_callback(_change_text_internal);
	else:
		$Label.text = text;
	tween.tween_method(set_shader_value, Color.TRANSPARENT, Color.BLACK, tween_duration);
	tween.tween_callback(on_tween_end);
	
	
func _change_text_internal():
	$Label.text = next_text;
	
