extends Area2D

const UPDATE_TIME : float = 0.03;
const COOLDOWN_TIME : float = 0.2;

var nSpr : Sprite;
var nUpdateTimer : Timer;
var nCooldownTimer : Timer;
var nNeighborArea : Area2D;

var updating : bool = false;

func _ready() -> void:
	nSpr = get_node("Sprite");
	nUpdateTimer = get_node("UpdateTimer");
	nCooldownTimer = get_node("CooldownTimer");
	nNeighborArea = get_node("NeighborArea");
	
	nUpdateTimer.set_one_shot(true);
	nCooldownTimer.set_one_shot(true);

func _on_updateTimer_timeout():
	nSpr.set_frame(1);
	
	var neighbors : Array = nNeighborArea.get_overlapping_areas();
	for i in range(neighbors.size()):
		if neighbors[i].has_method("virusUpdate"):
			neighbors[i].virusUpdate();
	
	nCooldownTimer.start(COOLDOWN_TIME);

func _on_cooldownTimer_timeout():
	updating = false;

func virusUpdate() -> void:
	if (!updating):
		updating = true;
		nSpr.set_frame(2);
		nUpdateTimer.start(UPDATE_TIME);
