extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hit_sound = $hit_sound

var death_anim = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object)

func _ready():
	anim.play("walk")

func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < 0.1:
		sprite.flip_h = false
		
func death():
		emit_signal("remove_from_array", self)
		var enemy_death = death_anim.instantiate()
		enemy_death.scale = sprite.scale
		enemy_death.global_position = global_position
		get_parent().call_deferred("add_child", enemy_death)
		queue_free()
		
func _on_hurtbox_hurt(damage: Variant, angle, knockback_amount) -> void:
	knockback = angle * knockback_amount
	hp -= damage
	if hp <= 0:
		death()
	else:
		hit_sound.play()
