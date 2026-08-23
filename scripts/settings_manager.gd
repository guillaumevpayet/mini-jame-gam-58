extends Node
class_name SettingsManager

@export var bus_layout: AudioBusLayout


@onready var _dimmer: ColorRect = $Dimmer


func connect_signals(settings_menu: SettingsMenu) -> void:
	settings_menu.brightness_changed.connect(_on_brightness_changed)
	settings_menu.music_volume_changed.connect(_on_music_volume_changed)
	settings_menu.sfx_volume_changed.connect(_on_sfx_volume_changed)
	settings_menu.set_values(1 - _dimmer.modulate.a, 0.5, 0.5)


func _on_brightness_changed(brightness: float) -> void:
	_dimmer.color = Color(0, 0, 0, 1 - brightness)

func _on_music_volume_changed(volume: float) -> void:
	_set_bus_volume("Music", volume)

func _on_sfx_volume_changed(volume: float) -> void:
	_set_bus_volume("SFX", volume)


func _set_bus_volume(bus_name: String, normalized: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var db: float = linear_to_db(normalized) * 60.0
	db = clampf(db, -60.0, 0.0)
	AudioServer.set_bus_volume_db(bus_index, db)
