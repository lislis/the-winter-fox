
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
	stage.next.y = 0

	things = {}
	things.attributes = {'collect', 'evade', 'jump'}
	things.count = 5
	things.allthe = {}

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
	game.speed = 10
	game.time = 0


end

function distance(pt1, pt2)
	return math.sqrt((pt1[1] - pt2[1]) ^ 2 + (pt1[2] - pt2[2]) ^2)
end


function love.update(dt)

end

function love.draw()

	if currentState == 'play' then

		love.graphics.draw(stage.bg['level' .. game.level], 0, 0)
		love.graphics.setColor(50,50,50)
		for i=0, stage.lanesCount do
			love.graphics.line(stage.lanesWidth + (i * stage.lanesWidth),0, stage.lanesWidth + (i * stage.lanesWidth), stage.stageH)
		end

	end


end