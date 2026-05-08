extends Area2D

@onready var bloqueador: StaticBody2D = $"../bloqueador"
@onready var porta_final: Area2D = $"."

var player_dentro := false

func _ready() -> void:
	print(bloqueador)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if player_dentro and Input.is_action_just_pressed("abrir_porta") and Global.chave:
		print("abriu")
		for shape in bloqueador.get_children():
			if shape is CollisionShape2D:
				shape.set_deferred("disabled", true)
				queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("funciona porfavor")
	if body.is_in_group("Player"):  
		print("player entrou")
		player_dentro = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_dentro = false
