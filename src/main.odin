package fantasy_chess

import "core:strings"
import rl "vendor:raylib"

main :: proc() {

	rl.SetRandomSeed(42)
	
	setup_window()
	rl.InitWindow(i32(SCREEN.x), i32(SCREEN.y), strings.clone_to_cstring(project_name))

	// initialize_engine()
	setup_game()

	is_running: bool = true
	for is_running && !rl.WindowShouldClose()
	{
		{// UPDATE
			// update_engine()
			update_screens()
		}

		{// RENDER
			// render_engine()
			render_screens()
		}
	}

	clear_and_shutdown()

	rl.CloseWindow()
}

setup_window :: proc(){
	rl.SetTargetFPS(60)

	// icon: rl.Image = rl.LoadImage("../assets/icons/window_icon.png")

	// rl.ImageFormat(&icon, rl.PixelFormat.UNCOMPRESSED_R8G8B8A8)

	// rl.SetWindowIcon(icon)

	// rl.UnloadImage(icon)
}

setup_game :: proc()
{
    load_all_textures()
    setup_sprite_sources()

    startup_game_overlord()

    setup_background()

    setup_board()
    // setup_start_pieces()
    setup_start_pieces_fen()
    // setup_buttons()
}

update_screens :: proc()
{
    switch current_screen {
        case .MAIN_MENU:
            update_main_menu()
        case .GAMEPLAY:
            update_gameplay()
        case .GAME_OVER:
    }
}

render_screens :: proc()
{
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

clear_and_shutdown :: proc()
{
	unload_all_textures()
}
