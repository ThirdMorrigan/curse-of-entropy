extends Area3D

signal newRoomEntered


func changeRoom(roomData):
	newRoomEntered.emit(roomData)
