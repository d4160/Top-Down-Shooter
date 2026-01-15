extends Area2D

signal morir()


@export var velocidad = 200
@export var salud = 3

@onready var health_bar = get_node_or_null("ProgressBar")

func _ready():
	if health_bar:
		health_bar.max_value = salud
		health_bar.value = salud

func _process(delta):
	position.y += velocidad * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Conecta la señal "area_entered" del propio Area2D a este script
func _on_area_entered(area):
	# 1. ¿Me tocó una bala?
	if area.is_in_group("balas_jugador"):
		area.queue_free()  # Destruimos la bala
		salud -= 1         # Restamos salud
		if health_bar:
			health_bar.value = salud
		
		if salud <= 0:
			morir.emit()
			queue_free()   # Nos destruimos solo si no queda salud
		
	# 2. ¿Me tocó el jugador?
	elif area.is_in_group("jugador"):
		morir.emit()
		queue_free()       # Destruimos al enemigo
