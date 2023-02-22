require "src/colliders"
require "src/player"

Projectile = {
	sprite = love.graphics.newImage("images/ball.png"),
	objects = {},
	spawnTimer = 0,
	spawnTimerMax = 1000
}
Projectile.sprite:setFilter("nearest", "nearest")

Projectile.getPrefab = function()
	return {
		transform = {
			x = 0,
			y = 0,
			r = 0,
			w = 4,
			h = 4,
			sX = 4,
			sY = 4
		},
		physics = {
			gravity = 0.1,
			drag = 40,
			speed = 2,
			velocity = {
				x = 0,
				y = 0
			}
		}
	}
end

Projectile.spawn = function(force)
	local p = Projectile.getPrefab()
	p.physics.velocity.x = force.x
	p.physics.velocity.y = force.y
	table.insert(Projectile.objects, p)
end

Projectile.draw = function()
	love.graphics.setColor(255,255,255)
	for _, p in pairs(Projectile.objects) do
		love.graphics.draw(
			Projectile.sprite,
			love.math.newTransform(
				p.transform.x,
				p.transform.y,
				p.transform.r,
				p.transform.sX,
				p.transform.sY
			)
		)
	end
end

Projectile.update = function()
	for _, p in pairs(Projectile.objects) do
	    if p.transform.y > Window.h - p.transform.h * p.transform.sY or p.transform.y < 0 then
	    	p.physics.velocity.y = -p.physics.velocity.y
	    end

	    if p.transform.x > Window.w - p.transform.w * p.transform.sX or p.transform.x < 0 then
	    	p.physics.velocity.x = -p.physics.velocity.x
	    end

	    p.transform.y = p.transform.y + p.physics.velocity.y
	    p.transform.x = p.transform.x + p.physics.velocity.x


		if Colliders.isCollidingWith(Player.transform, p.transform)
			and not Player.hit.invincible then
			Player.takeDamage(5)
		end
	end

	Projectile.spawnTimer = Projectile.spawnTimer + 1

	if Projectile.spawnTimer > Projectile.spawnTimerMax then
		Projectile.spawn({x = 2, y = 2})
		Projectile.spawnTimer = 0
	end
end
