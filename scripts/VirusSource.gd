extends Area2D

# INCLUDES
const Virus = preload("res://scenes/Virus.tscn");

# EXPORTS
export var startTime : float = 1.0;

# SUB-NODES
var nGlobal : Node;
var nSpr : Sprite;
var nGenTimer : Timer;
var nNeighborArea : Area2D;

# VARIABLES
var dim : Vector2;
var genTime : float = 1.0;

# FUNCTION OVERRIDING
func _ready() -> void:
	nGlobal = get_node("/root/Global");
	nSpr = get_node("Sprite");
	nGenTimer = get_node("GenTimer");
	nNeighborArea = get_node("NeighborArea");
	
	dim = Vector2(nSpr.get_rect().size);
	
	nGenTimer.set_one_shot(true);
	nGenTimer.start(startTime);

# SIGNAL HANDLING
func _on_GenTimer_timeout() -> void:
	nSpr.set_frame((nSpr.get_frame() + 1) % nSpr.get_hframes());
	
	if (nSpr.get_frame() == 0):
		var neighbors : Array = nNeighborArea.get_overlapping_areas();
		for i in range(neighbors.size()):
			if neighbors[i].has_method("virusUpdate"):
				neighbors[i].virusUpdate();
		
		if (!Global.virus_limit_reached()):
			spawn_virus(neighbors);
	
	nGenTimer.start(genTime);

# FUNCTIONS
func spawn_virus(neighbors : Array) -> void:
	var neighPoses : Array = [];
	var spawnPoses : Array = [];
	var edgePosX1 : float = get_global_position().x - Global.VIRUS_GRID;
	var edgePosX2 : float = get_global_position().x + dim.x;
	var edgePosY1 : float = get_global_position().y - Global.VIRUS_GRID;
	var edgePosY2 : float = get_global_position().y + dim.y;
	
	for i in range(neighbors.size()):
		neighPoses.append(neighbors[i].get_global_position());
	
	for x in range(edgePosX1, edgePosX2 + Global.VIRUS_GRID, Global.VIRUS_GRID):
		for y in range(edgePosY1, edgePosY2 + Global.VIRUS_GRID, Global.VIRUS_GRID):
			if (x >= 0 && x < Global.WORLD_DIM.x && y >= 0 && y < Global.WORLD_DIM.y):
				if (x == edgePosX1 || x == edgePosX2 || y == edgePosY1 || y == edgePosY2):
					if (!neighPoses.has(Vector2(x, y))):
						spawnPoses.append(Vector2(x, y));
	
	if (!spawnPoses.empty()):
		get_parent().create_virus(spawnPoses[randi() % spawnPoses.size()]);
