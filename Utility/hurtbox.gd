extends Area2D

@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disabletimer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set","disabled",true)
					disabletimer.start()
				1: #HitOnce
					pass
				2: #DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
				
			emit_signal("hurt",damage,angle,knockback)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)

func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set","disabled",false)
