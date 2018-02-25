extends Area2D

export (int) var SPEED;
var velocity = Vector2();
var screensize;

func _ready():
	screensize = get_viewport_rect().size;
	$move_idle.connect('timeout', self, '_on_timer_timeout');
	$move.play();
	
func _on_timer_timeout():
	$move.animation = 'idle';
	$move.play();
	
func _process(delta):
	velocity = Vector2();
	if Input.is_action_pressed('ui_up'):
		$move.animation = 'up';
		velocity.y -= 1;
	if Input.is_action_pressed('ui_down'):
		$move.animation = 'down';
		velocity.y += 1;
	if Input.is_action_pressed('ui_left'):
		$move.animation = 'left';
		velocity.x -= 1;
	if Input.is_action_pressed('ui_right'):
		$move.animation = 'right';
		velocity.x += 1;
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED;
		$move.play();
		$move_idle.stop();
	else:
		if $move.animation != 'idle' && $move.is_playing():
			$move.stop();
			$move.frame = 0;
			
		if $move.animation != 'idle' && $move_idle.is_stopped():
			$move_idle.start();
		
	position += velocity * delta;
	position.x = clamp(position.x, 0, screensize.x);
	position.y = clamp(position.y, 0, screensize.y);
