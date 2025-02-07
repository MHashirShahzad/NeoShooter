extends Control
class_name PlayerHud


@export var ani_duration : float = .55
@export var player_name : String = "Player 1"


@onready var player_label: RichTextLabel = $PlayerNameLabel
@onready var bullet_label: RichTextLabel = $BG/BulletLabel

@onready var ani_player: AnimationPlayer = $AniPlayer

@onready var health_bar: ProgressBar = $BG/HealthBar
@onready var damage_bar: ProgressBar = $BG/HealthBar/DamageBar


func _ready() -> void:
	player_label.text = "%s" % player_name
	

func update_color(player: Player2D):
	player_label.self_modulate = player.body.color

func update_health_bar(health : float):
	health_bar.value = health
	ani_player.play("hit")
	print("UPDATING HEALTH")
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(damage_bar, "value", health, ani_duration)
	tween.set_ease(Tween.EASE_OUT)
	
	await tween.finished
	tween.kill()

func update_bullet_label(bullet_count : int):
	bullet_label.text = "[center]Bullets: %s[/center]" % str(bullet_count)
	$SmallCPU.emitting = true
