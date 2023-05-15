package fantasy_chess

import rl "vendor:raylib"
import "base"

update_check_mouse_collision :: proc() 
{
	using rl
	
	for x in 0..<8 {
		for y in 0..<8
		{
			if CheckCollisionPointRec(GetMousePosition(), board.tiles[x][y].hitbox)
			{
				board.tiles[x][y].state = .highlighted
				DrawText(TextFormat("HOVERING TILE: %i, %i", x, y), 20, 70, 30, GRAY)
			}
			else 
			{
				board.tiles[x][y].state = .idle
			}	
		}
	}
}
