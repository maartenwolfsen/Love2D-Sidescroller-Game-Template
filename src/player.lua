require "src/util"
require "src/window"

Player = {
	sprite = love.graphics.newImage("images/spritesheets/player.png"),
	spriteSize = {
		w = 80,
		h = 80
	},
	health = 100,
	score = 0,
	scoreTimer = 0,
	scoreTimerMax = 20,
	hurt = false,
	hurt_started = false,
	hit = {
	    invincible = false,
	    invincibility_frames = 100,
	    invincibility_frame = 0
	},
	physics = {
		grounded = false,
		gravity = 0.1,
		drag = 40,
		speed = 2,
		velocity = {
			x = 0,
			y = 0
		}
	},
	transform = {
		x = 0,
		y = 0,
		w = 50,
		h = 80,
		r = 0,
		sX = 2,
		sY = 2
	},
	animations = {
        animation_speed = 10,
        animation_timer = 0,
        current_animation = "idle",
        current_animation_direction = "forward",
        current_animation_frame = 0,
        walk_right = {
        	direction = "forward",
        	steps = {
	            {x = 0, y = 0},
	            {x = 1, y = 0},
	            {x = 2, y = 0},
	            {x = 3, y = 0},
	            {x = 4, y = 0},
	            {x = 5, y = 0},
	            {x = 6, y = 0},
	            {x = 7, y = 0}
        	}
        },
        walk_left = {
        	direction = "forward",
        	steps = {
	            {x = 7, y = 1},
	            {x = 6, y = 1},
	            {x = 5, y = 1},
	            {x = 4, y = 1},
	            {x = 3, y = 1},
	            {x = 2, y = 1},
	            {x = 1, y = 1},
	            {x = 0, y = 1}
        	}
        },
        jump = {
        	direction = "repeat_from_5",
        	steps = {
	            {x = 0, y = 2},
	            {x = 1, y = 2},
	            {x = 2, y = 2},
	            {x = 3, y = 2},
	            {x = 4, y = 2},
	            {x = 5, y = 2},
	            {x = 6, y = 2}
        	}
        },
        idle = {
        	direction = "forward",
        	steps = {
	            {x = 0, y = 3},
	            {x = 1, y = 3},
	            {x = 2, y = 3},
	            {x = 3, y = 3}
        	}
        },
        hurt = {
        	direction = "forward",
        	steps = {
        		{x = 0, y = 4}
        	}
        },
        duck = {
        	direction = "repeat_from_1",
        	steps = {
	            {x = 0, y = 5},
	            {x = 1, y = 5},
	            {x = 2, y = 5},
	            {x = 3, y = 5}
        	}
        }
    }
}
Player.transform.y = Window.h - Player.transform.h * Player.transform.sY
Player.animation = love.graphics.newQuad(
	0,
	0,
	Player.spriteSize.w,
	Player.spriteSize.h,
	Player.sprite
)
Player.sprite:setFilter("nearest", "nearest")

Player.draw = function()
	if Player.hit.invincible then
		love.graphics.setColor(255,0,0)
	end

	love.graphics.draw(
		Player.sprite,
		Player.animation,
		love.math.newTransform(
			Player.transform.x,
			Player.transform.y,
			Player.transform.r,
			Player.transform.sX,
			Player.transform.sY
		)
	)
end

Player.update = function()
    if Player.hit.invincible then
        if Player.hit.invincibility_frame > Player.hit.invincibility_frames then
            Player.hit.invincibility_frame = 0
            Player.hit.invincible = false
        else
            Player.hit.invincibility_frame = Player.hit.invincibility_frame + 1
        end
    end

    if (love.keyboard.isDown("a") or love.keyboard.isDown("left"))
    	and Player.transform.x >= 0 and not Player.hurt then
    	Player.physics.velocity.x = -Player.physics.speed
    elseif (love.keyboard.isDown("d") or love.keyboard.isDown("right"))
    	and Player.transform.x <= Window.w - Player.transform.w * Player.transform.sX
    	and not Player.hurt then
    	Player.physics.velocity.x = Player.physics.speed
    else
    	Player.physics.velocity.x = 0
    end

    if Player.transform.y > Window.h - Player.transform.h * Player.transform.sY then
    	Player.physics.velocity.y = 0
    	Player.physics.grounded = true
    else
    	Player.physics.velocity.y = Player.physics.velocity.y + Player.physics.gravity
    	Player.physics.grounded = false

    	if Player.physics.velocity.y > Player.physics.drag then
    		Player.physics.velocity.y = Player.physics.drag
    	end
    end

    if (love.keyboard.isDown("w") or love.keyboard.isDown("up"))
    	and Player.physics.grounded
    	and not Player.hurt then
    	Player.physics.velocity.y = -5
    end

    if not Player.hurt_started and Player.hurt then
    	Player.physics.velocity.y = -5
    	Player.hurt_started = true
    end

    if Player.hurt and Player.physics.grounded then
    	Player.hurt = false
    	Player.hurt_started = false
    end

    Player.transform.y = Player.transform.y + Player.physics.velocity.y
    Player.transform.x = Player.transform.x + Player.physics.velocity.x

	Player.updateAnimation()

	Player.scoreTimer = Player.scoreTimer + 1
	if Player.scoreTimer > Player.scoreTimerMax then
		Player.scoreTimer = 0
		Player.score = Player.score + 5
	end
end

Player.updateAnimation = function()
	local length = 0
    local playerAnimations = Player.animations
    local currentFrame = playerAnimations.current_animation_frame

    -- Update animation
    local animation
    if Player.hurt then
    	Player.setAnimation("hurt")
        animation = playerAnimations.hurt.steps
    elseif not Player.physics.grounded then
    	Player.setAnimation("jump")
        animation = playerAnimations.jump.steps
    else
	    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
	        Player.setAnimation("walk_left")
	        animation = playerAnimations.walk_left.steps
	    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
	        Player.setAnimation("walk_right")
	        animation = playerAnimations.walk_right.steps
	    elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
	        Player.setAnimation("duck")
	        animation = playerAnimations.duck.steps
	    else
	        Player.setAnimation("idle")
	        animation = playerAnimations.idle.steps
	    end
	end

    count = Util.getTableLength(animation)

    -- Update animation
    local currentFrameIndex = playerAnimations.current_animation_frame + 1
    local currentFrameLocation = playerAnimations.idle.steps[currentFrameIndex]
    if currentFrameLocation == nil then
    	currentFrameLocation = playerAnimations.idle.steps[1]
    end

    if playerAnimations.current_animation == "walk_left" then
        currentFrameLocation = playerAnimations.walk_left.steps[currentFrameIndex]
       	Player.animations.current_animation_direction = playerAnimations.walk_left.direction
    elseif playerAnimations.current_animation == "walk_right" then
        currentFrameLocation = playerAnimations.walk_right.steps[currentFrameIndex]
       	Player.animations.current_animation_direction = playerAnimations.walk_right.direction
    elseif playerAnimations.current_animation == "duck" then
        currentFrameLocation = playerAnimations.duck.steps[currentFrameIndex]
       	Player.animations.current_animation_direction = playerAnimations.duck.direction
    elseif playerAnimations.current_animation == "jump" then
        currentFrameLocation = playerAnimations.jump.steps[currentFrameIndex]
       	Player.animations.current_animation_direction = playerAnimations.jump.direction
    elseif playerAnimations.current_animation == "hurt" then
        currentFrameLocation = playerAnimations.hurt.steps[currentFrameIndex]
       	Player.animations.current_animation_direction = playerAnimations.hurt.direction
    end

    local timer = Player.animations.animation_timer
    if (timer > playerAnimations.animation_speed) then
        playerAnimations.animation_timer = 0

        frame = playerAnimations.current_animation_frame
        if (frame >= count - 1) then
        	if string.find(playerAnimations.current_animation_direction, "repeat_from") then
        		playerAnimations.current_animation_frame =
        			tonumber(string.sub(playerAnimations.current_animation_direction, -1))
        	else
            	playerAnimations.current_animation_frame = 0
        	end
        else
            playerAnimations.current_animation_frame = frame + 1
        end
    else
        playerAnimations.animation_timer = timer + 1
    end

    -- Create animation quad
    Player.animation = love.graphics.newQuad(
        currentFrameLocation.x * Player.spriteSize.w,
        currentFrameLocation.y * Player.spriteSize.h,
        Player.spriteSize.w,
        Player.spriteSize.h,
        Player.sprite
    )
end

Player.setAnimation = function(animation)
    if (Player.animations.current_animation == animation) then
        return
    end

    Player.animations.current_animation = animation
    Player.animations.animation_timer = 0
    Player.animations.current_animation_frame = 0
end

Player.takeDamage = function(damage)
    Player.hit.invincible = true
	Player.health = Player.health - damage
	Player.hurt = true
end
