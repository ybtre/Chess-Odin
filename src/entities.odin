package fantasy_chess 

import rl "vendor:raylib"

Sprite :: struct {
    src: rl.Rectangle,
    dest: rl.Rectangle,
    center: rl.Vector2,
    SCALE_FACTOR : f32,
}

Tile_state :: enum {
    idle,
    highlighted,
    selected,
}

Tile :: struct {
    id: int,
    spr: Sprite,
    pos: rl.Vector2,
    hitbox: rl.Rectangle,
    state: Tile_state,
}

Board :: struct {
    tiles: [8][8]Tile,
}

Entity :: struct {
    alive: bool,
    rec: rl.Rectangle,
    spr: Sprite,

    color: rl.Color,
    speed: f32,
    move_dir: rl.Vector2,
}

Cursor :: struct {
    spr: Sprite,
}

Button :: struct {
    rec: rl.Rectangle,
    spr: Sprite,
    is_highlighted: bool,
    is_pressed: bool,
}

ANT_TYPES :: enum {
    GATHERER,
    SOLDIER,
    BUILDER,
}

Ant :: struct {
    ent: Entity,
    rot: f32,
    has_resources: bool,
    liver_piece: ^Entity,
    type: ANT_TYPES,
    spawn_point: rl.Vector2,
    target: rl.Vector2,

    // target_beetle: ^Beetle,
    attack_cooldown: f32,
    attack_timer: f32,
    detection_radius: i32,
    hp: i32,
    dmg: i32,
}

Background :: struct {
    spr: Sprite,
}
