extends Area2D

class_name BeatMarker


@export var tolerances: Array[float]
@export var indicator_ring_max_scale: float = 5


@onready var _sprite: Sprite2D = $Sprite2D
@onready var _indicator_ring: Sprite2D = $IndicatorRing


var _original_time_to_beat: float
var _remaining_time_to_beat: float


signal score_obtained(score: int)


func init(beat_position: Vector2, time_to_beat: float):
	transform.origin = beat_position
	_original_time_to_beat = time_to_beat
	_remaining_time_to_beat = time_to_beat


func _ready() -> void:
	_sprite.modulate = Color.TRANSPARENT
	_indicator_ring.scale = indicator_ring_max_scale * Vector2.ONE

func _process(_delta: float) -> void:
	_remaining_time_to_beat -= _delta

	if _remaining_time_to_beat <= -_original_time_to_beat:
		queue_free()
		return
	
	var opacity: float = 1 - (abs(_remaining_time_to_beat) / _original_time_to_beat)
	_sprite.modulate = Color(1, 1, 1, opacity)
	
	if _remaining_time_to_beat >= 0:
		_indicator_ring.scale = indicator_ring_max_scale * (1 - opacity) * Vector2.ONE
	elif _indicator_ring.is_visible():
		_indicator_ring.hide()


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var tolerance_count: int = tolerances.size()
		
		for score in range(tolerance_count):
			if abs(_remaining_time_to_beat) <= tolerances[score]:
				score_obtained.emit(tolerance_count - score)
				break
		
		queue_free()
