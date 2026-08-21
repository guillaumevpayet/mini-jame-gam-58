@tool
extends Control
class_name RhythmPluginTool

@export_category("Audio Input")
@export var ogg_stream: AudioStreamOggVorbis

@export_category("Bus Settings")
@export_range(0, 10) var bus_idx: int = 1
@export_range(0, 100) var effect_idx: int = 0
@export var audio_player: AudioStreamPlayer
@export_category("Configuration")
@export_range(20.0, 50000.0) var freq_start: float = 20.0
@export_range(20.0, 50000.0) var freq_end: float = 20000.0
@export_range(0.001, 1.0) var energy_threshold: float = 0.08
@export_range(1, 10) var sample_amt: int = 3
@export_tool_button("Generate Rhythm Resource", "Callable") var generation_action = _on_generate_pressed

@export_category("Output")
@export_dir var output_directory: String = "res://resources/songs"

var spectrum_instance: AudioEffectSpectrumAnalyzerInstance

func _on_generate_pressed() -> void:
	if Engine.is_editor_hint():
		_generate_resource()

func _ready() -> void:
	if Engine.is_editor_hint():
		spectrum_instance = AudioServer.get_bus_effect_instance(bus_idx, effect_idx)

var is_analyzing: bool = false
var current_song: RhythmSong
var is_in_window: bool = false
var window_start_time: float = 0.0
var window_end_time: float = 0.0

var energy_accumulator: float = 0.0
var samples_in_accumulator: int = 0

func _process(_delta: float) -> void:
	if not is_analyzing:
		return
	
	if not audio_player.playing:
		_finalize_analysis()
		return
	
	var magnitude = spectrum_instance.get_magnitude_for_frequency_range(freq_start, freq_end).length()
	energy_accumulator += magnitude
	samples_in_accumulator += 1
	
	# Check stable average every sample_amt samples
	if samples_in_accumulator >= sample_amt:
		var average_magnitude = energy_accumulator / samples_in_accumulator
		energy_accumulator = 0.0
		samples_in_accumulator = 0
		
		var current_time = audio_player.get_playback_position()
		
		if average_magnitude > energy_threshold:
			if not is_in_window:
				is_in_window = true
				window_start_time = current_time
			window_end_time = current_time
		else:
			if is_in_window:
				# Period ended, create window
				is_in_window = false
				_add_window(window_start_time, window_end_time)

func _generate_resource() -> void:
	if not ogg_stream:
		push_error("Please assign an AudioStreamOggVorbis to ogg_stream")
		return
	if not audio_player:
		push_error("Please assign an AudioStreamPlayer")
		return
	
	# Start playback
	audio_player.stop()
	audio_player.seek(0.0)
	spectrum_instance = AudioServer.get_bus_effect_instance(bus_idx, effect_idx)
	audio_player.play()
	
	current_song = RhythmSong.new()
	current_song.timing_windows = [] as Array[RhythmTimingWindow]
	is_in_window = false
	is_analyzing = true
	energy_accumulator = 0.0
	samples_in_accumulator = 0

func _finalize_analysis() -> void:
	is_analyzing = false
	
	# Final check if window was active when song ended
	if is_in_window:
		is_in_window = false
		_add_window(window_start_time, window_end_time)
	
	audio_player.stop()
	
	# Create a new, clean RhythmSong resource
	var final_song = RhythmSong.new()
	
	# Sort windows by timestamp
	current_song.timing_windows.sort_custom(func(a, b): return a.timestamp < b.timestamp)
	
	# Populate the new resource's timing windows
	final_song.timing_windows = current_song.timing_windows
	
	# Generate filename based on audio stream name if possible, or fallback
	var song_name = ogg_stream.resource_name if ogg_stream.resource_name != "" else "rhythm_song"
	var full_path = output_directory.path_join(song_name + ".tres")
	
	# Ensure directory exists before saving
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(output_directory):
		dir.make_dir_recursive(output_directory)
		
	var error = ResourceSaver.save(final_song, full_path)
	if error != OK:
		push_error("Failed to save resource: " + error_string(error))
	else:
		print("RhythmSong saved to " + full_path)
	current_song = null

func _add_window(start: float, end: float) -> void:
	# Define window based on the start and end of the burst
	var window = RhythmTimingWindow.new()
	window.timestamp = (start + end) / 2.0
	current_song.timing_windows.append(window)
