extends Node

export (PackedScene) var Mob;
var score;

func _ready():
	print('ready runned');
	randomize();

func game_over():
	print('game over runned');
	$ScoreTimer.stop();
	$MobTimer.stop();
	$HUD.show_game_over();

func new_game():
	print('new game runned');
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();
	$HUD.update_score(score);
	$HUD.show_message("Przygotuj się!");

func _on_StartTimer_timeout():
	print('start timer timeout');
	$MobTimer.start();
	$ScoreTimer.start();

func _on_ScoreTimer_timeout():
	print('score tick!');
	score += 1;
	$HUD.update_score(score);

func _on_MobTimer_timeout():
	print('mob timeout');
	# choose a random location on the Path2D
	$MobPath/MobSpawnLocation.set_offset(randi())
	# create a Mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	# set the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	# set the mob's position to the random location
	mob.position = $MobPath/MobSpawnLocation.position
	# add some randomness to the direction
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	# choose the velocity
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))

