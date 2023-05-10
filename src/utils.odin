package LD_53 

import rl "vendor:raylib"
import "core:math"

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