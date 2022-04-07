extends KinematicBody2D

export(float) var movement_speed: float = 64.0

var _velocity: Vector2 = Vector2.ZERO

var active: bool = true

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if Game.is_cutscene_playing():
		active = false
	else:
		active = true
	
	if active:
		_velocity = movement_speed * Utils.get_input_direction().normalized()
		move_and_slide(_velocity)
