@tool
extends Control
class_name RhythmPluginTool

@export_category("Audio Input")
@export var wav_stream: AudioStreamWAV

@export_category("Configuration")
@export var sensitivity: float = 15.0 # 0-100 threshold
@export_range(0.01, 1.0) var hit_cooldown: float = 0.15 
@export_range(-0.1, 0.1) var timestamp_offset: float = 0.0

@export_category("Output")
@export_dir var output_directory: String = "res://resources/songs"

@export_category("Hit Marker Positioning")
@export var mask_texture: Texture2D
@export var min_proximity: float = 50.0

@export_tool_button("Generate Rhythm Resource", "Callable") var generation_action = _on_generate_pressed

var is_analyzing: bool = false
var marker_history: Array[Vector2] = []

func _on_generate_pressed() -> void:
	if Engine.is_editor_hint():
		_generate_resource()

func _generate_resource() -> void:
	if not wav_stream:
		push_error("Please assign a valid AudioStreamWAV resource")
		return
	
	# Extract raw PCM data
	var pcm_data = wav_stream.data
	if pcm_data.is_empty():
		push_error("AudioStreamWAV data is empty")
		return
	
	# Determine settings from the resource
	var sample_rate = wav_stream.mix_rate
	var is_stereo = wav_stream.stereo
	var format = wav_stream.format 
	var bytes_per_sample = 2
	var channels = 2 if is_stereo else 1
	var frame_size = bytes_per_sample * channels
	
	var current_song = RhythmSong.new()
	current_song.timing_windows = [] as Array[RhythmTimingWindow]
	marker_history = []
	
	var last_hit_time: float = -1.0
	var threshold = (sensitivity / 100.0) * 32768.0
	
	var max_found = 0.0
	
	for i in range(0, pcm_data.size(), frame_size):
		if i + frame_size > pcm_data.size():
			break
		
		var left = pcm_data.decode_s16(i)
		var right = 0.0
		if is_stereo:
			right = pcm_data.decode_s16(i + 2)
		
		var amplitude = (abs(left) + abs(right)) / 2.0
		if amplitude > max_found:
			max_found = amplitude
		
		if amplitude > threshold:
			var current_time = float(i) / (sample_rate * bytes_per_sample * channels)
			if current_time - last_hit_time > hit_cooldown:
				_add_hit(current_song, current_time)
				last_hit_time = current_time
	
	print("Max amplitude: ", max_found)
	_save_resource(current_song)

func _save_resource(song: RhythmSong) -> void:
	var song_name = wav_stream.resource_name if wav_stream.resource_name != "" else "rhythm_song"
	var full_path = output_directory.path_join(song_name + ".tres")
	
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(output_directory):
		dir.make_dir_recursive(output_directory)
		
	var error = ResourceSaver.save(song, full_path)
	if error != OK:
		push_error("Failed to save resource: " + error_string(error))
	else:
		print("RhythmSong saved to " + full_path)

func calculate_window_position(window: RhythmTimingWindow):
	if not mask_texture:
		var viewport_size = Vector2(get_viewport().size)
		window.position = viewport_size / 2.0
		return

	var image = mask_texture.get_image()
	
	var valid_pos = false
	var new_position = Vector2.ZERO
	var attempts = 0
	
	while not valid_pos and attempts < 100:
		attempts += 1
		var x = randi_range(0, image.get_width() - 1)
		var y = randi_range(0, image.get_height() - 1)
		
		# Assuming white (r > 0.5) is the valid area
		if image.get_pixel(x, y).r > 0.5:
			# Direct 1:1 mapping of pixel coordinate to screen position
			new_position = Vector2(x, y)
			
			var too_close = false
			for prev_pos in marker_history:
				if new_position.distance_to(prev_pos) < min_proximity:
					too_close = true
					break
			
			if not too_close:
				valid_pos = true
	
	window.position = new_position
	marker_history.append(new_position)
	if marker_history.size() > 3:
		marker_history.pop_front()

func _add_hit(song: RhythmSong, timestamp: float) -> void:
	var window = RhythmTimingWindow.new()
	window.timestamp = timestamp - timestamp_offset
	calculate_window_position(window)
	song.timing_windows.append(window)
