extends Node

signal score_changed(new_score)
signal lives_changed(new_lives)
signal game_over
signal victory

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)

var lives: int = 3:
	set(value):
		lives = value
		lives_changed.emit(lives)
		if lives <= 0:
			game_over.emit()

func reset_game():
	score = 0
	lives = 3

func add_score(points: int):
	score += points

func lose_life():
	lives -= 1

func win_game():
	victory.emit()
