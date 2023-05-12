package fantasy_chess 

import rl "vendor:raylib"

initialize_engine :: proc(){

    load_all_textures()
    setup_sprite_sources()

    startup_game_overlord()
    setup_game()

    setup_background()

    setup_board()
    // setup_buttons()
    // set_btn_pos(&buttons[0], rl.Vector2{ 400, 700})
    // set_btn_pos(&buttons[1], rl.Vector2{ 600, 700})
    // set_btn_pos(&buttons[2], rl.Vector2{ 800, 700})
}

update_engine :: proc(){
    switch current_screen {
        case .MAIN_MENU:
            update_main_menu()
        case .GAMEPLAY:
            update_gameplay()
        case .GAME_OVER:
    }
}

render_engine :: proc(){
    rl.BeginDrawing()
    rl.ClearBackground(rl.Color{ 71, 45, 60, 255 })

    {// RENDER
        switch current_screen {
            case .MAIN_MENU:
                render_main_menu()
            case .GAMEPLAY:
                render_gameplay()
            case .GAME_OVER:
        }
        // background.render()
        // game_map.render(game_atlas)
        // cursor.render()
    }
    rl.DrawFPS(0, 0)

    rl.EndDrawing()
}

shutdown_engine :: proc(){
    using rl

    unload_all_textures()
}