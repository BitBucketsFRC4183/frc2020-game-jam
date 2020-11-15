extends Reference
class_name PlayerMessage

# simple message class for sending/recieving messages
var num := 1
var message := ""

func _init(num: int, message: String):
	self.num = num
	self.message = message

func to_dict():
	return {
		"num": num,
		"message": message
	}
