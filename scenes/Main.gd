extends Node

export (PackedScene) var Mob;
export (PackedScene) var Collectible;
var score;

func _ready():
	# Center game window on screen
	var screen_size = OS.get_screen_size();
	var window_size = OS.get_window_size();
	OS.set_window_position(screen_size*0.5 - window_size*0.5);
	
	# Set mob path around the screen edges
	$MobPath.curve.clear_points();
	$MobPath.curve.add_point(Vector2(0,0));
	$MobPath.curve.add_point(Vector2(window_size[0],0));
	$MobPath.curve.add_point(Vector2(window_size[0],window_size[1]));
	$MobPath.curve.add_point(Vector2(0,window_size[1]));
	$MobPath.curve.tessellate();
	
	# Center player position
	$StartPosition.position = Vector2(window_size[0] / 2, window_size[1] / 2);
	
	randomize();

func game_over():
	$Player.get_node('CollisionShape2D').disabled = true;
	$Player.hide();
	$MobTimer.stop();
	$HUD.get_node('ScoreTimer').stop();
	$CollectibleTimer.stop();
	$HUD.show_game_over();

func new_game():
	score = 0;
	$HUD.gameTimeSeconds = 0;
	$HUD.gameTimeMinutes = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();
	$HUD.get_node('ScoreTimer').start();
	$HUD.update_score(score);
	$HUD.update_time(0,0);
	$HUD.show_message("Przygotuj się!");

func _on_StartTimer_timeout():
	$MobTimer.start();
	$CollectibleTimer.start();
	$ScoreTimer.start();

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi());
	var mob = Mob.instance();
	add_child(mob);
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2;
	mob.position = $MobPath/MobSpawnLocation.position;
	direction += rand_range(-PI/4, PI/4);
	mob.rotation = direction;
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction));

func collected():
	score += 100;
	$HUD.update_score(score);
	$HUD.add_life();
	if $Player.HEALTH < $Player.MAXHEALTH:
		$Player.HEALTH += 1;
		var newScale = 1;
		if $Player.HEALTH != 1:
			newScale = (float($Player.HEALTH) / 10) + 1;
		$Player.SPEED -= 30;
		$Player.scale = Vector2(newScale, newScale);

func hit():
	if score > 200:
		score -= 200;
	else:
		score = 0;
		
	$HUD.update_score(score);
	$HUD.sub_life();
	
	if $Player.HEALTH > 1:
		$Player.HEALTH -= 1;
		var newScale = 1;
		if $Player.HEALTH != 1:
			newScale = (float($Player.HEALTH) / 10) + 1;
		$Player.SPEED += 30;
		$Player.scale = Vector2(newScale, newScale);
	else:
		game_over();


func _on_CollectibleTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi());
	var collectible = Collectible.instance();
	add_child(collectible);
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2;
	collectible.position = $MobPath/MobSpawnLocation.position;
	direction += rand_range(-PI/4, PI/4);
	collectible.rotation = direction;
	collectible.set_linear_velocity(Vector2(rand_range(collectible.MIN_SPEED, collectible.MAX_SPEED), 0).rotated(direction));
