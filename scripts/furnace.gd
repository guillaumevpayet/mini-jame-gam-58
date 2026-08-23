extends AnimatedSprite2D


@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var _x: AnimatedSprite2D = $XAnimatedSprite2D
@onready var _number: AnimatedSprite2D = $NumberAnimatedSprite2D
@onready var _heatwave_material: Material = material
@onready var furnace = $"."

var base_scale: Vector2
var scale_tween
var rotation_tween

var _combo: int = 0


func _ready() -> void:
	base_scale = furnace.scale
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
		_audio_stream_player.volume_db = 2 * (combo - 24)
		
		if _combo == 0:
			_audio_stream_player.play()
		
		if combo > 6 and scale_tween == null:
			combo_tweens(combo)
		elif combo <= 6 and scale_tween != null:
			scale_tween.kill()
			scale_tween = null
			furnace.scale = base_scale

	_x.play(str(combo))
	_number.play(str(combo))
	_heatwave_material.set_shader_parameter("heat_level", combo)
	_combo = combo


func combo_tweens(current_combo: int)-> void:
	scale_tween = create_tween()
	scale_tween.set_loops()
	scale_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	scale_tween.tween_method(
		func(weight: float):
			var combo_scale: float = 1.0 + (0.02 * (_combo - 6))
			furnace.scale = base_scale.lerp(base_scale * combo_scale, weight),
			0.0, 1.0, 0.3)
	
	scale_tween.tween_method(
		func(weight: float):
			furnace.scale = furnace.scale.lerp(base_scale, weight),
			0.0, 1.0, 0.3)
	
	#rotation_tween = create_tween()
