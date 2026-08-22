extends Label




func _on_main_game_scene_score_changed(score: int, minimum_target_score) -> void:
	text = "Score: " + str(score) + " / " + str(minimum_target_score)
