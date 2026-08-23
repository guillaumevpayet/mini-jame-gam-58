extends Node
class_name SettingsManager

@export var bus_layout: AudioBusLayout


@onready var _dimmer: ColorRect = $Dimmer
@onready var sfx_player: AudioStreamPlayer = $"../SfxPlayer"


var _current_brightness: float = 1.0
var _current_music_volume: float = 0.5
var _current_sfx_volume: float = 0.5


func connect_signals(settings_menu: SettingsMenu) -> void:
	settings_menu.brightness_changed.connect(_on_brightness_changed)
	settings_menu.music_volume_changed.connect(_on_music_volume_changed)
	settings_menu.sfx_volume_changed.connect(_on_sfx_volume_changed)
	settings_menu.set_values(_current_brightness, _current_music_volume, _current_sfx_volume)


func _on_brightness_changed(brightness: float) -> void:
	_current_brightness = brightness
	_dimmer.color = Color(0, 0, 0, 1 - brightness)

func _on_music_volume_changed(volume: float) -> void:
	_current_music_volume = volume
	_set_bus_volume("Music", volume)

func _on_sfx_volume_changed(volume: float) -> void:
	_current_sfx_volume = volume
	_set_bus_volume("SFX", volume)
	sfx_player.play()

func _set_bus_volume(bus_name: String, normalized: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	# linear_to_db returns a value in dB (e.g., 0.0 to 1.0 -> -inf to 0)
	var db: float = linear_to_db(normalized)
	# Clamp to a safe range, e.g., -60dB to 0dB, to avoid -inf issues
	db = clampf(db, -60.0, 0.0)
	AudioServer.set_bus_volume_db(bus_index, db)
