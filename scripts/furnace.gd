extends AnimatedSprite2D


var _combo: int = 0


func _ready() -> void:
	play()


func _on_frame_changed() -> void:
	if frame > _combo or (frame == 0 and _combo > 0):
		frame = _combo - 1


func _on_main_game_scene_combo_changed(combo: int) -> void:
	_combo = combo
