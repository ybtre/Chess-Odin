package base 

import "core:math"
import rl "vendor:raylib"
import "core:fmt"
import "core:strings"

atoc :: proc(STR : string, INDEX : int) -> string
{
    using strings
    
    builder := builder_make(context.allocator)
    result : string
    write_rune(&builder, rune(STR[INDEX]))
    result = to_string(builder)
    builder_reset(&builder)
    
    return result    
}

rtoa :: proc(R : rune) -> string
{
    using strings

    builder := builder_make(context.allocator)
    write_rune(&builder, R)
    result := to_string(builder)
    builder_reset(&builder)

    return result
}

update_sprite_dest :: proc(NEW_POS: rl.Vector2, DEST: rl.Rectangle) -> rl.Rectangle {
    return { NEW_POS.x, NEW_POS.y, DEST.width, DEST.height }
}


vec2_move_towards :: proc(V, TARGET : rl.Vector2, MAX_DIST : f32) -> rl.Vector2 {
    result : rl.Vector2

    dx := TARGET.x - V.x
    dy := TARGET.y - V.y
    value := (dx * dx) + (dy * dy)

    if value == 0 || MAX_DIST >= 0 && (value <= MAX_DIST * MAX_DIST)
    {
        return TARGET
    }

    dist := math.sqrt_f32(value)

    result.x = V.x + dx / dist * MAX_DIST
    result.y = V.y + dy / dist * MAX_DIST

    return result
}