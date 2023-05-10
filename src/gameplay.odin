package LD_53 

import rl "vendor:raylib"
// import "core:fmt"

spawn_timer : f32 = 0
beetle_spawn_timer : f32 = 10

update_gameplay :: proc() {
    using rl

    spawn_timer += rl.GetFrameTime()

    if rl.IsKeyPressed(rl.KeyboardKey.P){
        is_paused = !is_paused
    }

    if !is_paused
    {
        gameplay_time_total += rl.GetFrameTime()
        spawn_timer += GetFrameTime()

        update_buttons()
        handle_button_interactions()

        if spawn_timer >= beetle_spawn_timer
        {
            // fmt.println("SPAWN BEETLE")
            spawn_beetle()
            spawn_timer = 0
        }

        update_cathedral()    
        update_beetles()
        update_ants()
    }
    else 
    {
        pause_blink_counter += 1
    }
}

render_gameplay :: proc(){
    using rl

    // render_background()
    
    render_cathedral()
    render_liver()
    render_liver_pieces()
    render_ants()
    render_beetles()
   
    if is_paused && ((pause_blink_counter / 30) % 2 == 0)
    {
		rl.DrawText("GAME PAUSED", i32(SCREEN.x / 2 - 290), i32(SCREEN.y / 2 - 50), 80, rl.RED)
	} 

    {// UI
       render_buttons()
        DrawText(TextFormat("Liver Pieces Supply: %i, %i", liver_pieces_count, len(liver_pieces_for_building)), 620, 10, 50, GRAY)
        DrawText(TextFormat("Gatherer Ants: %i", gatherer_ants_count), 700, 60, 50, GRAY)
        DrawText(TextFormat("Builder Ants: %i", builder_ants_count), 700, 110, 50, GRAY)
        DrawText(TextFormat("Soldier Ants: %i", soldier_ants_count), 700, 160, 50, GRAY)
        DrawText(TextFormat("Beetles Count: %i", beetles_count), 700, 210, 50, GRAY)
        
        DrawText(TextFormat("Build Progress: %i", cathedral.build_progress), 700, 260, 50, GRAY)
        DrawText(TextFormat("Build Stage: %i", cathedral.build_stage), 700, 320, 50, GRAY)
    }
}
