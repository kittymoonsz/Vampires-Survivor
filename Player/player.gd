extends CharacterBody2D

@export var speed = 40.0
@export var hp = 30
@onready var sprite = get_node("Sprite2D")
@onready var walkTimer = get_node("%walkTimer")

#Attacks
var iceSpear = preload("res://Player/Weapons/ice_spear.tscn")

#AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")

#iceSpear
var iceSpear_ammo = 0
var iceSpear_baseAmmo = 1
var iceSpear_attackSpeed = 1.5
var iceSpear_level = 1

#Enemy Related
var enemy_close = []

func _ready() -> void:
	attack()

func _physics_process(delta: float) -> void:
	movement()

func movement():
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	if velocity != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes -1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	move_and_slide()
	
func attack():
	if iceSpear_level > 0:
		iceSpearTimer.wait_time = iceSpear_attackSpeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func _on_hurtbox_hurt(damage: Variant, _angle, _knockback) -> void:
	hp -= damage
	print(hp)
	
func _on_ice_spear_timer_timeout() -> void:
	iceSpear_ammo += iceSpear_baseAmmo
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if iceSpear_ammo > 0:
		var iceSpear_attack = iceSpear.instantiate()
		iceSpear_attack.position = position
		iceSpear_attack.target = get_random_target()
		iceSpear_attack.level = iceSpear_level
		add_child(iceSpear_attack)
		iceSpear_ammo -= 1
		if iceSpear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
