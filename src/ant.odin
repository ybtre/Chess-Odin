package LD_53

import rl "vendor:raylib"
import "core:fmt"

MAX_ANTS :: MAX_ANTS_BUILDER + MAX_ANTS_GATHERER + MAX_ANTS_SOLDIER
ants : [MAX_ANTS]Ant

MAX_ANTS_GATHERER :: 12
gatherer_ant_tex : rl.Texture2D
gatherer_ants_count : i32

GATHERER_SCALE_MULTI :: 3
GATHERER_PIVOT :: GATHERER_SCALE_MULTI * 2

MAX_ANTS_BUILDER :: 6
builder_ant_tex : rl.Texture2D
builder_ants_count : i32

BUILDER_SCALE_MULTI :: 3
BUILDER_PIVOT :: BUILDER_SCALE_MULTI * 2

MAX_ANTS_SOLDIER :: 9
soldier_ant_tex : rl.Texture2D
soldier_ants_count : i32

SOLDIER_SCALE_MULTI :: 2
SOLDIER_PIVOT :: SOLDIER_SCALE_MULTI * 2

setup_ants :: proc() {
    // gatherer_ant_tex = rl.LoadTexture("../raw_photos/gatherer_ant_scaled.png")
    // builder_ant_tex = rl.LoadTexture("../raw_photos/builder_ant_scaled.png")
    // soldier_ant_tex = rl.LoadTexture("../raw_photos/soldier_ant_scaled.png")
    gatherer_ant_tex = rl.LoadTexture("../assets/gatherer_ant.png")
    builder_ant_tex = rl.LoadTexture("../assets/builder_ant.png")
    soldier_ant_tex = rl.LoadTexture("../assets/soldier_ant.png")

    for i in 0..<MAX_ANTS {
        ants[i].ent.spr.src = {0,0, 160, 160}
        ants[i].ent.spr.dest = { 0, 0, ants[i].ent.spr.src.width/GATHERER_SCALE_MULTI * 1.5, ants[i].ent.spr.src.height/GATHERER_SCALE_MULTI }
        ants[i].ent.spr.center = { ants[i].ent.spr.src.width / GATHERER_PIVOT, ants[i].ent.spr.src.height / GATHERER_PIVOT }

        ants[i].ent.alive = false
        ants[i].ent.rec = {0, 0, ants[i].ent.spr.src.width, ants[i].ent.spr.src.height}
        ants[i].ent.color = C_PLAYER
        ants[i].ent.speed = 2

        ants[i].rot = 0
        ants[i].type = ANT_TYPES.GATHERER
        ants[i].has_resources = false
        ants[i].spawn_point = rl.Vector2{ cathedral.ent.rec.x + cathedral.ent.rec.width / 2 - 25, cathedral.ent.rec.y + cathedral.ent.rec.height }
        ants[i].target = rl.Vector2{liver.ent.rec.x + liver.ent.rec.width / 2 + 20, liver.ent.rec.y + liver.ent.rec.height / 2 + 20}
        ants[i].target_beetle = nil
        ants[i].detection_radius = 200
        ants[i].attack_cooldown = 2
        ants[i].attack_timer = ants[i].attack_cooldown
        ants[i].hp = 3
        ants[i].dmg = 0
    }
   
}

spawn_ant :: proc(ant: ^Ant, TYPE: ANT_TYPES){
    ant.type = TYPE
    ant.ent.rec = { ant.spawn_point.x, ant.spawn_point.y, ant.ent.spr.src.width/GATHERER_SCALE_MULTI, ant.ent.spr.src.height/GATHERER_SCALE_MULTI} 
    ant.ent.spr.dest = { ant.spawn_point.x + ant.ent.spr.src.width/GATHERER_PIVOT, ant.spawn_point.y  + ant.ent.spr.src.height/GATHERER_PIVOT, ant.ent.spr.src.width/GATHERER_SCALE_MULTI, ant.ent.spr.src.height/GATHERER_SCALE_MULTI }

    if ant.type == .GATHERER
    {
        ant.hp = 2
        ant.ent.speed = 1        
    }
    else if ant.type == .BUILDER
    {
        ant.hp = 1
        ant.ent.speed = 1.25
    }
    else if ant.type == .SOLDIER
    {    
        ant.hp = 3
        ant.dmg = 1
        ant.ent.speed = 2
        ant.target = rl.Vector2{SCREEN.x /2 - 70, SCREEN.y /2}
    }
}

set_ant_pos :: proc(ant : ^Ant, new_pos : rl.Vector2) {
    ant.ent.rec = { new_pos.x, new_pos.y, ant.ent.spr.src.width/GATHERER_SCALE_MULTI, ant.ent.spr.src.height/GATHERER_SCALE_MULTI} 
    ant.ent.spr.dest = {new_pos.x + ant.ent.spr.src.width/GATHERER_PIVOT, new_pos.y + ant.ent.spr.src.height/GATHERER_PIVOT, ant.ent.spr.src.width/GATHERER_SCALE_MULTI, ant.ent.spr.src.height/GATHERER_SCALE_MULTI }
}

update_ants :: proc() {
    for i in 0..<MAX_ANTS 
    {
        if ants[i].ent.alive
        {
            switch ants[i].type
            {
                case .GATHERER:
                    update_gatherer_ants(i)
                case .BUILDER:
                    update_builder_ants(i) 
                case .SOLDIER:
                    update_soldier_ants(i)
            }
        }
    }
}

update_gatherer_ants :: proc(i: int)
{
    if ants[i].hp <= 0
    {
        // fmt.println("UPDT GATHERER ANTS DEAD")
        ants[i].ent.alive = false
        gatherer_ants_count -= 1
    } 
    else 
    {
        if ants[i].ent.rec.x == ants[i].target.x &&
            ants[i].ent.rec.y == ants[i].target.y
        {
            ants[i].has_resources = true
            ants[i].liver_piece = spawn_liver_piece(&ants[i])
        }   
    
        if ants[i].ent.rec.x == liver_pieces_dropoff_point.x && ants[i].ent.rec.y == liver_pieces_dropoff_point.y
        {
            ants[i].has_resources = false
            if ants[i].liver_piece != nil
            {
                handle_liver_piece_dropoff(liver_pieces_dropoff_point, ants[i].liver_piece)
                ants[i].liver_piece = nil
            }
        }   

        if !ants[i].has_resources
        {
            pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}
            pos = vec2_move_towards(pos, ants[i].target, ants[i].ent.speed)

            set_ant_pos(&ants[i], pos)
        }
        else 
        {
            pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}
            pos = vec2_move_towards(pos, liver_pieces_dropoff_point, ants[i].ent.speed)

            set_ant_pos(&ants[i], pos)

            set_liver_piece_pos_to_ant(&ants[i], ants[i].liver_piece)
        }
    }
}

update_builder_ants :: proc(i: int)
{
    if ants[i].hp <= 0
    {
        ants[i].ent.alive = false
        builder_ants_count -= 1
    }

    if !ants[i].has_resources
    { 
        if ants[i].liver_piece != nil
        {
            pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}
            pos = vec2_move_towards(pos, rl.Vector2{ants[i].liver_piece.rec.x, ants[i].liver_piece.rec.y}, ants[i].ent.speed)

            set_ant_pos(&ants[i], pos)
        } else 
        {
            // fmt.println(len(liver_pieces_for_building))
            if len(liver_pieces_for_building) > 0 && liver_pieces_count > 0
            {

                last_piece := pop(&liver_pieces_for_building)
                // liver_pieces_count -= 1
                fmt.println("PROGRESS")
                ants[i].liver_piece = last_piece
            }

            pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}

            idle_pos := rl.Vector2{900, 640}
            pos = vec2_move_towards(pos, idle_pos, ants[i].ent.speed)

            set_ant_pos(&ants[i], pos)
        }
    } else 
    {
        pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}
        pos = vec2_move_towards(pos, rl.Vector2{1200, 640}, ants[i].ent.speed)

        set_ant_pos(&ants[i], pos)
        set_liver_piece_pos_to_ant(&ants[i], ants[i].liver_piece)
    }

    if ants[i].liver_piece != nil &&
    ants[i].ent.rec.x == ants[i].liver_piece.rec.x &&
    ants[i].ent.rec.y == ants[i].liver_piece.rec.y && ants[i].has_resources == false
    {
        ants[i].has_resources = true
        liver_pieces_count -= 1
    }   
    if ants[i].ent.rec.x == 1200 &&
    ants[i].ent.rec.y == 640
    {
        ants[i].has_resources = false
        ants[i].liver_piece.alive = false
        ants[i].liver_piece = nil
        cathedral.build_progress += 1
    } 
}

update_soldier_ants :: proc(i: int)
{
    using rl

    if ants[i].hp <= 0
    {
        ants[i].ent.alive = false
        soldier_ants_count -= 1
    }

    if ants[i].target_beetle == nil
    {
        ants[i].target = rl.Vector2{SCREEN.x /2 - 70, SCREEN.y /2}
        pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}
        pos = vec2_move_towards(pos, ants[i].target, ants[i].ent.speed)

        set_ant_pos(&ants[i], pos)
    
        for j in 0..<MAX_BEETLES
        {
            if beetles[j].ent.alive 
            {
                if CheckCollisionCircleRec(Vector2{ants[i].ent.rec.x + ants[i].ent.spr.src.width/SOLDIER_PIVOT, ants[i].ent.rec.y + ants[i].ent.spr.src.width/SOLDIER_PIVOT}, 
                                            f32(ants[i].detection_radius), beetles[j].ent.rec)
                {
                    // fmt.println("FOUND BEETLE TARGET")
                    ants[i].target_beetle = &beetles[j]
                    break
                }
            }
        }
    }
    else if ants[i].target_beetle != nil
    {
        pos := rl.Vector2{ants[i].ent.rec.x, ants[i].ent.rec.y}
        pos = vec2_move_towards(pos, Vector2{ants[i].target_beetle.ent.rec.x, ants[i].target_beetle.ent.rec.y}, ants[i].ent.speed)

        set_ant_pos(&ants[i], pos)

        
        if ants[i].ent.rec.x == ants[i].target_beetle.ent.rec.x && ants[i].ent.rec.y == ants[i].target_beetle.ent.rec.y
        {
            ants[i].attack_timer += rl.GetFrameTime()

            if ants[i].attack_timer >= ants[i].attack_cooldown 
            {
                if ants[i].target_beetle.ent.alive
                {
                    // fmt.println("ATTACK")
                    ants[i].target_beetle.hp -= ants[i].dmg
                    // fmt.println(ants[i].target_beetle.hp)
                        
                    ants[i].attack_timer = 0
                }
                else if ants[i].target_beetle.ent.alive == false
                {
                    ants[i].target_beetle = nil
                }
            }
        }
    }
}

render_ants :: proc() {
    using rl

    for i in 0..<MAX_ANTS
    {
        if ants[i].ent.alive
        {
            switch ants[i].type
            {
                case .GATHERER:
                    // DrawRectangleLinesEx(ants[i].ent.rec, 4, GREEN)
                    DrawTexturePro(
                        gatherer_ant_tex, 
                        ants[i].ent.spr.src, 
                        ants[i].ent.spr.dest, 
                        ants[i].ent.spr.center,
                        ants[i].rot,
                        // f32(GetTime()) * 90,
                        ants[i].ent.color)
                case .BUILDER:
                    // DrawRectangleLinesEx(ants[i].ent.rec, 4, GREEN)
                    DrawTexturePro(
                        builder_ant_tex, 
                        ants[i].ent.spr.src, 
                        ants[i].ent.spr.dest, 
                        ants[i].ent.spr.center,
                        ants[i].rot,
                        // f32(GetTime()) * 45,
                        ants[i].ent.color)
                case .SOLDIER:
                    // DrawCircleLines(i32(ants[i].ent.rec.x + ants[i].ent.spr.src.width/SOLDIER_PIVOT), i32(ants[i].ent.rec.y + ants[i].ent.spr.src.width/SOLDIER_PIVOT), f32(ants[i].detection_radius), RED)
                    // DrawRectangleLinesEx(ants[i].ent.rec, 4, GREEN)
                    DrawTexturePro(
                        soldier_ant_tex, 
                        ants[i].ent.spr.src, 
                        ants[i].ent.spr.dest, 
                        ants[i].ent.spr.center,
                        ants[i].rot,
                        // f32(GetTime()) * 135,
                        ants[i].ent.color)
            }
        }
    }
}
