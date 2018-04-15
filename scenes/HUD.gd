extends CanvasLayer

signal start_game;

func show_message(text):
	$MessageLabel.text = text;
	$MessageLabel.show();
	$MessageTimer.start();

func show_game_over():
	show_message("KONIEC GRY!");
	yield($MessageTimer, "timeout");
	$StartButton.show();
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
	add_life();
	emit_signal("start_game");

func _on_MessageTimer_timeout():
	$MessageLabel.hide();
