class_name test extends Node2D



func _ready() -> void:
	
	var a = test.new()
	a.stest()


func ftest() -> void:
	
	print("wat")


class t extends test: 
	
	func stest() -> void:
		super.ftest()
	
