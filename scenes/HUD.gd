extends CanvasLayer

signal start_game;
var gameStarted = false;
var gameTimeSeconds = 0;
var gameTimeMinutes = 0;

func show_message(text):
	$MessageLabel.text = text;
	$MessageLabel.show();
	$MessageTimer.start();

func show_game_over():
	gameStarted = false;
	show_message("KONIEC GRY!");
	yield($MessageTimer, "timeout");
	$MessageLabel.text = "PRZEGRAŁEŚ!\nZAGRAJ PONOWNIE!";
	$MessageLabel.show();
	
func update_time(minutes, seconds):
	minutes = str(minutes);
	seconds = str(seconds);
	if minutes.length() < 2 :
		minutes = '0' + minutes;
	if seconds.length() < 2 :
		seconds = '0' + seconds;
	$TimeLabel.text = "Czas: " + minutes + ":" + seconds;

func update_score(score):
	$ScoreLabel.text = "Punkty: " + str(score);
	
func add_life():
	$LifeBar.value = $LifeBar.value + $LifeBar.step;
	
func sub_life():
	$LifeBar.value = $LifeBar.value - $LifeBar.step;

func _on_StartButton_pressed():
	$StartButton.hide();
	$ScoreButton.hide();
	$OptionsButton.hide();
	$ExitButton.hide();
	gameStarted = true;
	add_life();
	emit_signal("start_game");
	
func _on_MessageTimer_gameOverTimeout():
	if !gameStarted:
		$StartButton.show();
		$ScoreButton.show();
		$ExitButton.show();
		$OptionsButton.show();

func _on_MessageTimer_timeout():
	if gameStarted:
		$MessageLabel.hide();

func _on_ExitButton_pressed():
	get_tree().quit();

func _on_ScoreTimer_timeout():
	gameTimeSeconds += 1;
	if gameTimeSeconds == 60 :
		gameTimeMinutes += 1;
		gameTimeSeconds = 0;
	update_time(gameTimeMinutes, gameTimeSeconds);
