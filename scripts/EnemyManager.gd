extends Node2D
class_name EnemiesController

enum EnemyType {
	TANK,
	ROUGE,
	CROWD_CONTROL,
}

enum TargetType {
	POINT,
	PLAYER,
}

#---@export USE FOR VIEW IN VIEWPORT
@export var spawnPoints: Array[Node2D]
@export var enemyPrefab: Array[PackedScene]

@export var spawnInterval: float = 2
@export var maxEnemies: int = 15
@export var perEnemies: float = 0.25

@export var player: Node2D
@export var targetTotem: Node2D

var curEnemies := 0
var spawnTimer := 0.0
var playerPos: CharacterBody2D
var totalEnemiesOnWave := 0

@export var canStart := true

@export var waveEnemies := 0

@export var nextWave := 10

@export var loop: loopGame

func _ready():
	canStart = false
	player = get_tree().get_first_node_in_group("player")
	await get_tree().create_timer(nextWave).timeout
	_start_wave()
	randomize()

func _process(delta):
	if canStart == true:
		if totalEnemiesOnWave >= maxEnemies:
			canStart = false
			return	
						
		if curEnemies <= 0 and totalEnemiesOnWave >= maxEnemies:
			_clear_wave()
			return
			
		spawnTimer += delta
		if spawnTimer >= spawnInterval: 
			spawnTimer = 0.0
			SpawnEnemy()
		
func  SpawnEnemy():
	player = get_tree().get_first_node_in_group("player")
	if spawnPoints.is_empty() or enemyPrefab.is_empty():
		return
		
	var sPoint: Node2D = spawnPoints.pick_random()
	var enemyType: EnemyType = EnemyType.values().pick_random() as int
	var enemyId: int = enemyType
	
	var enemyS := enemyPrefab[enemyId]
	if enemyS == null:
		return
	
	var enemy = enemyS.instantiate()
	enemy.global_position = sPoint.global_position
	
	enemy.set_enemy_type(enemyType)
	
	var targetType: TargetType = TargetType.values().pick_random() as int
	
	if(enemyType == EnemyType.TANK):
			enemy.set_target(targetTotem)
	elif (enemyType == EnemyType.ROUGE):
		if(targetType == TargetType.PLAYER and player):
			enemy.set_target(player)
		else:
			enemy.set_target(targetTotem)
	elif (enemyType == EnemyType.CROWD_CONTROL):
			enemy.set_target(targetTotem)
			
	curEnemies += 1
	totalEnemiesOnWave += 1
	print(totalEnemiesOnWave)
	enemy.tree_exited.connect(_on_enemy_destroyed)
	add_child(enemy)
	
func _on_enemy_destroyed():
	curEnemies -= 1
	
	print("enemies: ", curEnemies)
	
	if curEnemies <= 0 and totalEnemiesOnWave >= maxEnemies:
		_clear_wave()
	#var enemyS := enemyPrefab.assign(enemyId)
	#var enemy := enemyPrefab.insert()

func _start_wave():
	totalEnemiesOnWave = 0
	loop.on_wave_started()
	canStart = true
	print("Wave started")
	pass
	
func next_wave():
	maxEnemies += maxEnemies * perEnemies
	print(maxEnemies)
	await get_tree().create_timer(nextWave).timeout
	totalEnemiesOnWave = 0
	waveEnemies += 1
	_start_wave()

func _clear_wave():
	canStart = false
	loop.on_wave_cleared()
	next_wave()
	print("Wave clear")
	pass
