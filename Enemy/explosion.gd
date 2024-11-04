extends Sprite2D

func _ready() -> void:
	$AnimationPlayer.play("explode")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
