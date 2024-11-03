extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

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
		
func _on_hurtbox_hurt(damage: Variant, angle, knockback_amount) -> void:
	knockback = angle * knockback_amount
	hp -= damage
	if hp <= 0:
		queue_free()
