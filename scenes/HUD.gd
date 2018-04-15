extends CanvasLayer

signal start_game;
var gameStarted = false;

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

func update_score(score):
	$ScoreLabel.text = "Punkty: " + str(score);
	
func add_life():
	$LifeBar.value = $LifeBar.value + $LifeBar.step;
	
func sub_life():
	$LifeBar.value = $LifeBar.value - $LifeBar.step;

func _on_StartButton_pressed():
	$StartButton.hide();
	gameStarted = true;
	add_life();
	emit_signal("start_game");
	
func _on_MessageTimer_gameOverTimeout():
	if !gameStarted:
		$StartButton.show();

func _on_MessageTimer_timeout():
	if gameStarted:
		$MessageLabel.hide();
