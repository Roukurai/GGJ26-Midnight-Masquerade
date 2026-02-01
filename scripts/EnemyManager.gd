extends Node2D

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
@export var maxEnemies: int = 50

@export var player: Node2D
@export var targetTotem: Node2D

var curEnemies := 0
var spawnTimer := 0.0
var playerPos: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	randomize()

func _process(delta):
	if curEnemies >= maxEnemies:
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
	enemy.tree_exited.connect(_on_enemy_destroyed)
	add_child(enemy)
	
func _on_enemy_destroyed():
	curEnemies -= 1
	print("enemies: ", curEnemies)
	#var enemyS := enemyPrefab.assign(enemyId)
	#var enemy := enemyPrefab.insert()
	
