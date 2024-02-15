extends Resource
class_name Character

#treat -1 as infinite
@export var magazine_size : int = 0
@export var fire_rate : float = 0

@export var damage : int = 0
@export var bullet_speed : int = 0
@export var movement_speed : int = 0
@export var max_health : int = 0
#Always one bullet in the middle. Each additional bullet adds 1 to either side of center. A 1 means 3 bullets will be fired. 2 will fire 5 bullets.
@export var extra_bullets_in_spread : int = 0 
@export var bullet_spread_angle : float = 0


