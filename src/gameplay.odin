package fantasy_chess 

import rl "vendor:raylib"
import "core:fmt"

last_hover_tile       : ^Tile
hover_tile            : ^Tile
last_selected_tile    : ^Tile
selected_tile         : ^Tile

has_move_executed     : bool        = false
can_move_execute      : bool        = false

update_gameplay :: proc() {
    using rl

	DrawText(TextFormat("%s TO MOVE", is_black_turn ? "BLACK" : "WHITE"), 20, 500, 30, GRAY)
        
    if rl.IsKeyPressed(rl.KeyboardKey.P){
        is_paused = !is_paused
    }

    if !is_paused
    {   
        {//mouse_check_hovering_pos -> return current hovering tile
            last_hover_tile = hover_tile
            hover_tile = mouse_get_hover_tile()
        }
        
        {//mouse_check_button_press -> return current selected tile
            new_selected := mouse_get_selected_tile()

            if new_selected != nil
            {   
                if last_selected_tile != nil
                {
                    last_selected_tile.data.state = .IDLE
                }
                last_selected_tile = selected_tile
                selected_tile = new_selected
            }
        }
        
        {//compare hovering tile vs selected tile
            if last_hover_tile != nil && last_hover_tile != hover_tile
            {
                last_hover_tile.data.state = .IDLE
            }
            if (hover_tile != nil) && hover_tile != selected_tile
            {
                hover_tile.data.state = .HIGHLIGHTED
            }
        }

        {// handle selecting new tile
            if (selected_tile != nil) 
            {    
                if selected_tile.data.state == .CAN_MOVE
                {
                    fmt.println("CAN MOVE")
                }

                if selected_tile.data.state == .CAN_TAKE
                {
                    fmt.println("CAN TAKE")
                }
                
                if selected_tile.data.state != .CAN_MOVE && 
                    selected_tile.data.state != .CAN_TAKE
                {    
                    selected_tile.data.state = .SELECTED

                    possible_moves_reset()

                    if selected_tile.data.piece != nil
                    {
                        selected_tile.data.piece.data.has_calculated_moves = false
                    }
                }
            }
        }
        
        {//turn_handle - black or white, only allow selecting piece of appropiete color
            if selected_tile != nil
            {
                if selected_tile.data.piece != nil 
                {
                    selected_p_color := selected_tile.data.piece.visuals.color
                    
                    switch turn_state
                    {
                        case .BLACK:
                            if selected_p_color == turn_state
                            {
                                possible_moves_calculate(selected_tile)
                            }
                        break

                        case .WHITE:
                            if selected_p_color == turn_state
                            {
                                possible_moves_calculate(selected_tile)
                            }
                        break

                        case .NONE:
                        break
                    }           
                }
            } 
            
            apply_possible_moves()
        }

        if selected_tile != nil && last_selected_tile != nil
        {
            if last_selected_tile.data.piece != nil
            {
                if last_selected_tile.data.piece.data.has_calculated_moves == true
                {
                    can_move_execute = can_execute_move()
                    if can_move_execute == true          
                    {
                        has_move_executed = move_execute()
                    }
                }
            }
        }

        if has_move_executed == true 
        {    
            possible_moves_reset()
            switch_player()
            has_move_executed = false
        }
    }
    else 
    {
        pause_blink_counter += 1
    }
}

render_gameplay :: proc(){
    using rl

    // render_background()
    render_board()
    render_pieces()
       
    if is_paused && ((pause_blink_counter / 30) % 2 == 0)
    {
		rl.DrawText("GAME PAUSED", i32(SCREEN.x / 2 - 290), i32(SCREEN.y / 2 - 50), 80, rl.RED)
	} 

    {// UI
    //    render_buttons()
        DrawText(TextFormat("Mouse Pos: %i, %i", GetMouseX(), GetMouseY()), 20, 10, 50, GRAY)

        if selected_tile != nil
        {
    		DrawText(TextFormat("TILE ID: %s", selected_tile.data.id), 20, 100, 30, GRAY)
    		DrawText(TextFormat("TILE COORDS: %i", selected_tile.data.tile_coords), 20, 130, 30, GRAY)

            if selected_tile.data.piece != nil
            {            
        		DrawText(TextFormat("PIECE COORDS: %i", selected_tile.data.piece.data.coords), 20, 190, 30, GRAY)
            }
        }
    }
}
