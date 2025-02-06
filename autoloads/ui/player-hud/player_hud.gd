extends Control
class_name PlayerHud

@export var ani_duration : float = .75
@export var player_name : String = "Player 1"

@onready var health_bar: ProgressBar = $VBoxContainer/HBoxContainer/HealthBar
@onready var damage_bar: ProgressBar = $VBoxContainer/HBoxContainer/HealthBar/DamageBar


func _ready() -> void:
	$VBoxContainer/Label.text = "- %s -" % player_name

func update_health_bar(health : float):
	health_bar.value = health
	
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(damage_bar, "value", health, ani_duration)
	tween.set_ease(Tween.EASE_OUT)
	
	await tween.finished
	tween.kill()
