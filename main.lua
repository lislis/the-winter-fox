-- the winter fox
-- BerlinMiniJam November 2014

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
	stage.bg.level1 =  love.graphics.newImage("assets/bg.jpg")
	stage.bg.level2 =  love.graphics.newImage("assets/bg.jpg")
	stage.bg.level3 =  love.graphics.newImage("assets/bg.jpg")
	stage.currentY = 0
	stage.next = {}
	stage.next.bg = stage.bg.level1
	stage.next.y = - stage.stageH

	things = {}
	things.attributes = {'collect1', 'collect2', 'collect3', 'evade', 'jump'}
	things.img = {}
	things.img.collect1 = love.graphics.newImage('assets/apple.png')
	things.img.collect2 = love.graphics.newImage('assets/cheese.png')
	things.img.collect3 = love.graphics.newImage('assets/fish.png')
	things.img.evade = love.graphics.newImage('assets/bomb.png')
	things.img.jump = love.graphics.newImage('assets/shit.png')
	things.count = 20
	things.allthe = {}
	things.height = 60

	for i = 1, things.count do 

		things.allthe[i] = {}
		things.allthe[i].lane = math.random(1, 4)
		things.allthe[i].attr = things.attributes[math.random(5)] -- only works because we have as many attributes as lanes
		things.allthe[i].w = 55 --magic
		things.allthe[i].h = things.height
		things.allthe[i].y = - things.height
		things.allthe[i].img = things.img[things.allthe[i].attr]
		things.allthe[i].onstage = false

	end

	fox = {}
	fox.lane = 2 -- magic
	fox.stats = {}
	fox.stats.w = 35 --stage.lanesWidth
	fox.stats.h = 136
	fox.stats.x = stage.lanesWidth * fox.lane * 1.15
	fox.stats.y = stage.stageH - 140
	fox.states = {'walking', 'changing', 'jumping'}
	fox.state = 'walking'
	fox.img = love.graphics.newImage('assets/fox.png')

	game = {}
	game.level = 1
	game.score = 0
	game.speed = 6
	game.time = 0
	game.spawntime = 1

	sound = {}
	sound.collect = love.audio.newSource('sounds/collect.wav')
	sound.jump = love.audio.newSource('sounds/jump.wav')
	sound.dead = love.audio.newSource('sounds/dead.wav')
	sound.gameover = love.audio.newSource('sounds/game_over.wav')
	sound.start = love.audio.newSource('sounds/start.wav')
	sound.bg = love.audio.newSource('sounds/bg-sounds.wav')

	love.audio.play(sound.start)
	love.audio.play(sound.bg)
end

function love.update(dt)

	if currentState == 'play' then
		updateBackground()
		updateThings()
		updateFox(dt)

		timer = timer + dt
		if timer >= game.spawntime then
			spawnThings()
			timer = 0
		end

		if game.score > 30 then
			game.speed = 7
			game.spawntime = 0.5
		end
		if game.score > 50 then
			game.speed = 8
		end
	end
end

function love.draw()

	if currentState == 'play' then
		drawBackground()
		drawThings()
		drawFox()

		love.graphics.rectangle('fill',  stage.stageW - 120, 20, 100, 35)
		love.graphics.setColor(50, 50, 50)
		love.graphics.print( 'Score: '.. game.score, stage.stageW - 100, 30)

		love.graphics.setColor(255, 255, 255)
	elseif currentState == 'lose' then

		drawLost()

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
					if things.allthe[i].attr == 'collect1' then
						game.score = game.score + 1
						love.audio.play(sound.collect)
						things.allthe[i].onstage = false
					elseif things.allthe[i].attr == 'collect2' then
						game.score = game.score + 3
						love.audio.play(sound.collect)
						things.allthe[i].onstage = false
					elseif things.allthe[i].attr == 'collect3' then
						game.score = game.score + 5
						love.audio.play(sound.collect)
						things.allthe[i].onstage = false
					elseif things.allthe[i].attr == 'jump' and fox.state == 'jumping' then
						print('totally jumping')
					else
						love.audio.play(sound.dead)
						things.allthe[i].onstage = false
						currentState = 'lose'
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
	love.audio.play(sound.jump)
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

	fox.stats.x = stage.lanesWidth * fox.lane * 1.15

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
			if math.random(1, 10) > 2 then
				things.allthe[i].y = - things.height
				things.allthe[i].lane = math.random(4)
				things.allthe[i].attr = things.attributes[math.random(5)] -- 3 attributes
				things.allthe[i].img = things.img[things.allthe[i].attr]
				things.allthe[i].onstage = true
				break
			end
		end
	end
end

function drawThings()
	for i = 1, things.count do

		if things.allthe[i].onstage	== true then
			love.graphics.draw(things.allthe[i].img, (stage.lanesWidth * things.allthe[i].lane) * 1.15, things.allthe[i].y)
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
	
	--for i=0, stage.lanesCount do
		--love.graphics.line(stage.lanesWidth + ((i * 1.3) * stage.lanesWidth),0, stage.lanesWidth + ((i * 1.3) * stage.lanesWidth), stage.stageH)
	--end
end

function drawLost()
	love.audio.stop()
	love.graphics.print( 'You lose', 50, 50)
	love.graphics.print( 'You made ' .. game.score ..' points', 50, 80)
	love.audio.play(sound.gameover)
end