extends Control

func _ready():
	$VBoxContainer/ScoreLabel.text = "Puntaje Final: " + str(GameManager.score)
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)

func _on_restart_pressed():
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://Scenes/Mundo.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
