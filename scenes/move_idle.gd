extends Timer

var moveNode;

func _ready():
	moveNode = get_node('move');
	
func _timeout():
	print('timeout!');


