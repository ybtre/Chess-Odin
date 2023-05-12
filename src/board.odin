package fantasy_chess

import rl "vendor:raylib"
import "base"

board : Board
tile : Tile
TILE_SCALE_FACTOR :f32: 2

setup_board :: proc(){
	using rl

	for x in 0..<8 {
		for y in 0..<8 
		{
			board.tiles[x][y] = setup_tile(x, y)
		}
	}
}

setup_tile :: proc(X, Y: int) -> Tile {
	t: Tile
	
	t.id = (X + Y)
	
	t.pos = { SCREEN.x / 3.2 + f32((X * 68)), SCREEN.y / 6 + f32((Y * 68)) }	
	t.spr.SCALE_FACTOR = TILE_SCALE_FACTOR

	if X % 2 == 0 && Y % 2 == 1 || X % 2 == 1 && Y % 2 == 0	
	{
		t.spr.src = SRC_TILE_BLACK
	}
	else if X % 2 == 0 && Y % 2 == 0 || X % 2 == 1 && Y % 2 == 1 
	{
		t.spr.src = SRC_TILE_WHITE
	}
	t.spr.dest = { t.pos.x, t.pos.y, t.spr.src.width * t.spr.SCALE_FACTOR, t.spr.src.height * t.spr.SCALE_FACTOR}
	t.spr.center = { t.spr.src.width * t.spr.SCALE_FACTOR / 2, t.spr.src.height * t.spr.SCALE_FACTOR / 2 }


	t.hitbox = { t.pos.x - t.spr.src.width * t.spr.SCALE_FACTOR / 2, t.pos.y - t.spr.src.height * t.spr.SCALE_FACTOR / 2, t.spr.dest.width, t.spr.dest.height }
	t.state = .idle

	return t
}

update_board :: proc() {
	
}

render_board :: proc() {
	using rl

	// tile.pos.x += 1
	// on_tile_pos_update(&tile)
			
	DrawLine(i32(SCREEN.x) /2, 0, i32(SCREEN.x) /2, i32(SCREEN.y), RED)
	DrawLine(0, i32(SCREEN.y) /2, i32(SCREEN.x), i32(SCREEN.y) /2, RED)

	for x in 0..<8 {
		for y in 0..<8 
		{
			board.tiles[x][y] = setup_tile(x, y)
			DrawTexturePro(
				TEX_SPRITESHEET, 
				board.tiles[x][y].spr.src, 
				board.tiles[x][y].spr.dest, 
				board.tiles[x][y].spr.center, 
				// f32(GetTime()) * 90,
				0, 
				WHITE)

			// DrawRectangleLinesEx(board.tiles[x][y].hitbox, 4, RED)
		}
	}
}

on_tile_pos_update :: proc(TILE: ^Tile) {
	update_tile_sprite_dest(TILE)
	update_tile_hitbox_pos(TILE)
}

update_tile_hitbox_pos :: proc(TILE: ^Tile) {
    TILE.hitbox = { TILE.pos.x - TILE.spr.src.width * TILE.spr.SCALE_FACTOR / 2, TILE.pos.y - TILE.spr.src.height * TILE.spr.SCALE_FACTOR / 2, TILE.spr.dest.width, TILE.spr.dest.height }
}

update_tile_sprite_dest :: proc(TILE: ^Tile) {
    TILE.spr.dest = { TILE.pos.x, TILE.pos.y, TILE.spr.dest.width, TILE.spr.dest.height }
}