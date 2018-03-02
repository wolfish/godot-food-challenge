extends RigidBody2D

export (int) var MAX_SPEED;
export (int) var MIN_SPEED;
var collectible_types = [
	'aquarium',
	'fries'
];

func _ready():
	$AnimatedSprite.animation = collectible_types[ randi() % collectible_types.size() ];

func _on_Visibility_screen_exited():
	queue_free();
