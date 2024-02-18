extends Node2D
@export var enemy_scene : PackedScene
@export var enemy_limit : int
@export var boss_scene :PackedScene
var doors_opened : int = 0
var door_array : Array = [{}]
var score : int = 0
var has_won = false
var enemy_bonus : Array [Status_Effects_Resource]



# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn_enemies(3, doors_opened)
	var doors = get_tree().get_nodes_in_group("door")
	
	for door in doors:
		door.connect("door_entered", _on_door_entered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_won == false:
		check_win()


	
func _on_door_entered(doorname : String, enemy_status_effects: Array[Status_Effects_Resource]):
	has_won=false
	hide_doors()
	enemy_bonus=enemy_status_effects
	$Player.global_position=$PlayerSpawner.global_position
	
	doors_opened+=1
	spawn_enemies(3,doors_opened+10)
	
	
func spawn_enemies(enemyCount:int = 1, level:int = 0):
	if ((level+5) % 2 !=0):
		for enemy in enemyCount+floor(level):
			var new_enemy = enemy_scene.instantiate()
			new_enemy.global_position=[$Marker2D, $Marker2D2, $Marker2D3].pick_random().global_position+Vector2(randi_range(-20,20),randi_range(-20,20))
			#new_enemy.global_position=Vector2(randi_range(20,get_viewport_rect().size.x-20), randi_range(50,get_viewport_rect().size.y/3))
			if enemy_bonus:
				new_enemy.status_effect_resource=enemy_bonus
			new_enemy.max_health+= 10 + floor(level*0.5)
			add_child(new_enemy)
	else:
		var boss = boss_scene.instantiate()
		boss.global_position=Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/3)
		if enemy_bonus:
			boss.status_effect_resource=enemy_bonus
			add_child(boss)
	
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
	
		

