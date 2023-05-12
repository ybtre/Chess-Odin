package fantasy_chess 

startup_game_overlord :: proc(){
    current_screen = SCREENS.MAIN_MENU
    is_paused = false
}

setup_game :: proc() {
}

reset_game :: proc(){
    cathedral.build_progress = 0
    cathedral.build_stage = 0
    is_paused = false
}