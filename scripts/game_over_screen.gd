extends Control
class_name GameOverScreen


@onready var _animated_sprite: AnimatedSprite2D = $GradeContainer/AnimatedSprite2D
@onready var _heatwave_material: Material = _animated_sprite.material


signal restart_game


var _win: bool
var _grade: String


func init(perfect_count: int, ok_count: int, miss_count: int, win: bool) -> void:
	_win = win
	
	if not win:
		return
	
	var total: int = perfect_count + ok_count + miss_count
	var percentage_perfect: float = float(perfect_count) / total
	var percentage_ok: float = float(ok_count) / total
	var accuracy: float = ((perfect_count * 1) + (ok_count * 1/3) + (miss_count * 0)) / total
	
	if perfect_count == total:
		_grade = "SS"
	elif accuracy >= 0.9:
		_grade = "S"
	elif accuracy >= 0.8:
		_grade = "A"
	elif accuracy >= 0.7:
		_grade = "B"
	elif accuracy >= 0.6:
		_grade = "C"
	else:
		_grade = "D"


func _ready() -> void:
	if not _win:
		$Label.text = "You lose!"
		$GradeContainer.visible = false
	else:
		$Label.text = "You win!"
		_animated_sprite.play(_grade)
		
		match _grade:
			"D":
				_heatwave_material.set_shader_parameter("heat_level", 0)
			"C":
				_heatwave_material.set_shader_parameter("heat_level", 2)
			"B":
				_heatwave_material.set_shader_parameter("heat_level", 4)
			"A":
				_heatwave_material.set_shader_parameter("heat_level", 6)
			"S":
				_heatwave_material.set_shader_parameter("heat_level", 9)
			"SS":
				_heatwave_material.set_shader_parameter("heat_level", 12)


func _process(_delta: float) -> void:
	_heatwave_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)

func _on_try_again_button_pressed() -> void:
	restart_game.emit()
