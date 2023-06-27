@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("VoiceGen","Node",preload("voice_gen.gd"), preload("voice_gen.png"))


func _exit_tree():
	remove_custom_type("VoiceGen")
