
states = {'intro', 'play', 'lose', 'win'}

currentState = 'play'

timer = 0
foxTimer = 0

function love.load()

	stage = {}
	stage.lanesCount = 4
	stage.stageW = love.graphics.getWidth()
	stage.stageH = love.graphics.getHeight()
	stage.lanesWidth =  stage.stageW / (stage.lanesCount + 2)
	stage.bg = {}
	stage.bg.level1 =  love.graphics.newImage("assets/level1.png")
	stage.bg.level2 =  love.graphics.newImage("assets/level2.png")
	stage.bg.level3 =  love.graphics.newImage("assets/level3.png")
	stage.currentY = 0
	stage.next = {}
	stage.next.bg = stage.bg.level1
	stage.next.y = - stage.stageH

	things = {}
	things.attributes = {'collect', 'evade', 'jump'}
	things.img = {}
	things.img.collect = love.graphics.newImage('assets/thing.jpg')
	things.img.evade = love.graphics.newImage('assets/thing.jpg')
	things.img.jump = love.graphics.newImage('assets/thing.jpg')
	things.count = 5
	things.allthe = {}

	for i = 1, things.count do 

		things.allthe[i] = {}
		things.allthe[i].lane = math.random(stage.lanesCount)
		things.allthe[i].attr = things.attributes[math.random(3)] -- only works because we have as many attributes as lanes
		things.allthe[i].w = 50 --magic
		things.allthe[i].h = 50 --magic
		things.allthe[i].y = - things.allthe[i].h
		things.allthe[i].img = things.img[things.allthe[i].attr]
		things.allthe[i].onstage = false

		if i == 1 then
			things.allthe[i].onstage = true
		end

	end

	fox = {}
	fox.lane = 2 -- magic
	fox.stats = {}
	fox.stats.w = 50 --stage.lanesWidth
	fox.stats.h = stage.stageH - 100
	fox.stats.x = stage.lanesWidth * fox.lane + fox.stats.w-- stage.stageW / 2 - (fox.stats.w / 2)
	fox.stats.y = fox.stats.h
	fox.states = {'walking', 'changing', 'jumping'}
	fox.state = 'walking'
	fox.img = love.graphics.newImage('assets/fox.jpg')

	game = {}
	game.level = 1
	game.score = 0
	game.speed = 0.5
	game.time = 0
	game.spawntime = 3


end

function love.update(dt)

	updateBackground()
	updateThings()
	updateFox(dt)

	timer = timer + dt
	if timer >= game.spawntime then
		spawnThings()
		timer = 0
	end

end

function love.draw()

	if currentState == 'play' then
		drawBackground()
		drawThings()
		drawFox()
	end

end

-- -------------------------------------------------------

function collisionDetection(thingY, thingH)
	
	if fox.stats.y - (thingY + thingH) >= 0 then
		return false
	else
		return true
	end
end


function foxCollide()

	for i = 1, things.count do
		if things.allthe[i].onstage == true then

			if things.allthe[i].lane == fox.lane then

				isColliding = collisionDetection(things.allthe[i].y, things.allthe[i].h)

				if isColliding then
					-- what is the attribute
					print('collide')
					if  then
					end
				end

			end
		end
	end
end


function love.keypressed(key, isrepeat)
	if key == ' ' then
		foxJump()
	elseif key == 'left' then
		foxLeft()
	elseif key == 'right' then
		foxRight()
	end
end

function foxJump()
	fox.state = 'jumping'
end

function foxLeft()

	fox.state = 'changing'
	if fox.lane <= 1 then
		fox.lane = fox.lane
	else
		fox.lane = fox.lane - 1
	end
end

function foxRight()

	fox.state = 'changing'
	if fox.lane >= 4 then
		fox.lane = fox.lane
	else
		fox.lane = fox.lane + 1
	end
end

function updateFox(dt)

	fox.stats.x = stage.lanesWidth * fox.lane + fox.stats.w

	if fox.state ~= 'walking' then
		foxTimer = foxTimer + dt
		if foxTimer >= .8 then
			foxTimer = 0
			fox.state = 'walking'
		end
	end

	foxCollide()

end

function drawFox()

	if fox.state == 'changing' then
		love.graphics.draw(fox.img, fox.stats.x, fox.stats.y)
	elseif fox.state == 'jumping' then
		love.graphics.draw(fox.img, fox.stats.x, fox.stats.y)
	else
		love.graphics.draw(fox.img, fox.stats.x, fox.stats.y)
	end

end

function spawnThings()
	for i = 1, things.count do

		if things.allthe[i].onstage	== false then
			if math.random(1, 10) > 3 then
				things.allthe[i].lane = math.random(stage.lanesCount)
				things.allthe[i].attr = things.attributes[math.random(3)] -- 3 attributes
				things.allthe[i].img = things.img[things.allthe[i].attr]
				things.allthe[i].onstage = true

				print(things.allthe[i].attr)
			end
		end
	end
end

function drawThings()
	for i = 1, things.count do

		if things.allthe[i].onstage	== true then
			love.graphics.draw(things.allthe[i].img, (stage.lanesWidth * things.allthe[i].lane) + (things.allthe[i].w / 2), things.allthe[i].y)
		end
	end
end

function updateThings()

	for i = 1, things.count do 

		if things.allthe[i].onstage == true then
			things.allthe[i].y = things.allthe[i].y + game.speed
			if things.allthe[i].y > stage.stageH then
				things.allthe[i].y = - things.allthe[i].h
				things.allthe[i].onstage = false
			end
		end
	end
end

function updateBackground()
	stage.currentY = stage.currentY + game.speed
	stage.next.y = stage.next.y + game.speed

	if stage.currentY > stage.stageH then
		stage.currentY = - stage.stageH
	end
	if stage.next.y > stage.stageH then
		stage.next.y = - stage.stageH
	end
end

function drawBackground()
	love.graphics.draw(stage.bg['level' .. game.level], 0, stage.currentY)
	love.graphics.draw(stage.next.bg, 0, stage.next.y)
	love.graphics.setColor(50,50,50)
	for i=0, stage.lanesCount do
		love.graphics.line(stage.lanesWidth + (i * stage.lanesWidth),0, stage.lanesWidth + (i * stage.lanesWidth), stage.stageH)
	end
end