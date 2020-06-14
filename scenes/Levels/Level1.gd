extends Node2D

const Virus = preload("res://scenes/Virus.tscn");

func _ready():
	randomize();

func create_virus(pos : Vector2) -> void:
	Global.virus_count += 1;
	print(Global.virus_count);
	var virInst = Virus.instance();
	virInst.set_global_position(pos);
	call_deferred("add_child", virInst);
