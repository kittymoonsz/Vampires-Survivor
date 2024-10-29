extends CharacterBody2D

var speed = 40.0

func _physics_process(delta: float) -> void:
	movement()

func movement():
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()
