extends RigidBody2D

export (int) var MAX_SPEED;
export (int) var MIN_SPEED;
var mob_types = [
	'dishes',
	'cooking'
];

func _ready():
	$AnimatedSprite.animation = mob_types[ randi() % mob_types.size() ];

func _on_Visibility_screen_exited():
	queue_free();
