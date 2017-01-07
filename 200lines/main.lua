debug = true
playerImg = nil
player = {x = 0, y = 0, speed = 150, img = nil}
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil

enemies = {}

isAlive = true
score = 0

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load(arg)
	player.img = love.graphics.newImage('assets/plane.png')
	player.x = (love.graphics.getWidth() - player.img:getWidth()) / 2
	player.y = love.graphics.getHeight() - player.img:getHeight()
	bulletImg = love.graphics.newImage('assets/bullet.png')
	enemyImg = love.graphics.newImage('assets/enemy.png')
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	if love.keyboard.isDown('left', 'a') then
		if player.x > 0 then
			player.x = player.x - player.speed*dt
		end
	elseif love.keyboard.isDown('right', 'd') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + player.speed*dt
		end
	end

	canShootTimer = canShootTimer - (1*dt)
	canShoot = canShootTimer < 0

	if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
		newBullet = {x = player.x + player.img:getWidth()/2, y = player.y, img = bulletImg}
		table.insert(bullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250*dt)

		if bullet.y < 0 then
			table.remove(bullets, i)
		end
	end

	-- Time out enemy creation
	createEnemyTimer = createEnemyTimer - (1 * dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax

		-- Create an enemy
		randomNumber = math.random(10, love.graphics.getWidth() - enemyImg:getWidth())
		newEnemy = { x = randomNumber, y = -enemyImg:getHeight(), img = enemyImg }
		table.insert(enemies, newEnemy)
	end

	-- update the positions of enemies
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (200 * dt)

		if enemy.y > love.graphics.getHeight() then -- remove enemies when they pass off the screen
			table.remove(enemies, i)
		end
	end

	-- run our collision detection
	-- Since there will be fewer enemies on screen than bullets we'll loop them first
	-- Also, we need to see if the enemies hit our player
	for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end

		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
		and isAlive then
			table.remove(enemies, i)
			isAlive = false
		end
	end

	if not isAlive and love.keyboard.isDown('r') then
		bullets = {}
		enemies = {}
		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax

		player.x = (love.graphics.getWidth() - player.img:getWidth()) / 2
		player.y = love.graphics.getHeight() - player.img:getHeight()

		score = 0
		isAlive = true
	end
end

function love.draw(dt)

	love.graphics.print("Score: " .. score)

	if isAlive then
		love.graphics.draw(player.img, player.x, player.y)
	else 
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2 - 50, love.graphics:getHeight()/2 -10)
	end

	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y, 0, 1, -1)
	end

end