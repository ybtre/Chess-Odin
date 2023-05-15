package fantasy_chess

import rl "vendor:raylib"

TEX_SPRITESHEET 	: rl.Texture2D

SRC_TILE_WHITE  				:: rl.Rectangle{ 35, 100, 34, 34 }
SRC_TILE_WHITE_HIGHLIGHTED  	:: rl.Rectangle{ 104, 99, 36, 36 }
SRC_TILE_WHITE_SELECTED			:: rl.Rectangle{ 176, 99, 36, 36 }
SRC_TILE_WHITE_MOVES			:: rl.Rectangle{ 35, 136, 36, 36 }
SRC_TILE_BLACK					:: rl.Rectangle{ 0, 100, 34, 34 }
SRC_TILE_BLACK_HIGHLIGHTED  	:: rl.Rectangle{ 69, 99, 36, 36 }
SRC_TILE_BLACK_SELECTED			:: rl.Rectangle{ 141, 99, 36, 36 }
SRC_TILE_BLACK_MOVES			:: rl.Rectangle{ 0, 136, 36, 36 }


SRC_WHITE_PAWN		:: rl.Rectangle{ 0, 48, 32, 48 }
SRC_WHITE_KNIGHT	:: rl.Rectangle{ 32, 48, 32, 48 }
SRC_WHITE_BISHOP	:: rl.Rectangle{ 64, 48, 32, 48 }
SRC_WHITE_ROOK		:: rl.Rectangle{ 96, 48, 32, 48 }
SRC_WHITE_QUEEN		:: rl.Rectangle{ 128, 48, 32, 48 }
SRC_WHITE_KING		:: rl.Rectangle{ 160, 48, 32, 48 }

SRC_BLACK_PAWN		:: rl.Rectangle{ 0, 0, 32, 48 }
SRC_BLACK_KNIGHT	:: rl.Rectangle{ 32, 0, 32, 48 }
SRC_BLACK_BISHOP	:: rl.Rectangle{ 64, 0, 32, 48 }
SRC_BLACK_ROOK		:: rl.Rectangle{ 96, 0, 32, 48 }
SRC_BLACK_QUEEN		:: rl.Rectangle{ 128, 0, 32, 48 }
SRC_BLACK_KING		:: rl.Rectangle{ 160, 0, 32, 48 }

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
