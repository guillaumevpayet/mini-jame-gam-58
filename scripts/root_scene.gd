extends Node

@export var title_screen_scene: PackedScene
@export var settings_menu_scene: PackedScene
@export var main_game_scene: PackedScene
@export var game_over_screen_scene: PackedScene


@onready var _settings_manager: SettingsManager = $SettingsManager
@onready var _game_screen: Node = $GameScreen
@onready var _active_scene: Node = $GameScreen/TitleScreen
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_title_screen_start_game() -> void:
	audio_stream_player.stop()
	var main_game: MainGameScene = main_game_scene.instantiate()
	main_game.game_over.connect(_on_main_game_screen_game_over)
	_replace_scene(main_game)

func _on_title_screen_open_settings_menu() -> void:
	var settings_menu: SettingsMenu = settings_menu_scene.instantiate()
	_settings_manager.connect_signals(settings_menu)
	settings_menu.close_menu.connect(_on_settings_menu_close_menu)
	_replace_scene(settings_menu)

func _on_settings_menu_close_menu() -> void:
	var title_screen: TitleScreen = title_screen_scene.instantiate()
	title_screen.start_game.connect(_on_title_screen_start_game)
	title_screen.open_settings_menu.connect(_on_title_screen_open_settings_menu)
	_replace_scene(title_screen)

func _on_main_game_screen_game_over(perfect_count: int, ok_count: int, miss_count: int, win: bool) -> void:
	audio_stream_player.play()
	var game_over_screen: GameOverScreen = game_over_screen_scene.instantiate()
	game_over_screen.init(perfect_count, ok_count, miss_count, win)
	game_over_screen.restart_game.connect(_on_game_over_screen_restart_game)
	_replace_scene(game_over_screen)

func _on_game_over_screen_restart_game() -> void:
	Globals.current_combo = 0
	audio_stream_player.stop()
	var main_game: MainGameScene = main_game_scene.instantiate()
	main_game.game_over.connect(_on_main_game_screen_game_over)
	_replace_scene(main_game)



func _replace_scene(new_scene: Node) -> void:
	_active_scene.queue_free()
	_game_screen.remove_child(_active_scene)
	_game_screen.add_child(new_scene)
	_active_scene = new_scene
