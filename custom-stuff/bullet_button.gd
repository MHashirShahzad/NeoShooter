extends TweenedButton
class_name BulletButton

@export var level_select : LevelSelect

enum BULLET_TYPE{
	NORMAL,
	SMALL,
	BIG
}


@export var is_p2 : bool = false
@export var bullet_type : BULLET_TYPE = BULLET_TYPE.NORMAL

var bullet_prefs : PlayerBullets

func _ready() -> void:
	bullet_prefs = PlayerBullets.load_or_create()
	self.pressed.connect(_on_pressed)
	# self.focus_entered.connect(_on_hovered)
	self.mouse_entered.connect(_on_hovered)
	load_variables()

func _on_pressed() -> void:
	print("PRESSED BULLET BTRN")
	SFXManager.play_FX(press, -8)
	if is_p2:
		bullet_prefs.p2_bullets = equip_bullet(bullet_prefs.p2_bullets)
	else:
		bullet_prefs.p1_bullets = equip_bullet(bullet_prefs.p1_bullets)
	# update tool text
	level_select.update_tooltip_text(self)
	bullet_prefs.save()

func equip_bullet(equipped_bullets : EquippedBullets) -> EquippedBullets:
	match bullet_type:
		BULLET_TYPE.NORMAL:
			equipped_bullets.normal = equip_normal_bullet(equipped_bullets.normal)
		BULLET_TYPE.SMALL:
			equipped_bullets.small = equip_small_bullet(equipped_bullets.small)
		BULLET_TYPE.BIG:
			equipped_bullets.big = equip_big_bullet(equipped_bullets.big)
			#get_bullet_name(equipped_bullets.big.resource_path)
	
	return equipped_bullets

func equip_normal_bullet(normal : PackedScene) -> PackedScene:
	
	var bullet : PackedScene = load("res://bullets/normal_bullet.tscn")
	
	if normal.resource_path.contains("normal"):
		bullet = load("res://bullets/missile_bullet.tscn")
	else:
		bullet = load("res://bullets/normal_bullet.tscn")
		
	update_variables(bullet.instantiate())
	return bullet

func equip_small_bullet(small : PackedScene) -> PackedScene:
	print_debug("small bullet ")
	var bullet : PackedScene = load("res://bullets/small_bullet.tscn")
	
	if small.resource_path.contains("small"):
		bullet = load("res://bullets/boomerang_bullet.tscn")
	elif small.resource_path.contains("boomerang"):
		bullet = load("res://bullets/homing_bullet.tscn")
	elif small.resource_path.contains("homing"):
		bullet = load("res://bullets/small_bullet.tscn")
		
	update_variables(bullet.instantiate())
	return bullet

func equip_big_bullet(big : PackedScene) -> PackedScene:
	print_debug("Big bullet ")
	var bullet : PackedScene = load("res://bullets/big_bullet.tscn")
	
	if big.resource_path.contains("big"):
		bullet = load("res://bullets/scythe_bullet.tscn")
	elif big.resource_path.contains("scythe"):
		bullet = load("res://bullets/big_bullet.tscn")
		
	update_variables(bullet.instantiate())
	return bullet

func update_variables(bullet : Bullet2D) -> void:
	self.text = bullet.label
	description = bullet.description
	bullet.queue_free()

func load_variables() -> void:
	if is_p2:
		match bullet_type:
			BULLET_TYPE.NORMAL:
				update_variables(bullet_prefs.p2_bullets.normal.instantiate())
			BULLET_TYPE.SMALL:
				update_variables(bullet_prefs.p2_bullets.small.instantiate())
			BULLET_TYPE.BIG:
				update_variables(bullet_prefs.p2_bullets.big.instantiate())
			
		return
	
	match bullet_type:
		BULLET_TYPE.NORMAL:
			update_variables(bullet_prefs.p1_bullets.normal.instantiate())
		BULLET_TYPE.SMALL:
			update_variables(bullet_prefs.p1_bullets.small.instantiate())
		BULLET_TYPE.BIG:
			update_variables(bullet_prefs.p1_bullets.big.instantiate())
