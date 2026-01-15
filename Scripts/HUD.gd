extends CanvasLayer

@onready var score_label = $Control/ScoreLabel
@onready var lives_label = $Control/LivesLabel

func _ready():
	# Conectar señales del GameManager
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	
	# Inicializar valores
	_on_score_changed(GameManager.score)
	_on_lives_changed(GameManager.lives)

func _on_score_changed(new_score):
	score_label.text = "Puntaje: " + str(new_score)

func _on_lives_changed(new_lives):
	lives_label.text = "Vidas: " + str(new_lives)
