extends MarginContainer

signal init_screen;
signal sound_volume_changed(volume);
signal music_volume_changed(volume);
const RES_1024 = Vector2(1024, 768);
const RES_800 = Vector2(800, 600);
const RES_640 = Vector2(640, 480);

const RES_1024_ID = 3;
const RES_800_ID = 2;
const RES_640_ID = 1;

var volumeSound = 10;
var volumeMusic = 0;
var selectedRes = RES_800;

func _ready():
	$VBoxContainer/GridContainer/SoundSlider.value = volumeSound;
	$VBoxContainer/GridContainer/MusicSlider.value = volumeMusic;
	
	var currentRes = OS.get_window_size();
	$VBoxContainer/GridContainer/ResolutionPopup.text = String(currentRes[0]) + "x" + String(currentRes[1]);
	var resPopup = get_node('VBoxContainer/GridContainer/ResolutionPopup').get_popup();
	resPopup.add_item("1024x768", RES_1024_ID);
	resPopup.add_item("800x600", RES_800_ID);
	resPopup.add_item("640x480", RES_640_ID);
	resPopup.connect('id_pressed', self, '_on_resolution_select');
	pass

func _on_resolution_select(id):
	var resMenu = get_node('VBoxContainer/GridContainer/ResolutionPopup');
	resMenu.text = resMenu.get_popup().get_item_text(
		resMenu.get_popup().get_item_index(id)
	);
	
	match id:
		RES_1024_ID:
			selectedRes = RES_1024;
		RES_800_ID:
			selectedRes = RES_800;
		RES_640_ID:
			selectedRes = RES_640;
	
	OS.window_size = selectedRes;
	
	if OS.window_fullscreen:
		OS.window_fullscreen = false;
		OS.window_fullscreen = true;
		
	emit_signal('init_screen');


func _on_SaveButton_pressed():
	self.visible = false;


func _on_SoundSlider_value_changed(value):
	volumeSound = null if value == $VBoxContainer/GridContainer/SoundSlider.min_value else value;
	emit_signal('sound_volume_changed', volumeSound);


func _on_MusicSlider_value_changed(value):
	volumeMusic = null if value == $VBoxContainer/GridContainer/MusicSlider.min_value else value;
	emit_signal('music_volume_changed', volumeMusic);


func _on_FullscreenCheck_pressed():
	OS.window_fullscreen = !OS.window_fullscreen;
	
	if !OS.window_fullscreen:
		OS.window_size = selectedRes;
		
	emit_signal('init_screen');
