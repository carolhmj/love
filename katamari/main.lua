player = {
	xPos = 320,
	yPos = 320,

	xVel = 0,
	yVel = 0,
	acc = 0.5,
	maxSpeed = 100,
	friction = 75,

	epsilon = 10^-2,

	size = 48,

	img = nil 
}

function love.load()

end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	end
end

function love.update(dt)

	player.xPos = player.xPos + player.xVel * dt
	player.yPos = player.yPos + player.yVel * dt

	-- Left/Right movement
	if love.keyboard.isDown("left", "a") and player.xVel > -player.maxSpeed then
		player.xVel = player.acc * -player.maxSpeed + (1-player.acc) * player.xVel
	elseif love.keyboard.isDown("right", "d") and player.xVel < player.maxSpeed then
		player.xVel = player.acc * player.maxSpeed + (1-player.acc) * player.xVel
	end

	if math.abs(player.xVel) < player.epsilon then
		player.xVel = 0
	elseif player.xVel > 0 then
		player.xVel = player.xVel - player.friction * dt
	elseif player.xVel < 0 then
		player.xVel = player.xVel + player.friction * dt
	end

	-- Up/Down movement
	if love.keyboard.isDown("down", "s") and player.xVel > -player.maxSpeed then
		player.yVel = player.acc * player.maxSpeed + (1-player.acc) * player.yVel
	elseif love.keyboard.isDown("up", "w") and player.yVel < player.maxSpeed then
		player.yVel = player.acc * -player.maxSpeed + (1-player.acc) * player.yVel
	end

	if math.abs(player.yVel) < player.epsilon then
		player.yVel = 0
	elseif player.yVel > 0 then
		player.yVel = player.yVel - player.friction * dt
	elseif player.yVel < 0 then
		player.yVel = player.yVel + player.friction * dt
	end

end

function love.draw(dt)
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle('fill', player.xPos, player.yPos, player.size)
	love.graphics.printf("x pos: " .. player.xPos .. "  y pos: " .. player.yPos .. " x vel:" .. player.xVel .. "  y vel: " .. player.yVel , 0, 0, 640)
end