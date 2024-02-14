extends Node2D
@export var enemy_scene : PackedScene
@export var enemy_limit : int
var doors_opened : int = 0
var door_array : Array = [{}]
var score : int = 0
var has_won = false
var effects_array : Array = [{
	  "name": "damage_up",
	  "amount": 10,
	  "duration": -1,
	  "door_message": "+Damage"
	},
	{"name": "bullet_spread_up",
	  "amount": 1,
	  "duration": -1,
	  "door_message": "+Spread"
	},
	{"name": "movement_speed_up",
	  "amount": 100,
	  "duration": -1,
	  "door_message": "+Speed"
	},
	{"name": "movement_speed_down",
	  "amount": 100,
	  "duration": 1,
	  "door_message": "-Speed",
	  "debuff":true
	},
	{"name": "bullet_speed_up",
	  "amount": 100,
	  "duration": -1,
	  "door_message": "+Bullet Speed"
	},
	{"name": "bullet_piercing",
	  "amount": 1,
	  "duration": -1,
	  "door_message": "+Piercing"
	},
	{"name": "max_health_up",
	  "amount": 10,
	  "duration": -1,
	  "door_message": "+Max HP"
	}
  ]



# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemies(3)
	var doors = get_tree().get_nodes_in_group("door")
	
	for door in doors:
		door.connect("door_entered", _on_door_entered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_won == false:
		check_win()


func _on_enemy_enemy_died():
	pass
	
	
func _on_door_entered(doorname):
	has_won=false
	hide_doors()
	spawn_enemies(3)
	
	
func spawn_enemies(enemyCount:int = 1):
	for enemy in enemyCount:
		var new_enemy = enemy_scene.instantiate()
		new_enemy.global_position=Vector2(randi_range(20,get_viewport_rect().size.x-20), randi_range(50,get_viewport_rect().size.y/3))
		new_enemy.connect("enemy_died", _on_enemy_enemy_died)
		add_child(new_enemy)
	
func show_doors():
	door_generator()
	get_tree().call_group("door", "show_doors")
	
func hide_doors():
	get_tree().call_group("door", "hide_doors")
	
func check_win():
	if get_tree().get_nodes_in_group("enemy").size()<=0:
		show_doors()
		has_won=true
		
	else:
		pass

func start_new_level():
	hide_doors()
	
func door_generator():
	get_tree().call_group("door","update_door")
	
		

