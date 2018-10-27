extends Area2D

signal hit;
signal collected;
signal update_screensize(window_size);

export (int) var SPEED;
export (int) var HEALTH;
export (int) var MAXHEALTH;
var velocity = Vector2();
var screensize;
var lastAnimation = 'idle';

func _ready():
	hide();
	update_screensize();
	$move_idle.connect('timeout', self, '_on_timer_timeout');
	$move.play();
	
func update_screensize(window_size = get_viewport_rect().size):
	screensize = window_size;

func _on_timer_timeout():
	lastAnimation = 'idle';
	$move.animation = 'idle';
	$move.play();

func _process(delta):
	velocity = Vector2();
	if Input.is_action_pressed('ui_up'):
		lastAnimation = 'up';
		velocity.y -= 1;
	if Input.is_action_pressed('ui_down'):
		lastAnimation = 'down';
		velocity.y += 1;
	if Input.is_action_pressed('ui_left'):
		lastAnimation = 'left';
		velocity.x -= 1;
	if Input.is_action_pressed('ui_right'):
		lastAnimation = 'right';
		velocity.x += 1;
		
	if lastAnimation != 'idle':
		$move.animation = lastAnimation;
	
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


func _on_Player_body_entered( body ):
	var MobRegEx = RegEx.new();
	MobRegEx.compile('Mob');
	
	var CollectibleRegEx = RegEx.new();
	CollectibleRegEx.compile('Collectible');
	
	if MobRegEx.search(body.name):
		body.queue_free();
		emit_signal('hit');
	elif CollectibleRegEx.search(body.name):
		body.queue_free();
		emit_signal('collected');

func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;
