package fantasy_chess 

import rl "vendor:raylib"

Sprite :: struct {
    src              : rl.Rectangle,
    dest             : rl.Rectangle,
    center           : rl.Vector2,
    SCALE_FACTOR     : f32,
}

Board :: struct {
    tiles: [8][8]Tile,
}

Tile :: struct {
    data           : Tile_Data,
    visuals        : Tile_Visuals,
}

Tile_Data :: struct {
    id             : string,
    board_coords   : string,
    tile_coords    : [2]int,
    state          : Tile_State,
    piece          : ^Piece,
}

Tile_Visuals :: struct {
    spr            : Sprite,
    pos            : rl.Vector2,
    hitbox         : rl.Rectangle,
    color          : Faction,
}

Tile_State :: enum {
    IDLE,
    HIGHLIGHTED,
    SELECTED,
    AVAILABLE_MOVES,
}

Piece :: struct {
    data        : Piece_Data,
    visuals     : Piece_Visuals,
}

Piece_Data :: struct {
    id                    : string,
    has_moved             : bool,
    has_calculated_moves  : bool,
    coords                : [2]int,
    type                  : Piece_Type,
}

Piece_Visuals  :: struct {
    spr         : Sprite,
    pos         : rl.Vector2,
    color       : Faction,
}

Piece_Type :: enum {
    PAWN,
    ROOK,
    KNIGHT,
    BISHOP,
    QUEEN,
    KING,
    NONE,
}

Faction :: enum {
    BLACK = 0,
    WHITE = 1,
    NONE = 2,
}

Cursor :: struct {
    spr: Sprite,
}

Button :: struct {
    rec               : rl.Rectangle,
    spr               : Sprite,
    is_highlighted    : bool,
    is_pressed        : bool,
}

Background :: struct {
    spr: Sprite,
}
