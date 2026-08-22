extends Area2D

class_name BeatMarker


@export var tolerances: Array[float]


@onready var _sprite: Sprite2D = $Sprite2D


var _original_time_to_beat: float
var _remaining_time_to_beat: float


signal score_obtained(score: int)


func init(beat_position: Vector2, time_to_beat: float):
	transform.origin = beat_position
	_original_time_to_beat = time_to_beat
	_remaining_time_to_beat = time_to_beat


func _ready() -> void:
	_sprite.modulate = Color.TRANSPARENT

func _process(_delta: float) -> void:
	_remaining_time_to_beat -= _delta

	if _remaining_time_to_beat <= -_original_time_to_beat:
		queue_free()
		return
	
	var opacity: float = 1 - (abs(_remaining_time_to_beat) / _original_time_to_beat)
	_sprite.modulate = Color(1, 1, 1, opacity)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var tolerance_count: int = tolerances.size()
		
		for score in range(tolerance_count):
			if abs(_remaining_time_to_beat) <= tolerances[score]:
				score_obtained.emit(tolerance_count - score)
				break
		
		queue_free()
