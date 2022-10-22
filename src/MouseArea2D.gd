extends Area2D

class_name MouseArea2D

onready var parent = get_parent()

func _ready() -> void:
	connect("input_event", self, "_mouse_event")


func _mouse_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	 if event is InputEventMouseMotion:
		 pass # We could do something with mouseovers here

	 if event is InputEventMouseButton and event.is_action_pressed("mouse_left"):
		 parent.clicked()
