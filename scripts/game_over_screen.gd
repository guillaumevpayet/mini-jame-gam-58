extends Control
class_name GameOverScreen


@onready var _label: Label = $Label



func set_label_text(new_text: String) -> void:
	_label.text = new_text
