extends Camera2D

@export var shake_strength: float = 20
@export var shake_decay: float = 10


@onready var _original_offset: Vector2 = offset


var _trauma: float = 0.0
var _last_score: int = 0

func _process(_delta: float) -> void:
	if _trauma <= 0:
		return
	
	_trauma = maxf(0, _trauma - _delta * shake_decay * _trauma)
	offset = Vector2(
			randf_range(-1, 1) * shake_strength * _trauma,
			randf_range(-1, 1) * shake_strength * _trauma
	) + _original_offset


func _on_main_game_scene_score_changed(score: int, _minimum_target_score: int) -> void:
	if _last_score == score:
		return
	
	var score_difference: int = score - _last_score
	_trauma = minf(1, score_difference / 24.0 + _trauma)
	_last_score = score
