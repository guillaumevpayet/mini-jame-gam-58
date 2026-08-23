extends Control
class_name GameOverScreen


signal restart_game


var _win: bool


func init(win: bool) -> void:
	_win = win


func _ready() -> void:
	if _win:
		$Label.text = "You win!"
	else:
		$Label.text = "You lose"


func _on_try_again_button_pressed() -> void:
	restart_game.emit()
