extends Node

const WORLD_DIM : Vector2 = Vector2(512, 480); # Dimensions of the world
const VIRUS_GRID : int = 32;
const MAX_VIRUS_COUNT : int = 1000;

var virus_count : int = 0;

func virus_limit_reached() -> bool:
	return virus_count >= MAX_VIRUS_COUNT;
