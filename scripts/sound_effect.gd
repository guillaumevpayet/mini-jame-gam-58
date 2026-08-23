extends AudioStreamPlayer2D
class_name SoundEffect

@export var perfect_hit_sounds: Array[AudioStream]
@export var ok_hit_sounds: Array[AudioStream]
@export var miss_sounds: Array[AudioStream]


func play_perfect_hit() -> void:
	stream = perfect_hit_sounds.pick_random()

func play_ok_hit() -> void:
	stream = ok_hit_sounds.pick_random()

func play_miss() -> void:
	stream = miss_sounds.pick_random()


func _on_finished() -> void:
	queue_free()
