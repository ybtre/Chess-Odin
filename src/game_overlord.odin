package fantasy_chess 

score := 0

current_screen : SCREENS = .MAIN_MENU

is_paused := false
pause_blink_counter := 0

gameplay_time_total : f32 = 0.0
gameplay_time_current := 0.0

is_black_turn := false

SCREENS :: enum {
    MAIN_MENU,
    GAMEPLAY,
    GAME_OVER,
}

startup_game_overlord :: proc(){
    current_screen = SCREENS.MAIN_MENU
    is_paused = false
    is_black_turn = false
}

reset_game :: proc(){
    is_paused = false
}

switch_player :: proc()
{
    is_black_turn = !is_black_turn
}