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
			get_bullet_name(equipped_bullets.small.resource_path)
		BULLET_TYPE.BIG:
			get_bullet_name(equipped_bullets.big.resource_path)
	
	return equipped_bullets

func get_bullet_name(path : String) -> String:
	path = path.replace("res://bullets/", "")
	path = path.replace("_bullet.tscn", "")
	return path

func equip_normal_bullet(normal : PackedScene) -> PackedScene:
	var name : String  = get_bullet_name(normal.resource_path)
	
	var bullet : PackedScene = load("res://bullets/normal_bullet.tscn")
	
	if name == "normal":
		bullet = load("res://bullets/missile_bullet.tscn")
		update_variables(bullet.instantiate())
	else:
		bullet = load("res://bullets/normal_bullet.tscn")
		update_variables(bullet.instantiate())
		
	return bullet

func update_variables(bullet : Bullet2D) -> void:
	self.text = bullet.label
	description = bullet.description

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
