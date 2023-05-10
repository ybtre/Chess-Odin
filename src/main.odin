package LD_53

import "core:strings"
import rl "vendor:raylib"

main :: proc() {

	rl.SetRandomSeed(42)
	
	setup_window()
	rl.InitWindow(i32(SCREEN.x), i32(SCREEN.y), strings.clone_to_cstring(project_name))

	initialize_engine()

	is_running: bool = true
	for is_running && !rl.WindowShouldClose()
	{
		{// UPDATE
			update_engine()
		}

		{// RENDER
			render_engine()
		}
	}

	shutdown_engine()

	rl.CloseWindow()
}

setup_window :: proc(){
	rl.SetTargetFPS(60)

	// icon: rl.Image = rl.LoadImage("../assets/icons/window_icon.png")

	// rl.ImageFormat(&icon, rl.PixelFormat.UNCOMPRESSED_R8G8B8A8)

	// rl.SetWindowIcon(icon)

	// rl.UnloadImage(icon)
}
