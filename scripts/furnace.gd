extends AnimatedSprite2D


@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var _x: AnimatedSprite2D = $XAnimatedSprite2D
@onready var _number: AnimatedSprite2D = $NumberAnimatedSprite2D
@onready var _heatwave_material: Material = material
@onready var furnace = $"."

var base_scale: Vector2
var base_rotation: float
var scale_tween
var rotation_tween

func _ready() -> void:
	base_scale = furnace.scale
	base_rotation = furnace.rotation
	play()


func _process(_delta: float) -> void:
	_heatwave_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)


func _on_frame_changed() -> void:
	if frame > Globals.current_combo or (frame == 0 and Globals.current_combo > 0):
		frame = Globals.current_combo - 1


func _on_main_game_scene_combo_changed() -> void:
	if Globals.current_combo == 0:
		_audio_stream_player.stop()
	else:
		_audio_stream_player.volume_db = 2 * (Globals.current_combo - 24)
		
		if !_audio_stream_player.playing:
			_audio_stream_player.play()
		
		if Globals.current_combo > 6:
			if scale_tween == null:
				pulse_tween()
			if rotation_tween == null:
				wiggle_tween()
		elif Globals.current_combo <= 6:
			if scale_tween != null:
				scale_tween.kill()
				scale_tween = null
				furnace.scale = base_scale
			if rotation_tween != null:
				rotation_tween.kill()
				rotation_tween = null
				furnace.rotation = base_rotation

	_x.play(str(Globals.current_combo))
	_number.play(str(Globals.current_combo))
	_heatwave_material.set_shader_parameter("heat_level", Globals.current_combo)


func pulse_tween()-> void:
	scale_tween = create_tween()
	scale_tween.set_loops()
	scale_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	scale_tween.tween_method(
		func(weight: float):
			var combo_scale: float = 1.0 + (0.02 * (Globals.current_combo - 6))
			furnace.scale = base_scale.lerp(base_scale * combo_scale, weight),
			0.0, 1.0, 0.3)
	
	scale_tween.tween_method(
		func(weight: float):
			furnace.scale = furnace.scale.lerp(base_scale, weight),
			0.0, 1.0, 0.3)

func wiggle_tween()-> void:
	rotation_tween = create_tween()
	rotation_tween.set_loops()
	rotation_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	rotation_tween.tween_method(
		func(weight: float):
			var combo_rotation: float = 0.002 * (Globals.current_combo - 6)
			furnace.rotation =  combo_rotation * weight,
			0.0, 1.0, 0.15
	)
	rotation_tween.tween_method(
		func(weight: float):
			var combo_rotation: float = 0.002 * (Globals.current_combo - 6)
			furnace.rotation = combo_rotation * weight, 
			1.0, -1.0, 0.3
	)
	var start_rotation: float = furnace.rotation
	rotation_tween.tween_method(
		func(weight: float):
			furnace.rotation = lerp(start_rotation, base_rotation, weight),
			0.0, 1.0, 0.15
	)
