extends Node
@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MonsterTimer.stop()
	
	$HUD.show_game_over()
	
func new_game() -> void:
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")

func _on_monster_timer_timeout() -> void:
	var monster = mob_scene.instantiate()
	
	var monster_spawn_location = get_node("MonsterPath/MobSpawnLocation")
	monster_spawn_location.progress_ratio = randf()
	
	var direction = monster_spawn_location.rotation + PI / 2
	monster.position = monster_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	monster.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	monster.linear_velocity = velocity.rotated(direction)
	
	add_child(monster)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
func _on_start_timer_timeout() -> void:
	$MonsterTimer.start()
	$ScoreTimer.start()


