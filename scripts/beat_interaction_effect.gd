extends AudioStreamPlayer2D
class_name BeatInteractionEffect


@export var perfect_hit_sounds: Array[AudioStream]
@export var ok_hit_sounds: Array[AudioStream]
@export var miss_sounds: Array[AudioStream]


@onready var _particles: GPUParticles2D = $GPUParticles2D


var _audio_finished: bool
var _particles_finished: bool


func play_perfect_hit() -> void:
	stream = perfect_hit_sounds.pick_random()
	_particles.amount = 3 + int(Globals.current_combo/2)
	play()
	_particles.emitting = true

func play_ok_hit() -> void:
	stream = ok_hit_sounds.pick_random()
	_particles.amount = 3
	play()
	_particles.emitting = true

func play_miss() -> void:
	stream = miss_sounds.pick_random()
	
	if is_inside_tree():
		play()
	
	_particles_finished = true


func _on_finished() -> void:
	_audio_finished = true
	_check_life()

func _on_gpu_particles_2d_finished() -> void:
	_particles_finished = true
	_check_life()


func _check_life():
	if _audio_finished and _particles_finished:
		queue_free()
