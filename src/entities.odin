package LD_53 

import rl "vendor:raylib"

Sprite :: struct {
    src: rl.Rectangle,
    dest: rl.Rectangle,
    center: rl.Vector2,
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

Cathedral :: struct {
    ent: Entity,
    stages_sprites: []Sprite,
    rot: f32,
    build_progress: i32,
    build_stage: i32,
}

Liver :: struct {
    ent: Entity,
    stages_sprites: []Sprite,
    rot: f32,
    hp: i32,
    de_livering_progress: f32,
    de_livering_stage: i32,
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

    target_beetle: ^Beetle,
    attack_cooldown: f32,
    attack_timer: f32,
    detection_radius: i32,
    hp: i32,
    dmg: i32,
}

Beetle :: struct {
    ent: Entity,
    rot: f32,
    spawn_point: rl.Vector2,
    target: ^Ant,
    
    attack_cooldown: f32,
    attack_timer: f32,
    detection_radius: i32,
    hp: i32,
    dmg: i32,
}

Background :: struct {
    spr: Sprite,
}
