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
			if total_counter > 32
			{
				println("OVER 32")
				return
			}

			if piece  == 'r'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]

				p.type = .ROOK
				p.e_color = .BLACK
				p.spr.src = SRC_BLACK_ROOK
				setup_piece_common(p, t)
				total_counter += 1
			}
			if piece == 'R'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]

				p.type = .ROOK
				p.e_color = .WHITE
				p.spr.src = SRC_WHITE_ROOK
				setup_piece_common(p, t)
				total_counter += 1
			}
			if piece == 'n'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]

				p.type = .KNIGHT
				p.e_color = .BLACK
				p.spr.src = SRC_BLACK_KNIGHT
				setup_piece_common(p, t)
				total_counter += 1
			}
			if piece == 'N'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]

				p.type = .KNIGHT
				p.e_color = .WHITE
				p.spr.src = SRC_WHITE_KNIGHT
				setup_piece_common(p, t)
				total_counter += 1
			}
			if piece == 'b'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .BISHOP
				p.e_color = .BLACK
				p.spr.src = SRC_BLACK_BISHOP
				setup_piece_common(p, t)
			}
			if piece == 'B'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .BISHOP
				p.e_color = .WHITE
				p.spr.src = SRC_WHITE_BISHOP
				setup_piece_common(p, t)
			}
			if piece == 'q'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .QUEEN
				p.e_color = .BLACK
				p.spr.src = SRC_BLACK_QUEEN				
				setup_piece_common(p, t)
			}
			if piece == 'Q'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .QUEEN
				p.e_color = .WHITE
				p.spr.src = SRC_WHITE_QUEEN
				setup_piece_common(p, t)
			}
			if piece == 'k'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .KING
				p.e_color = .BLACK
				p.spr.src = SRC_BLACK_KING				
				setup_piece_common(p, t)
			}
			if piece == 'K'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .KING
				p.e_color = .WHITE
				p.spr.src = SRC_WHITE_KING
				setup_piece_common(p, t)
			}
			if piece == 'p'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .PAWN
				p.e_color = .BLACK
				p.spr.src = SRC_BLACK_PAWN
				setup_piece_common(p, t)
			}
			if piece == 'P'
			{
				p := &pieces[total_counter]
				t := &board.tiles[file_counter][rank_counter]
				total_counter += 1

				p.type = .PAWN
				p.e_color = .WHITE
				p.spr.src = SRC_WHITE_PAWN
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
	temp_id : [2]string = { piece_type_to_str(P.type), strconv.itoa(temp_buf[:], int(rl.GetRandomValue(0, 32767)))}
	
	P.id = strings.join(temp_id[:], "-")	
	T.piece_on_tile = P 
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
	}
	
	return result
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
			pieces[i].spr.src,
			pieces[i].spr.dest,
			pieces[i].spr.center,
			0,
			WHITE)
	}
}
