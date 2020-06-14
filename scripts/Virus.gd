extends Area2D

# CONSTANTS
const UPDATE_TIME : float = 0.1;
const COOLDOWN_TIME : float = 0.4;

# SUB-NODES
var nSpr : Sprite;
var nUpdateTimer : Timer;
var nCooldownTimer : Timer;
var nNeighborArea : Area2D;

# VARIABLES
var dim : Vector2;
var updating : bool = true;

# FUNCTION OVERRIDING
func _ready() -> void:
	nSpr = get_node("Sprite");
	nUpdateTimer = get_node("UpdateTimer");
	nCooldownTimer = get_node("CooldownTimer");
	nNeighborArea = get_node("NeighborArea");
	
	dim = Vector2(nSpr.get_rect().size);
	
	nSpr.set_frame(2);
	nUpdateTimer.set_one_shot(true);
	nCooldownTimer.set_one_shot(true);
	nCooldownTimer.start(COOLDOWN_TIME);

# SIGNAL HANDLING
func _on_updateTimer_timeout():
	nSpr.set_frame(1);
	
	var neighbors : Array = nNeighborArea.get_overlapping_areas();
	for i in range(neighbors.size()):
		if neighbors[i].has_method("virusUpdate"):
			neighbors[i].virusUpdate();
	
	if (!Global.virus_limit_reached()):
		spawn_virus(neighbors);
	
	nCooldownTimer.start(COOLDOWN_TIME);

func _on_cooldownTimer_timeout():
	updating = false;

# FUNCTIONS
func virusUpdate() -> void:
	if (!updating):
		updating = true;
		nSpr.set_frame(0);
		nUpdateTimer.start(UPDATE_TIME);

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
