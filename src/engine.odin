package LD_53 

import rl "vendor:raylib"

initialize_engine :: proc(){

    startup_game_overlord()
    setup_game()

    setup_background()

    setup_cathedral()
    set_cathedral_pos(rl.Vector2{1100, 550})

    setup_liver()
    set_liver_pos(rl.Vector2{200, 120})

    setup_ants()
    setup_bettles()

    setup_buttons()
    set_btn_pos(&buttons[0], rl.Vector2{ 400, 700})
    set_btn_pos(&buttons[1], rl.Vector2{ 600, 700})
    set_btn_pos(&buttons[2], rl.Vector2{ 800, 700})
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

    UnloadTexture(beetle_tex)
    UnloadTexture(liver_tex)
    UnloadTexture(btn_tex)
    UnloadTexture(cathedral_tex)
    UnloadTexture(bg_tex)
    UnloadTexture(builder_ant_tex)
    UnloadTexture(soldier_ant_tex)
    UnloadTexture(gatherer_ant_tex)
    UnloadTexture(liver_piece_tex)
}