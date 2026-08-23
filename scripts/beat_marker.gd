extends Area2D

class_name BeatMarker


@export var tolerances: Array[float]
@export var indicator_ring_max_scale: float = 3
@export var max_radius: float = 30
@export var sound_effect_scene: PackedScene


@onready var _target_ring: Sprite2D = $TargetRing
@onready var _indicator_ring: Sprite2D = $IndicatorRing


var _original_time_to_beat: float
var _remaining_time_to_beat: float

signal score_obtained(score: int)
signal despawn(instance: BeatMarker)


func init(beat_position: Vector2, time_to_beat: float):
	transform.origin = beat_position
	_original_time_to_beat = time_to_beat
	_remaining_time_to_beat = time_to_beat


func _ready() -> void:
	_target_ring.modulate = Color.TRANSPARENT
	_indicator_ring.scale = indicator_ring_max_scale * Vector2.ONE

func _process(_delta: float) -> void:
	_remaining_time_to_beat -= _delta

	if _remaining_time_to_beat <= -_original_time_to_beat:
		_emit_score_and_disappear(0)
		return
	
	var opacity: float = 1 - (abs(_remaining_time_to_beat) / _original_time_to_beat)
	_target_ring.modulate = Color(1, 1, 1, opacity)
	
	if _remaining_time_to_beat > 0:
		_indicator_ring.scale = (indicator_ring_max_scale - (indicator_ring_max_scale - 1) * opacity) * Vector2.ONE
	else:
		_indicator_ring.scale = opacity * Vector2.ONE;


func determine_click_score(event_position: Vector2) -> void:
	var radius: float = event_position.distance_to(global_position)
	var score: int = 0
	
	if radius <= max_radius:
		var tolerance_count: int = tolerances.size()
		
		for index in range(tolerance_count):
			if abs(_remaining_time_to_beat) <= tolerances[index]:
				score = tolerance_count - index
				break
	
	_emit_score_and_disappear(score)

func _emit_score_and_disappear(score: int):
	score_obtained.emit(score)
	var sound_effect: BeatInteractionEffect = sound_effect_scene.instantiate()
	sound_effect.position = position
	get_parent().add_child(sound_effect)
	
	match score:
		0:
			sound_effect.play_miss()
		3:
			sound_effect.play_perfect_hit()
		_:
			sound_effect.play_ok_hit()
			
	despawn.emit(self)
