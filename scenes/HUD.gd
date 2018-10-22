extends CanvasLayer

signal start_game;
var gameStarted = false;
var gameTimeSeconds = 0;
var gameTimeMinutes = 0;
var LifeBar;
var ScoreLabel;
var TimeLabel;

func _ready():
	LifeBar = get_node('Screen/Main/TopBar/LifeContainer/LifeBar');
	ScoreLabel = get_node('Screen/Main/TopBar/ScoreContainer/ScoreLabel');
	TimeLabel = get_node('Screen/Main/TopBar/TimeContainer/TimeLabel');

func show_message(text):
	$Screen/Main/MessageLabel.text = text;
	$Screen/Main/MessageLabel.show();
	$MessageTimer.start();

func show_game_over():
	$MenuMusic.play();
	$GameMusic.stop();
	gameStarted = false;
	show_message("KONIEC GRY!");
	yield($MessageTimer, "timeout");
	$Screen/Main/MessageLabel.text = "PRZEGRAŁEŚ!\nZAGRAJ PONOWNIE!";
	$Screen/Main/MessageLabel.show();
	
func update_time(minutes, seconds):
	minutes = str(minutes);
	seconds = str(seconds);
	if minutes.length() < 2 :
		minutes = '0' + minutes;
	if seconds.length() < 2 :
		seconds = '0' + seconds;
	TimeLabel.text = "Czas: " + minutes + ":" + seconds;

func update_score(score):
	ScoreLabel.text = "Punkty: " + str(score);
	
func add_life():
	LifeBar.value = LifeBar.value + LifeBar.step;
	
func sub_life():
	LifeBar.value = LifeBar.value - LifeBar.step;

func _on_StartButton_pressed():
	$Screen/Main/ButtonsContainer/StartButton.hide();
	$Screen/Main/ButtonsContainer/ScoreButton.hide();
	$Screen/Main/ButtonsContainer/OptionsButton.hide();
	$Screen/Main/ButtonsContainer/ExitButton.hide();
	$MenuMusic.stop();
	$GameMusic.play();
	gameStarted = true;
	add_life();
	emit_signal("start_game");
	
func _on_MessageTimer_gameOverTimeout():
	if !gameStarted:
		$Screen/Main/ButtonsContainer/StartButton.show();
		$Screen/Main/ButtonsContainer/ScoreButton.show();
		$Screen/Main/ButtonsContainer/ExitButton.show();
		$Screen/Main/ButtonsContainer/OptionsButton.show();

func _on_MessageTimer_timeout():
	if gameStarted:
		$Screen/Main/MessageLabel.hide();

func _on_ExitButton_pressed():
	get_tree().quit();

func _on_ScoreTimer_timeout():
	gameTimeSeconds += 1;
	if gameTimeSeconds == 60 :
		gameTimeMinutes += 1;
		gameTimeSeconds = 0;
	update_time(gameTimeMinutes, gameTimeSeconds);
