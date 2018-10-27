extends CanvasLayer

signal start_game;
signal init_screen;
signal sound_volume_changed;

var gameStarted = false;
var playMusic = true;
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
	if playMusic:
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
	
	if playMusic:
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


func _on_OptionsButton_pressed():
	$Screen.visible = false;
	$OptionsMenu.visible = true;


func _on_OptionsMenu_init_screen():
	emit_signal('init_screen');


func _on_OptionsMenu_visibility_changed():
	if !$OptionsMenu.visible:
		$Screen.visible = true;


func sound_volume_changed(volume):
	emit_signal('sound_volume_changed', volume);

func music_volume_changed(volume):
	if volume == null:
		$MenuMusic.stop();
		playMusic = false;
	else:
		playMusic = true;
		
		if !$MenuMusic.playing:
			$MenuMusic.play();
			
		$MenuMusic.volume_db = volume;
		$GameMusic.volume_db = volume;
