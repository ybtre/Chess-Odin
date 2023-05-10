package LD_53

import rl "vendor:raylib"

MAX_BTNS :: 3
buttons : [MAX_BTNS]Button
btn_tex : rl.Texture2D

setup_buttons :: proc() {
    // btn_tex = rl.LoadTexture("../assets/ant_temp.png")

    for i in 0..<MAX_BTNS {
        buttons[i].spr.src = {0,0, 160, 160}
        buttons[i].spr.dest = { 0, 0, buttons[i].spr.src.width/4, buttons[i].spr.src.height/4 }
        buttons[i].spr.center = { buttons[i].spr.src.width / 2.0, buttons[i].spr.src.height / 2.0 }

        buttons[i].rec = {0, 0, buttons[i].spr.src.width, buttons[i].spr.src.height}

        buttons[i].is_highlighted = false
        buttons[i].is_pressed = false
    }
}


set_btn_pos :: proc(btn : ^Button, new_pos : rl.Vector2) {
    btn.rec = { new_pos.x - btn.spr.src.width /2, new_pos.y- btn.spr.src.width /2, btn.spr.src.width/2, btn.spr.src.height/2} 
    btn.spr.dest = {new_pos.x, new_pos.y, btn.spr.src.width/2, btn.spr.src.height/2 }
}

update_buttons :: proc() {
    using rl

    for i in 0..<MAX_BTNS
    {
        if CheckCollisionPointRec(GetMousePosition(), buttons[i].rec)
        {
            buttons[i].is_highlighted = true

            if IsMouseButtonReleased(MouseButton.LEFT)
            {
                buttons[i].is_pressed = true
            } 
            else {
                buttons[i].is_pressed = false
            }
        } else {
            buttons[i].is_highlighted = false
        }
    }
}

handle_button_interactions :: proc()
{
    using rl   
    
    if buttons[0].is_pressed 
    {
        for i in 0..<MAX_ANTS 
        {
            if !ants[i].ent.alive
            {
                ants[i].ent.alive = true
                spawn_ant(&ants[i], ANT_TYPES.GATHERER)
                gatherer_ants_count += 1
                break
            }
        }
    }
    if buttons[1].is_pressed 
    {
        for i in 0..<MAX_ANTS 
        {
            if !ants[i].ent.alive
            {
                ants[i].ent.alive = true
                spawn_ant(&ants[i], ANT_TYPES.BUILDER)
                builder_ants_count += 1
                break
            }
        }
    }
   
    if buttons[2].is_pressed 
    {
        for i in 0..<MAX_ANTS 
        {
            if !ants[i].ent.alive
            {
                ants[i].ent.alive = true
                spawn_ant(&ants[i], ANT_TYPES.SOLDIER)
                soldier_ants_count += 1
                break
            }
        }
    }
}

render_buttons :: proc() {
    using rl

    DrawRectangleLinesEx(buttons[0].rec, 4, RED)
    if buttons[0].is_highlighted {
        if buttons[0].is_pressed
        {
            DrawTexturePro(gatherer_ant_tex, buttons[0].spr.src, buttons[0].spr.dest, buttons[0].spr.center, 0, GREEN)
        } 
        else {
            DrawTexturePro(gatherer_ant_tex, buttons[0].spr.src, buttons[0].spr.dest, buttons[0].spr.center, 0, BLACK)
        }
    } else {
        DrawTexturePro(gatherer_ant_tex, buttons[0].spr.src, buttons[0].spr.dest, buttons[0].spr.center, 0, MAGENTA)
    }

    DrawRectangleLinesEx(buttons[1].rec, 4, RED)
    if buttons[1].is_highlighted {
        if buttons[1].is_pressed
        {
            DrawTexturePro(builder_ant_tex, buttons[1].spr.src, buttons[1].spr.dest, buttons[1].spr.center, 0, GREEN)
        } 
        else {
            DrawTexturePro(builder_ant_tex, buttons[1].spr.src, buttons[1].spr.dest, buttons[1].spr.center, 0, BLACK)
        }
    } else {
        DrawTexturePro(builder_ant_tex, buttons[1].spr.src, buttons[1].spr.dest, buttons[1].spr.center, 0, MAGENTA)
    }

    DrawRectangleLinesEx(buttons[2].rec, 4, RED)
    if buttons[2].is_highlighted {
        if buttons[2].is_pressed
        {
            DrawTexturePro(soldier_ant_tex, buttons[2].spr.src, buttons[2].spr.dest, buttons[2].spr.center, 0, GREEN)
        } 
        else {
            DrawTexturePro(soldier_ant_tex, buttons[2].spr.src, buttons[2].spr.dest, buttons[2].spr.center, 0, BLACK)
        }
    } else {
        DrawTexturePro(soldier_ant_tex, buttons[2].spr.src, buttons[2].spr.dest, buttons[2].spr.center, 0, MAGENTA)
    }
}
