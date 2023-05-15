package fantasy_chess

import rl "vendor:raylib"
import "core:strconv"
import "core:strings"

pieces : [32]Piece = {}

setup_start_pieces :: proc()
{
	for i in 0..<32
	{
		{ // Setup White
			if i >= 0 && i <16
			{
				if i == 0 
				{
					p := &pieces[i]
					t := &board.tiles[0][0]
					
					p.type = .ROOK
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_ROOK
					setup_piece_common(p, t)
				}
				else if i == 7
				{
					p := &pieces[i]
					t := &board.tiles[7][0]
					
					p.type = .ROOK
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_ROOK
					setup_piece_common(p, t)
				}
				else if i == 1 
				{
					p := &pieces[i]
					t := &board.tiles[1][0]
					
					p.type = .KNIGHT
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_KNIGHT
					setup_piece_common(p, t)
				}
				else if i == 6 
				{
					p := &pieces[i]
					t := &board.tiles[6][0]
					
					p.type = .KNIGHT
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_KNIGHT
					setup_piece_common(p, t)
				}
				else if i == 2 
				{
					p := &pieces[i]
					t := &board.tiles[2][0]
					
					p.type = .BISHOP
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_BISHOP
					setup_piece_common(p, t)
				}
				else if i == 5
				{
					p := &pieces[i]
					t := &board.tiles[5][0]
					
					p.type = .BISHOP
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_BISHOP
					setup_piece_common(p, t)
				}
				else if i == 3 
				{
					p := &pieces[i]
					t := &board.tiles[3][0]
					
					p.type = .QUEEN
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_QUEEN
					setup_piece_common(p, t)
				}
				else if i == 4
				{
					p := &pieces[i]
					t := &board.tiles[4][0]
					
					p.type = .KING
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_KING
					setup_piece_common(p, t)
				}
				else if i > 7
				{
					p := &pieces[i]
					t := &board.tiles[i-8][1] // start ordering pawns from 0 to 8
					
					p.type = .PAWN
					p.e_color = .WHITE
					p.spr.src = SRC_WHITE_PAWN
					setup_piece_common(p, t)
					
				}
			}
		}
		{ // Setup Black
			if i >= 16 && i < 32
			{
				if i == 16
				{
					p := &pieces[i]
					t := &board.tiles[0][7]
					
					p.type = .ROOK
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_ROOK
					setup_piece_common(p, t)
				}
				else if i == 23
				{
					p := &pieces[i]
					t := &board.tiles[7][7]
					
					p.type = .ROOK
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_ROOK
					setup_piece_common(p, t)
				}
				else if i == 17 
				{
					p := &pieces[i]
					t := &board.tiles[1][7]
					
					p.type = .KNIGHT
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_KNIGHT
					setup_piece_common(p, t)
				}
				else if i == 22
				{
					p := &pieces[i]
					t := &board.tiles[6][7]
					
					p.type = .KNIGHT
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_KNIGHT
					setup_piece_common(p, t)
				}
				else if i == 18 
				{
					p := &pieces[i]
					t := &board.tiles[2][7]
					
					p.type = .BISHOP
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_BISHOP
					setup_piece_common(p, t)
				}
				else if i == 21
				{
					p := &pieces[i]
					t := &board.tiles[5][7]
					
					p.type = .BISHOP
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_BISHOP
					setup_piece_common(p, t)
				}
				else if i == 20 
				{
					p := &pieces[i]
					t := &board.tiles[3][7]
					
					p.type = .QUEEN
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_QUEEN
					setup_piece_common(p, t)
				}
				else if i == 19
				{
					p := &pieces[i]
					t := &board.tiles[4][7]
					
					p.type = .KING
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_KING
					setup_piece_common(p, t)
				}
				else if i > 23
				{
					p := &pieces[i]
					t := &board.tiles[i-24][6] // start ordering pawns from 0 to 8
					
					p.type = .PAWN
					p.e_color = .BLACK
					p.spr.src = SRC_BLACK_PAWN
					setup_piece_common(p, t)
					
				}		
			}
		}
	}
}

setup_piece_common :: proc(P: ^Piece, T: ^Tile) 
{
	// P.id = T.id
	P.pos = T.pos
	P.spr.SCALE_FACTOR = TILE_SCALE_FACTOR

	P.spr.dest = { P.pos.x, P.pos.y - 20, P.spr.src.width * P.spr.SCALE_FACTOR, P.spr.src.height * P.spr.SCALE_FACTOR }
	P.spr.center = { P.spr.src.width * P.spr.SCALE_FACTOR / 2, P.spr.src.height * P.spr.SCALE_FACTOR / 2 }	

	temp_buf : [6]byte
	temp_id : [2]string = { "P", strconv.itoa(temp_buf[:], int(rl.GetRandomValue(0, 32767)))}
	
	P.id = strings.join(temp_id[:], "-")	
	T.piece_on_tile = P 
}

update_pieces :: proc() 
{
	for piece in pieces 
	{
		
	}
}

render_pieces :: proc() 
{
	using rl
	
	for i := 32; i > 0; i -= 1
	{
		DrawTexturePro(
			TEX_SPRITESHEET,
			pieces[i-1].spr.src,
			pieces[i-1].spr.dest,
			pieces[i-1].spr.center,
			0,
			WHITE)
	}
}
