extends Control
class_name MusicReaderController


#@export_category("Frequencies")
#@export_range(20.0, 50000.0) var freq_start: float
#@export_range(20.0, 50000.0) var freq_end: float
#
#
#func _ready() -> void:
	## assumes bus #1 is the MusicVisualiser and effect #0 is SpectrumAnalyzer
	#
#func _process(delta: float) -> void:
	#var magnitude = spectrum_instance.get_magnitude_for_frequency_range(freq_start, freq_end)
