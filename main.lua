
states = {'intro', 'play', 'lose', 'win'}

currentState = 'play'

function love.load()

	stage = {}
	stage.lanesCount = 3
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
		things.allthe[i].attr = things.attributes[math.random(stage.lanesCount)] -- only works because we have as many attributes as lanes
		things.allthe[i].y = 0
		things.allthe[i].w = 50 --magic
		things.allthe[i].img = things.img[things.allthe[i].attr]
		things.allthe[i].onstage = false

		if i == 1 then
			things.allthe[i].onstage = true
		end

	end

	fox = {}
	fox.stats = {}
	fox.stats.w = stage.lanesWidth
	fox.stats.h = 50
	fox.stats.x = stage.stageW / 2 - (fox.stats.w / 2)
	fox.stats.y = fox.stats.h
	fox.state = {'walking', 'changing', 'jumping'}

	game = {}
	game.level = 1
	game.score = 0
	game.speed = 0.5
	game.time = 0


end

function distance(pt1, pt2)
	return math.sqrt((pt1[1] - pt2[1]) ^ 2 + (pt1[2] - pt2[2]) ^2)
end


function love.update(dt)

	updateBackground()
	updateThings()

end

function love.draw()

	if currentState == 'play' then
		drawBackground()
		drawThings()
	end

end

-- -------------------------------------------------------

function drawThings()
	for i = 1, things.count do

		if things.allthe[i].onstage	== true then
			love.graphics.draw(things.allthe[i].img, stage.lanesWidth + (stage.lanesWidth * things.allthe[i].lane) - (things.allthe[i].w / 2), things.allthe[i].y)
		end
	end
end

function updateThings()

	for i = 1, things.count do 

		if things.allthe[i].onstage == true then
			print(stage.lanesWidth + (stage.stageW * things.allthe[i].lane) - (things.allthe[i].w / 2))
			things.allthe[i].y = things.allthe[i].y + game.speed
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