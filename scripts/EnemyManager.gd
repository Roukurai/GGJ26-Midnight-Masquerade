extends Node2D
@export var totem:Node2D

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
@export var targetTotem: Array[Node2D]
