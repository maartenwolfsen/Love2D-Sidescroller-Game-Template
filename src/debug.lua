Debug = {}

Debug.draw = function()
	love.graphics.print("Player position: {x: "
        ..tostring(math.floor(Player.transform.x)).. "; y: "
        ..tostring(math.floor(Player.transform.y)).. "} Player Velocity: {x: "
        ..tostring(Player.physics.velocity.x).. "; y: ", 10, 20)
    love.graphics.print(tostring(Player.physics.velocity.y).. "} Grounded: "
        ..tostring(Player.physics.grounded).. " | Health: "
        ..tostring(Player.health).. " | Invincible: "
        ..tostring(Player.hit.invincible), 10, 40)
	love.graphics.print("Animation | Anim: "
        ..Player.animations.current_animation.. "; Timer: "
        ..tostring(Player.animations.animation_timer).. "; Frame: "
        ..tostring(Player.animations.current_animation_frame).. "; Direction: "
        ..Player.animations.current_animation_direction, 10, 60)
    love.graphics.print("Projectile Spawn Timer: "
        ..tostring(Projectile.spawnTimer).. "/"
        ..tostring(Projectile.spawnTimerMax), 10, 80)
end
