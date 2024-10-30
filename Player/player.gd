extends CharacterBody2D

@export var speed = 40.0
@export var hp = 30
@onready var sprite = get_node("Sprite2D")
@onready var walkTimer = get_node("walkTimer")

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

func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
