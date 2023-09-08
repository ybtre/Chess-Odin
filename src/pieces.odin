package fantasy_chess

import rl "vendor:raylib"
import "core:strconv"
import "core:strings"
import "core:fmt"
import "core:unicode"
import "base"

pieces : [32]Piece = {}

setup_start_pieces_fen :: proc()
{	
	using base
	using fmt
	
    code := strings.split(FEN_code, " ")
	println(code)
	pieces_code := strings.split(code[0], "/")

	total_counter := 0
	rank_counter := 7
	file_counter := 0
	for pc in pieces_code
	{	
		for piece in pc
		{
			if total_counter <= 32
			{
				if piece  == 'r'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]

					p.data.type = .ROOK
					p.visuals.color = .BLACK
					p.visuals.spr.src = SRC_BLACK_ROOK
					setup_piece_common(p, t)
					total_counter += 1
				}
				if piece == 'R'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]

					p.data.type = .ROOK
					p.visuals.color = .WHITE
					p.visuals.spr.src = SRC_WHITE_ROOK
					setup_piece_common(p, t)
					total_counter += 1
				}
				if piece == 'n'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]

					p.data.type = .KNIGHT
					p.visuals.color = .BLACK
					p.visuals.spr.src = SRC_BLACK_KNIGHT
					setup_piece_common(p, t)
					total_counter += 1
				}
				if piece == 'N'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]

					p.data.type = .KNIGHT
					p.visuals.color = .WHITE
					p.visuals.spr.src = SRC_WHITE_KNIGHT
					setup_piece_common(p, t)
					total_counter += 1
				}
				if piece == 'b'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .BISHOP
					p.visuals.color = .BLACK
					p.visuals.spr.src = SRC_BLACK_BISHOP
					setup_piece_common(p, t)
				}
				if piece == 'B'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .BISHOP
					p.visuals.color = .WHITE
					p.visuals.spr.src = SRC_WHITE_BISHOP
					setup_piece_common(p, t)
				}
				if piece == 'q'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .QUEEN
					p.visuals.color = .BLACK
					p.visuals.spr.src = SRC_BLACK_QUEEN				
					setup_piece_common(p, t)
				}
				if piece == 'Q'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .QUEEN
					p.visuals.color = .WHITE
					p.visuals.spr.src = SRC_WHITE_QUEEN
					setup_piece_common(p, t)
				}
				if piece == 'k'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .KING
					p.visuals.color = .BLACK
					p.visuals.spr.src = SRC_BLACK_KING				
					setup_piece_common(p, t)
				}
				if piece == 'K'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .KING
					p.visuals.color = .WHITE
					p.visuals.spr.src = SRC_WHITE_KING
					setup_piece_common(p, t)
				}
				if piece == 'p'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .PAWN
					p.visuals.color = .BLACK
					p.visuals.spr.src = SRC_BLACK_PAWN
					setup_piece_common(p, t)
				}
				if piece == 'P'
				{
					p := &pieces[total_counter]
					t := &board.tiles[file_counter][rank_counter]
					total_counter += 1

					p.data.type = .PAWN
					p.visuals.color = .WHITE
					p.visuals.spr.src = SRC_WHITE_PAWN
					setup_piece_common(p, t)
				}
			
				if unicode.is_number(piece)
				{
					// println("NUMBER")
					// println(piece)
					file_counter += strconv.atoi(rtoa(piece))
				}
				else {
					file_counter += 1
				}
			
				if file_counter > 7
				{
					rank_counter -= 1
				}

				if file_counter >= 8
				{
					file_counter = 0
				}
				if rank_counter >= 8
				{
					rank_counter = 0
				}
			}
			else if total_counter == 33
			{
				if piece == 'b'	
				{
					is_black_turn = false
				}
				if piece == 'w'
				{
					is_black_turn = true
				}
			}
		}		
	}	
}
 
setup_piece_common :: proc(P: ^Piece, T: ^Tile) 
{
	// P.id = T.id
	P.visuals.pos = T.visuals.pos
	P.visuals.spr.SCALE_FACTOR = TILE_SCALE_FACTOR

	P.visuals.spr.dest = { P.visuals.pos.x, P.visuals.pos.y - 20, P.visuals.spr.src.width * P.visuals.spr.SCALE_FACTOR, P.visuals.spr.src.height * P.visuals.spr.SCALE_FACTOR }
	P.visuals.spr.center = { P.visuals.spr.src.width * P.visuals.spr.SCALE_FACTOR / 2, P.visuals.spr.src.height * P.visuals.spr.SCALE_FACTOR / 2 }	

	temp_buf : [6]byte
	temp_id : [2]string = { piece_type_to_str(P.data.type), strconv.itoa(temp_buf[:], int(rl.GetRandomValue(0, 32767)))}
	
	P.data.id = strings.join(temp_id[:], "-")	

	P.data.has_moved = false
	P.data.has_calculated_moves = false

	P.data.coords = T.data.tile_coords
	
	T.data.piece = P 
}

piece_type_to_str :: proc(TYPE : Piece_Type) -> string
{
	result := ""

	switch TYPE
	{
		case .PAWN:
			result = "p"
		break
		case .ROOK:
			result = "r"
		break
		case .KNIGHT:
			result = "n"
		break
		case .BISHOP:
			result = "b"
		break
		case .QUEEN:
			result = "q"
		break
		case .KING:
			result = "k"
		break

		case .NONE:
		break
	}
	
	return result
}

move_piece :: proc(PIECE : ^Piece, NEW_T, OLD_T: ^Tile)
{
	if NEW_T.data.piece != nil
	{
		fmt.println("TAKEN")
	}
	else if NEW_T.data.piece == nil
	{
		fmt.println("FREE")
		
		OLD_T.data.piece = nil
		setup_piece_common(PIECE, NEW_T)
		PIECE.data.has_moved = true
	}
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
	
	for i := 0; i < 32; i += 1
	{
		DrawTexturePro(
			TEX_SPRITESHEET,
			pieces[i].visuals.spr.src,
			pieces[i].visuals.spr.dest,
			pieces[i].visuals.spr.center,
			0,
			WHITE)
	}
}
