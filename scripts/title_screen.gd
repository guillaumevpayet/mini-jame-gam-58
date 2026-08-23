extends Control
class_name TitleScreen


signal start_game
signal open_settings_menu



func _on_settings_button_pressed() -> void:
	open_settings_menu.emit()

func _on_start_button_pressed() -> void:
	start_game.emit()
