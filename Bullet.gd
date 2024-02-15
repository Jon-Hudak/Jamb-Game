extends Area2D

@export var speed : int = 100
@export var damage: float = 0
@export var sprite: CompressedTexture2D
@export var sprite_scale: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite:
		$Sprite2D.texture=sprite
		$Sprite2D.scale=Vector2(sprite_scale,sprite_scale)
	else:
		pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction : Vector2 = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		print(damage)
		queue_free()
		
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
