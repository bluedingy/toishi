# input/i_input_reader.gd
class_name InputReaderInterface
extends RefCounted

## Shared interface. Both local and network readers must implement these.

var buffer: InputBuffer

func poll() -> void:
	pass  # override in subclasses

func get_move_direction() -> int:
	return 0
	
func get_look_direction() -> Vector3:
	return Vector3(0,0,0)
	
