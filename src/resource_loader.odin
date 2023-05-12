package fantasy_chess

import rl "vendor:raylib"

TEX_SPRITESHEET 	: rl.Texture2D

SRC_TILE_WHITE  	:: rl.Rectangle{ 35, 100, 34, 34 }
SRC_TILE_BLACK		:: rl.Rectangle{ 0, 100, 34, 34 }

SRC_WHITE_PAWN		:: rl.Rectangle
SRC_WHITE_KNIGHT	:: rl.Rectangle
SRC_WHITE_BISHIP	:: rl.Rectangle
SRC_WHITE_ROOK		:: rl.Rectangle
SRC_WHITE_QUEEN		:: rl.Rectangle
SRC_WHITE_KING		:: rl.Rectangle

SRC_BLACK_PAWN		:: rl.Rectangle
SRC_BLACK_KNIGHT	:: rl.Rectangle
SRC_BLACK_BISHIP	:: rl.Rectangle
SRC_BLACK_ROOK		:: rl.Rectangle
SRC_BLACK_QUEEN		:: rl.Rectangle
SRC_BLACK_KING		:: rl.Rectangle

load_all_textures :: proc() {
	using rl

	TEX_SPRITESHEET = rl.LoadTexture("../assets/chess_spritesheet.png")
}

setup_sprite_sources :: proc() {
}

unload_all_textures :: proc() {
	using rl

	UnloadTexture(TEX_SPRITESHEET)
}
