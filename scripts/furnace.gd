extends AnimatedSprite2D


@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var _x: AnimatedSprite2D = $XAnimatedSprite2D
@onready var _number: AnimatedSprite2D = $NumberAnimatedSprite2D
@onready var _heatwave_material: Material = material


var _combo: int = 0


func _ready() -> void:
	play()


func _process(_delta: float) -> void:
	_heatwave_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)


func _on_frame_changed() -> void:
	if frame > _combo or (frame == 0 and _combo > 0):
		frame = _combo - 1


func _on_main_game_scene_combo_changed(combo: int) -> void:
	if combo == 0:
		_audio_stream_player.stop()
	else:
		_audio_stream_player.volume_db = 2 * (combo - 12)
		
		if _combo == 0:
			_audio_stream_player.play()

	_x.play(str(combo))
	_number.play(str(combo))
	_heatwave_material.set_shader_parameter("heat_level", combo)
	_combo = combo
