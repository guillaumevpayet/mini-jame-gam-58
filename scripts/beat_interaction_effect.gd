extends Node2D
class_name BeatInteractionEffect


@export var perfect_hit_sounds: Array[AudioStream]
@export var ok_hit_sounds: Array[AudioStream]
@export var miss_sounds: Array[AudioStream]


@onready var _particles: GPUParticles2D = $GPUParticles2D

@onready var miss_text = $TextContainer/MissText
@onready var hit_text = $TextContainer/HitText
@onready var perfect_text = $TextContainer/PerfectText
@onready var interaction_effect: AudioStreamPlayer = $InteractionEffect


var _audio_finished: bool
var _particles_finished: bool


var scale_tween: Tween
var opacity_tween: Tween

func play_warmup() -> void:
	interaction_effect.volume_db = -80
	interaction_effect.stream = perfect_hit_sounds.pick_random()
	interaction_effect.play()
	_particles.emitting = true
	hit_success_text_pop_up("perfect")

func play_perfect_hit() -> void:
	interaction_effect.stream = perfect_hit_sounds.pick_random()
	_particles.amount = 3 + int(Globals.current_combo/2)
	interaction_effect.play()
	_particles.emitting = true
	hit_success_text_pop_up("perfect")

func play_ok_hit() -> void:
	interaction_effect.stream = ok_hit_sounds.pick_random()
	_particles.amount = 3
	interaction_effect.play()
	_particles.emitting = true
	hit_success_text_pop_up("hit")

func play_miss() -> void:
	interaction_effect.stream = miss_sounds.pick_random()
	hit_success_text_pop_up("miss")
	
	if is_inside_tree():
		interaction_effect.play()
	
	_particles_finished = true


func _on_finished() -> void:
	interaction_effect.volume_db = 0
	
	_audio_finished = true
	_check_life()

func _on_gpu_particles_2d_finished() -> void:
	_particles_finished = true
	_check_life()


func _check_life():
	if _audio_finished and _particles_finished:
		queue_free()

func hit_success_text_pop_up(success: String)-> void:
	var text_pop_up: Sprite2D
	match success:
		"perfect":
			text_pop_up = perfect_text
		"hit":
			text_pop_up = hit_text
		"miss":
			text_pop_up = miss_text
	if text_pop_up:
		text_pop_up.visible = true
		text_pop_up.scale = Vector2(1.0 + 0.05 * Globals.current_combo, 1.0 + 0.05 * Globals.current_combo)
		scale_tween = create_tween()
		scale_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
		scale_tween.tween_property(text_pop_up, "scale", Vector2(0.5, 0.5), 0.7)
		scale_tween.set_parallel(true)
		
		scale_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
		scale_tween.tween_property(text_pop_up, "self_modulate:a", 0, 0.7)
		await scale_tween.finished
		
		scale_tween.kill()
