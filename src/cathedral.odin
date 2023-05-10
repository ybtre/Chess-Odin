package LD_53

import rl "vendor:raylib"

cathedral : Cathedral
cathedral_tex : rl.Texture2D

setup_cathedral :: proc() {
    // cathedral_tex = rl.LoadTexture("../assets/cathedral_temp.png")
    cathedral_tex = rl.LoadTexture("../assets/cathedral.png")

    cathedral.ent.spr.src = {0,0, 280, 240}
    cathedral.ent.spr.dest = { 0, 0, cathedral.ent.spr.src.width, cathedral.ent.spr.src.height }
    cathedral.ent.spr.center = { cathedral.ent.spr.src.width / 2.0, cathedral.ent.spr.src.height / 2.0 }

    cathedral.ent.alive = true
    cathedral.ent.rec = {0, 0, cathedral.ent.spr.src.width, cathedral.ent.spr.src.height}
    cathedral.ent.color = rl.WHITE
    cathedral.ent.speed = 0
   
    cathedral.rot = 0
    cathedral.build_progress = 0
    cathedral.build_stage = 0
}

set_cathedral_pos :: proc(new_pos : rl.Vector2) {
    cathedral.ent.rec = { new_pos.x - cathedral.ent.spr.src.width /2, new_pos.y - cathedral.ent.spr.src.width /2, cathedral.ent.spr.src.width, cathedral.ent.spr.src.height} 
    cathedral.ent.spr.dest = {new_pos.x , new_pos.y , cathedral.ent.spr.src.width, cathedral.ent.spr.src.height }
}

update_cathedral :: proc() {
    if cathedral.build_progress >= 10
    {
        cathedral.build_stage += 1
        cathedral.build_progress = 0
    }

    if cathedral.build_stage == 5
    {
        reset_game()
        current_screen = .MAIN_MENU
    }

}

render_cathedral :: proc() {
    using rl

    // rl.DrawRectangleLinesEx(cathedral.ent.rec, 4, rl.ORANGE)

    if cathedral.build_stage == 0
    {
        rl.DrawTexturePro(
                cathedral_tex, 
                cathedral.ent.spr.src, 
                cathedral.ent.spr.dest, 
                cathedral.ent.spr.center,
                cathedral.rot,
                WHITE)
    }
    else if cathedral.build_stage == 1
    {
        rl.DrawTexturePro(
                cathedral_tex, 
                cathedral.ent.spr.src, 
                cathedral.ent.spr.dest, 
                cathedral.ent.spr.center,
                cathedral.rot,
                GREEN)
    }
    else if cathedral.build_stage == 2
    {
        rl.DrawTexturePro(
                cathedral_tex, 
                cathedral.ent.spr.src, 
                cathedral.ent.spr.dest, 
                cathedral.ent.spr.center,
                cathedral.rot,
                BLUE)
    } else if cathedral.build_stage == 3
    {
        rl.DrawTexturePro(
                cathedral_tex, 
                cathedral.ent.spr.src, 
                cathedral.ent.spr.dest, 
                cathedral.ent.spr.center,
                cathedral.rot,
                PURPLE)
    } else if cathedral.build_stage == 4
    {
        rl.DrawTexturePro(
                cathedral_tex, 
                cathedral.ent.spr.src, 
                cathedral.ent.spr.dest, 
                cathedral.ent.spr.center,
                cathedral.rot,
                ORANGE)
     }
}
