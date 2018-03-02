extends CanvasLayer

signal start_game;

func show_message(text):
	print('show message run');
	$MessageLabel.text = text;
	$MessageLabel.show();
	$MessageTimer.start();

func show_game_over():
	show_message("KONIEC GRY!");
	yield($MessageTimer, "timeout");
	$StartButton.show();
	$MessageLabel.text = "PRZEGRALES!\nZAGRAJ PONOWNIE!";
	$MessageLabel.show();

func update_score(score):
	$ScoreLabel.text = "Punkty: " + str(score);

func _on_StartButton_pressed():
	print('preese');
	$StartButton.hide();
	emit_signal("start_game");

func _on_MessageTimer_timeout():
	$MessageLabel.hide();
