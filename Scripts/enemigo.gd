extends Area2D

signal morir()


@export var velocidad = 200
@export var salud = 3
@export var explosion_scene : PackedScene

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
			explotar_y_morir()
		
	# 2. ¿Me tocó el jugador?
	elif area.is_in_group("jugador"):
		explotar_y_morir()

func explotar_y_morir():
	morir.emit()
	if explosion_scene:
		var boom = explosion_scene.instantiate()
		boom.global_position = global_position	
		get_tree().current_scene.add_child(boom)
		boom.emitting = true
	
	# Busca la cámara activa y la sacude con fuerza 10
	get_viewport().get_camera_2d().aplicar_temblor(10.0)
	queue_free()
