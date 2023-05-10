package LD_53

import rl "vendor:raylib"
// import "core:fmt"

liver : Liver
liver_tex : rl.Texture2D

MAX_PIECES :: MAX_ANTS * 4
liver_pieces : [MAX_PIECES]Entity
liver_piece_tex : rl.Texture2D
LIVER_PIECES_SCALE :: 4
LIVER_PIECES_PIVOT :: LIVER_PIECES_SCALE * 2
liver_pieces_dropoff_point :: rl.Vector2{900, 460}
liver_pieces_count : i32 = 0
liver_pieces_for_building : [dynamic]^Entity


setup_liver :: proc() {
    // liver_tex = rl.LoadTexture("../assets/liver_temp.png")
    liver_tex = rl.LoadTexture("../assets/liver.png")
    liver_piece_tex = rl.LoadTexture("../assets/liver_piece.png")

    liver.ent.spr.src = {0,0, 320, 192} 
    liver.ent.spr.dest = { 0, 0, liver.ent.spr.src.width, liver.ent.spr.src.height }
    liver.ent.spr.center = { liver.ent.spr.src.width / 2.0, liver.ent.spr.src.height / 2.0 }

    liver.ent.alive = true
    liver.ent.rec = {0, 0, liver.ent.spr.src.width, liver.ent.spr.src.height}
    liver.ent.color = rl.WHITE
    liver.ent.speed = 0
   
    liver.rot = 0
    liver.de_livering_progress = 0
    liver.de_livering_stage = 0

    liver.hp = 0
}

set_liver_pos :: proc(new_pos : rl.Vector2) {
    liver.ent.rec = { new_pos.x - liver.ent.spr.src.width /2, new_pos.y - liver.ent.spr.src.height /2, liver.ent.spr.src.width, liver.ent.spr.src.height} 
    liver.ent.spr.dest = {new_pos.x, new_pos.y, liver.ent.spr.src.width, liver.ent.spr.src.height }
}

render_liver :: proc() {
    // rl.DrawRectangleLinesEx(liver.ent.rec, 4, rl.BLUE)
    rl.DrawTexturePro(
        liver_tex, 
        liver.ent.spr.src, 
        liver.ent.spr.dest, 
        liver.ent.spr.center,
        liver.rot,
        liver.ent.color)
}

spawn_liver_piece :: proc(ant : ^Ant) -> ^Entity {
    for i in 0..<MAX_PIECES
    {
        if !liver_pieces[i].alive
        {
            liver_pieces[i].spr.src = {0,0, 320, 192}
            liver_pieces[i].spr.dest = { ant.ent.rec.x, ant.ent.rec.y, liver_pieces[i].spr.src.width/LIVER_PIECES_SCALE, liver_pieces[i].spr.src.height/LIVER_PIECES_SCALE }
            liver_pieces[i].spr.center = { liver_pieces[i].spr.src.width / LIVER_PIECES_PIVOT, liver_pieces[i].spr.src.height / LIVER_PIECES_PIVOT }
            
            liver_pieces[i].alive = true
            liver_pieces[i].rec = {ant.ent.rec.x, ant.ent.rec.y, liver_pieces[i].spr.src.width/LIVER_PIECES_SCALE, liver_pieces[i].spr.src.height/LIVER_PIECES_SCALE}
            liver_pieces[i].color = rl.WHITE
            liver_pieces[i].speed = 0

            return &liver_pieces[i]
        }
    }
    return nil
}

render_liver_pieces :: proc() {
    using rl

    for i in 0..<MAX_PIECES
    {
        if liver_pieces[i].alive
        {
            // DrawRectangleLinesEx(liver_pieces[i].rec, 4, GREEN)
            DrawTexturePro(
                liver_tex, 
                liver_pieces[i].spr.src, 
                liver_pieces[i].spr.dest, 
                liver_pieces[i].spr.center,
                0,
                // f32(GetTime()) * 90,
                liver_pieces[i].color)
        }
    }
}

set_liver_piece_pos_to_ant :: proc(ant : ^Ant, piece : ^Entity) 
{
    piece.rec = {ant.ent.rec.x, ant.ent.rec.y, piece.spr.src.width/LIVER_PIECES_SCALE, piece.spr.src.height/LIVER_PIECES_SCALE}
    piece.spr.dest = {ant.ent.spr.dest.x, ant.ent.spr.dest.y, piece.spr.src.width/LIVER_PIECES_SCALE, piece.spr.src.height/LIVER_PIECES_SCALE}
}

handle_liver_piece_dropoff :: proc(POS : rl.Vector2, PIECE : ^Entity)
{
    liver_pieces_count += 1
    // fmt.println(liver_pieces_count)

    // for i in 0..<liver_pieces_count 
    // {
        PIECE.rec = {POS.x, POS.y + f32((rl.GetRandomValue(11, 14) * i32(len(liver_pieces_for_building)))), PIECE.spr.src.width/LIVER_PIECES_SCALE, PIECE.spr.src.height/LIVER_PIECES_SCALE}
        PIECE.spr.dest = {POS.x + f32(rl.GetRandomValue(-5, 5)), POS.y + f32((12 * i32(len(liver_pieces_for_building)))), PIECE.spr.src.width/LIVER_PIECES_SCALE, PIECE.spr.src.height/LIVER_PIECES_SCALE}
        append(&liver_pieces_for_building, PIECE)
    // }
}