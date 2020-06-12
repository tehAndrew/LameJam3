extends Area2D

# SUB-NODES
var nSpr : Sprite;
var nGenTimer : Timer;
var nNeighborArea : Area2D;

# VARIABLES
var genTime : float = 1.0;

# FUNCTION OVERRIDING
func _ready():
	nSpr = get_node("Sprite");
	nGenTimer = get_node("GenTimer");
	nNeighborArea = get_node("NeighborArea");
	
	nGenTimer.set_one_shot(true);
	nGenTimer.start(genTime);

# SIGNAL HANDLING
func _on_GenTimer_timeout():
	var neighbors : Array = nNeighborArea.get_overlapping_areas();
	for i in range(neighbors.size()):
		if neighbors[i].has_method("virusUpdate"):
			neighbors[i].virusUpdate();
	
	nSpr.set_frame((nSpr.get_frame() + 1) % nSpr.get_hframes());
	nGenTimer.start(genTime);

# FUNCTIONS
