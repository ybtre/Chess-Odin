package LD_53

import rl "vendor:raylib"
// import "core:fmt"

MAX_BEETLES :: 20
beetles : [MAX_BEETLES]Beetle
beetle_tex: rl.Texture2D
beetles_count: i32


setup_bettles :: proc() {
    // beetle_tex = rl.LoadTexture("../raw_photos/soldier_ant_scaled.png")
    beetle_tex = rl.LoadTexture("../assets/beetle.png")
  
    for i in 0..<MAX_BEETLES{
        beetles[i].ent.spr.src = {0,0, 160, 160}
        beetles[i].ent.spr.dest = { 0, 0, beetles[i].ent.spr.src.width/GATHERER_SCALE_MULTI * 1.5, beetles[i].ent.spr.src.height/GATHERER_SCALE_MULTI }
        beetles[i].ent.spr.center = { beetles[i].ent.spr.src.width / GATHERER_PIVOT, beetles[i].ent.spr.src.height / GATHERER_PIVOT }

        beetles[i].ent.alive = false
        beetles[i].ent.rec = {0, 0, beetles[i].ent.spr.src.width, beetles[i].ent.spr.src.height}
        beetles[i].ent.color = C_BEETLE
		beetles[i].ent.speed = 1.5
        beetles[i].rot = 0

		spawn_dir := rl.GetRandomValue(0, 1)
		if spawn_dir == 0
		{
			beetles[i].spawn_point = rl.Vector2{ -10, SCREEN.y / 2 }
		}
		else if spawn_dir == 1
		{
			beetles[i].spawn_point = rl.Vector2{ SCREEN.x / 2, -10 }
		}
        beetles[i].target = nil
        beetles[i].detection_radius = 100
		beetles[i].attack_cooldown = 2
		beetles[i].attack_timer = beetles[i].attack_cooldown
        beetles[i].hp = 5
		beetles[i].dmg = 1
    }
}

spawn_beetle :: proc()
{
	for i in 0..<MAX_BEETLES
	{
		if beetles[i].ent.alive == false
		{
			beetles[i].ent.alive = true
			beetles[i].hp = 2
			beetles_count += 1
			
			spawn_dir := rl.GetRandomValue(0, 1)
			if spawn_dir == 0
			{
				beetles[i].spawn_point = rl.Vector2{ -10, SCREEN.y / 2 }
			}
			else if spawn_dir == 1
			{
				beetles[i].spawn_point = rl.Vector2{ SCREEN.x / 2, -10 }
			}
			
			beetles[i].ent.rec = { beetles[i].spawn_point.x, beetles[i].spawn_point.y, beetles[i].ent.spr.src.width/GATHERER_SCALE_MULTI, beetles[i].ent.spr.src.height/GATHERER_SCALE_MULTI} 
		    beetles[i].ent.spr.dest = { beetles[i].spawn_point.x + beetles[i].ent.spr.src.width/GATHERER_PIVOT, beetles[i].spawn_point.y  + beetles[i].ent.spr.src.height/GATHERER_PIVOT, beetles[i].ent.spr.src.width/GATHERER_SCALE_MULTI, beetles[i].ent.spr.src.height/GATHERER_SCALE_MULTI }
		    beetles[i].target = nil

			break
		}
	}
}

update_beetles :: proc()
{
	for i in 0..<MAX_BEETLES
	{
		if beetles[i].ent.alive
		{
			update_beetle(i)
		}
	}
}

update_beetle :: proc(i: int)
{
	using rl

	if beetles[i].hp <= 0
	{
		beetles[i].ent.alive = false
		beetles_count -= 1
	}
	
	if beetles[i].target != nil
	{
        pos := rl.Vector2{beetles[i].ent.rec.x, beetles[i].ent.rec.y}
        pos = vec2_move_towards(pos, rl.Vector2{beetles[i].target.ent.rec.x, beetles[i].target.ent.rec.y}, beetles[i].ent.speed)

        set_beetle_pos(&beetles[i], pos)

		if beetles[i].ent.rec.x == beetles[i].target.ent.rec.x && beetles[i].ent.rec.y == beetles[i].target.ent.rec.y
        {
            beetles[i].attack_timer += rl.GetFrameTime()

            if beetles[i].attack_timer >= beetles[i].attack_cooldown 
            {
                if beetles[i].target.ent.alive
                {
                    // fmt.println("ATTACK")
                    // fmt.println(beetles[i].target.hp)
                    // fmt.println(beetles[i].dmg)
                    beetles[i].target.hp -= beetles[i].dmg
                    // fmt.println(beetles[i].target_beetle.hp)
                    
                    beetles[i].attack_timer = 0
                }
                else if beetles[i].target.ent.alive == false
                {
                    // fmt.println("TARGET NIL")
                    beetles[i].target = nil
                }
            }
        }
	}
	else if beetles[i].target == nil
	{
        target_nil := rl.Vector2{SCREEN.x /2 - 70, SCREEN.y /2}
        pos := rl.Vector2{beetles[i].ent.rec.x, beetles[i].ent.rec.y}
        pos = vec2_move_towards(pos, target_nil, beetles[i].ent.speed)

        set_beetle_pos(&beetles[i], pos)
    
        for j in 0..<MAX_ANTS 
		{
			if ants[j].ent.alive && ants[j].type == .SOLDIER
			{
				if CheckCollisionCircleRec(Vector2{beetles[i].ent.rec.x + beetles[i].ent.spr.src.width/SOLDIER_PIVOT, beetles[i].ent.rec.y + beetles[i].ent.spr.src.width/SOLDIER_PIVOT}, 
	                                        f32(beetles[i].detection_radius), ants[j].ent.rec)
	            {
	                // fmt.println("FOUND SOLDIER TARGET")
	                beetles[i].target = &ants[j]
	                break
	            }				
			}
            else if ants[j].ent.alive && ants[j].type == .GATHERER
            {
                if CheckCollisionCircleRec(Vector2{beetles[i].ent.rec.x + beetles[i].ent.spr.src.width/SOLDIER_PIVOT, beetles[i].ent.rec.y + beetles[i].ent.spr.src.width/SOLDIER_PIVOT}, 
                                            f32(beetles[i].detection_radius), ants[j].ent.rec)
                {
                    // fmt.println("FOUND GATHERER TARGET")
                    beetles[i].target = &ants[j]
                    break
                }
            }
			else if ants[j].ent.alive && ants[j].type == .BUILDER
			{
				if CheckCollisionCircleRec(Vector2{beetles[i].ent.rec.x + beetles[i].ent.spr.src.width/SOLDIER_PIVOT, beetles[i].ent.rec.y + beetles[i].ent.spr.src.width/SOLDIER_PIVOT}, 
                                            f32(beetles[i].detection_radius), ants[j].ent.rec)
                {
                    // fmt.println("FOUND BUILDER TARGET")
                    beetles[i].target = &ants[j]
                    break
                }				
			} 
        }
	}
}

set_beetle_pos :: proc(beetle : ^Beetle, new_pos : rl.Vector2) {
    beetle.ent.rec = { new_pos.x, new_pos.y, beetle.ent.spr.src.width/GATHERER_SCALE_MULTI, beetle.ent.spr.src.height/GATHERER_SCALE_MULTI} 
    beetle.ent.spr.dest = {new_pos.x + beetle.ent.spr.src.width/GATHERER_PIVOT, new_pos.y + beetle.ent.spr.src.height/GATHERER_PIVOT, beetle.ent.spr.src.width/GATHERER_SCALE_MULTI, beetle.ent.spr.src.height/GATHERER_SCALE_MULTI }
}

render_beetles :: proc()
{
	using rl
	
	for i in 0..<MAX_BEETLES
	{
		if beetles[i].ent.alive
		{
            // DrawCircleLines(i32(beetles[i].ent.rec.x + beetles[i].ent.spr.src.width/SOLDIER_PIVOT), i32(beetles[i].ent.rec.y + beetles[i].ent.spr.src.width/SOLDIER_PIVOT), f32(beetles[i].detection_radius), RED)
	        // DrawRectangleLinesEx(beetles[i].ent.rec, 4, RED)
	        DrawTexturePro(
	            beetle_tex, 
	            beetles[i].ent.spr.src, 
	            beetles[i].ent.spr.dest, 
	            beetles[i].ent.spr.center,
	            beetles[i].rot,
	            // f32(GetTime()) * 90,
				beetles[i].ent.color)
		}
	}	
}