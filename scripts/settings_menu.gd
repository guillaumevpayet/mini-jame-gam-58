extends Control
class_name SettingsMenu


@onready var _brightness_slider: Slider = $VBoxContainer/BrightnessContainer/BrightnessSlider
@onready var _music_slider: Slider = $VBoxContainer/MusicContainer/MusicSlider
@onready var _sfx_slider: Slider = $VBoxContainer/SFXContainer/SFXSlider


signal brightness_changed(brightness: float)
signal music_volume_changed(volume: float)
signal sfx_volume_changed(volume: float)
signal close_menu


var _brightness: float = 0
var _music_volume: float = 0
var _sfx_volume: float = 0


func set_values(brightness: float, music_volume: float, sfx_volume: float) -> void:
	_brightness = brightness
	_music_volume = music_volume
	_sfx_volume = sfx_volume


func _ready() -> void:
	_brightness_slider.value = _brightness
	_music_slider.value = _music_volume
	_sfx_slider.value = _sfx_volume


func _on_brightness_slider_value_changed(value: float) -> void:
	_brightness = value


func _on_brightness_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	
	brightness_changed.emit(_brightness)



func _on_music_slider_value_changed(value: float) -> void:
	_music_volume = value

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	
	music_volume_changed.emit(_music_volume)



func _on_sfx_slider_value_changed(value: float) -> void:
	_sfx_volume = value

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	
	sfx_volume_changed.emit(_sfx_volume)


func _on_button_pressed() -> void:
	close_menu.emit()
