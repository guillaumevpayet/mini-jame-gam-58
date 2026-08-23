extends Node

@export var title_screen_scene: PackedScene
@export var settings_scene: PackedScene
@export var main_game_scene: PackedScene
@export var game_over_screen_scene: PackedScene


@onready var _active_scene: Node = $TitleScreen


func _on_title_screen_start_game() -> void:
	var main_game: MainGameScene = main_game_scene.instantiate()
	main_game.game_over.connect(_on_main_game_screen_game_over)
	_replace_scene(main_game)

func _on_title_screen_open_settings_menu() -> void:
	pass # Replace with function body.


func _on_main_game_screen_game_over(win: bool) -> void:
	var game_over_screen: GameOverScreen = game_over_screen_scene.instantiate()
	game_over_screen.init(win)
	game_over_screen.restart_game.connect(_on_main_game_screen_restart_game)
	_replace_scene(game_over_screen)

func _on_main_game_screen_restart_game() -> void:
	var main_game: MainGameScene = main_game_scene.instantiate()
	main_game.game_over.connect(_on_main_game_screen_game_over)
	_replace_scene(main_game)


func _replace_scene(new_scene: Node) -> void:
	_active_scene.queue_free()
	remove_child(_active_scene)
	add_child(new_scene)
	_active_scene = new_scene
