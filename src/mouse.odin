package fantasy_chess

import rl "vendor:raylib"
import "base"
import "core:fmt"

mouse_get_hover_tile :: proc() -> ^Tile
{
	using rl
	
	for x in 0..<8 {
		for y in 0..<8
		{	
			t := &board.tiles[x][y]
			
			if CheckCollisionPointRec(GetMousePosition(), t.visuals.hitbox)
			{
				return t	
			}
		}
	}

	return nil
}

mouse_get_selected_tile :: proc() -> ^Tile 
{
	using rl
	
	for x in 0..<8 {
		for y in 0..<8
		{	
			t := &board.tiles[x][y]
			
			if CheckCollisionPointRec(GetMousePosition(), t.visuals.hitbox)
			{
				if IsMouseButtonPressed(MouseButton.LEFT)
				{	
					return t	
				}
			}
		}
	}

	return nil
}

update_check_mouse_collision :: proc() 
{
	using rl
	
	for x in 0..<8 {
		for y in 0..<8
		{	
			t := &board.tiles[x][y]
			
			if CheckCollisionPointRec(GetMousePosition(), t.visuals.hitbox)
			{
				if t.data.state != .SELECTED && t.data.state != .AVAILABLE_MOVES 
				{ 
					t.data.state = .HIGHLIGHTED
				}
				
				DrawText(TextFormat("HOVERING TILE: %i, %i", x, y), 20, 70, 30, GRAY)
				DrawText(TextFormat("TILE ID: %s", t.data.id), 20, 100, 30, GRAY)
				DrawText(TextFormat("TILE COORDS: %s", t.data.board_coords), 20, 130, 30, GRAY)
				DrawText(TextFormat("PIECE ID: %s", t.data.piece.data.id), 20, 160, 30, GRAY)
				DrawText(TextFormat("PIECE: %s", t.data.piece), 20, 190, 30, GRAY)

				if IsMouseButtonPressed(MouseButton.LEFT)
				{	
					if selected_tile != nil
					{ 
						if selected_tile.data.piece != nil
						{
							if t.data.state == .AVAILABLE_MOVES
							{
								fmt.println("MOVE")
								move_piece(selected_tile.data.piece, t, selected_tile)
							}
						}
						else {
							selected_tile.data.state = .IDLE
							selected_tile = nil 
						}
						
						clear(&possible_moves)
					}
					
					t.data.state = .SELECTED
					selected_tile = t
				}
			}
			else 
			{	
				if t.data.state == .HIGHLIGHTED
				{
					t.data.state = .IDLE
				}
			}	
		}
	}
}
