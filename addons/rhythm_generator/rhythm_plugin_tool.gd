@tool
extends Control

@export_category("Audio Input")
@export var ogg_stream: AudioStreamOggVorbis

@export_category("Bus Settings")
@export_range(0, 10) var bus_idx: int = 1
@export_range(0, 100) var effect_idx: int = 0
@export var audio_player: AudioStreamPlayer
@export_category("Configuration")
@export_range(20.0, 50000.0) var freq_start: float = 20.0
@export_range(20.0, 50000.0) var freq_end: float = 20000.0
@export var strong_match_delta: float = 0.05
@export var weak_match_delta: float = 0.1

@export_category("Output")
@export_dir var output_directory: String = "res://resources/songs"

var spectrum_instance: AudioEffectSpectrumAnalyzerInstance

@export_category("Actions")
@export var generate_button: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			_generate_resource()
			spectrum_instance = AudioServer.get_bus_effect_instance(bus_idx, effect_idx)
			
		generate_button = false

func _generate_resource() -> void:
	if not ogg_stream:
		push_error("Please assign an AudioStreamOggVorbis to ogg_stream")
		return
	
	var song = RhythmSong.new()
	song.timing_windows = []
	
	# Generate filename based on audio stream name if possible, or fallback
	var song_name = ogg_stream.resource_name if ogg_stream.resource_name != "" else "rhythm_song"
	var full_path = output_directory.path_join(song_name + ".tres")
	
	# Ensure directory exists before saving
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(output_directory):
		dir.make_dir_recursive(output_directory)
		
	var error = ResourceSaver.save(song, full_path)
	if error != OK:
		push_error("Failed to save resource: " + error_string(error))
	else:
		print("RhythmSong saved to " + full_path)
