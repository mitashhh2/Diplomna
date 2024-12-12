extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -275.0
const GRAVITY = 800.0
const JUMP_HOLD_TIME = 0.3

var jump_time = 0.0
var is_jumping = false

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		jump_time = 0.0

	if Input.is_action_pressed("ui_accept") and is_jumping:
		if jump_time < JUMP_HOLD_TIME:
			velocity.y += JUMP_VELOCITY * delta
			jump_time += delta

	if Input.is_action_just_released("ui_accept") and is_jumping:
		if velocity.y < 0:
			velocity.y = 0
		is_jumping = false

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		if is_on_floor() and (!sprite.is_playing() or sprite.animation != "run"):
			sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite.play("idle")

	move_and_slide()
