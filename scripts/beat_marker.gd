extends Area2D

class_name BeatMarker


@export var tolerances: Array[float]
@export var indicator_ring_max_scale: float = 4
@export var max_radius: float = 30


@onready var _target_ring: Sprite2D = $TargetRing
@onready var _indicator_ring: Sprite2D = $IndicatorRing


var _original_time_to_beat: float
var _remaining_time_to_beat: float


signal score_obtained(score: int)


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
		queue_free()
		return
	
	var opacity: float = 1 - (abs(_remaining_time_to_beat) / _original_time_to_beat)
	_target_ring.modulate = Color(1, 1, 1, opacity)
	
	if _remaining_time_to_beat > 0:
		_indicator_ring.scale = (indicator_ring_max_scale - (indicator_ring_max_scale - 1) * opacity) * Vector2.ONE
	else:
		_indicator_ring.scale = opacity * Vector2.ONE;


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton or not event.pressed:
		return
	
	var radius: float = event.position.distance_to(position)
	
	if radius > max_radius:
		score_obtained.emit(0)
	else:
		var tolerance_count: int = tolerances.size()
		
		for score in range(tolerance_count):
			if abs(_remaining_time_to_beat) <= tolerances[score]:
				score_obtained.emit(tolerance_count - score)
				break
	
	queue_free()
