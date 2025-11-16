extends Area2D

@export var sand_particles: PackedScene;

var fade_tween: Tween

const FADE_IN_TIME := 0.2
const FADE_OUT_TIME := 0.2

var particles_instance: CPUParticles2D;
var current_body: Node2D;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		body.movement_sound_signal.connect(on_rolling_changed);
		if !particles_instance:
			spawn_particles(body);
		fade_in_fade_out()
		current_body = body;


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("ball"):
		if particles_instance:
			particles_instance.queue_free();
		body.movement_sound_signal.disconnect(on_rolling_changed)
		current_body = null;

func on_rolling_changed(state):
	if !state:
		if particles_instance:
			particles_instance.queue_free();
		#$AudioStreamPlayer.stop()
	else:
		if !particles_instance:
			spawn_particles(current_body);
		#$AudioStreamPlayer.play()
		fade_in_fade_out()
		
func fade_in_fade_out():
	if fade_tween:
		fade_tween.kill()
	$AudioStreamPlayer.volume_db = -40
	$AudioStreamPlayer.play()
	fade_tween = create_tween()
	fade_tween.tween_property($AudioStreamPlayer, "volume_db", 0, 0.10)
	fade_tween.tween_property($AudioStreamPlayer, "volume_db", -40, 0.30)
	fade_tween.finished.connect( func(): $AudioStreamPlayer.stop() )


func spawn_particles(body: Node2D):
	particles_instance = sand_particles.instantiate();
	body.add_child(particles_instance);
	particles_instance.position = Vector2.ZERO;
