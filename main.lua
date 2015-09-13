loveframes = require "lib.loveframes"
require "lib.widgets"
WIDTH, HEIGHT = love.graphics.getDimensions()
elapsed = 0

function px(x)
  return (x * WIDTH) / 100
end

function py(y)
  return (y * HEIGHT) / 100
end

function love.load()
  love.window.setTitle("Linear")
	bgimage = love.graphics.newImage("bg.png")
  -- love.graphics.setBackgroundColor(200,200,200)
end

function love.update(dt)
  elapsed = elapsed + dt
  loveframes.update(dt)
  if widgets.playing then
    if elapsed > 1/30 then
        widgets.nextImage()
        elapsed = 0
    end
  end
  image = widgets.getImage()
  if image ~= nil then
    bgimage = image
  end
end

function love.draw()
	local scalex = WIDTH/bgimage:getWidth()
	local scaley = HEIGHT/bgimage:getHeight()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(bgimage, 0, 0, 0, scalex, scaley)
  loveframes.draw()
end

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, isrepeat)
	loveframes.keypressed(key, isrepeat)
end

function love.keyreleased(key)
	loveframes.keyreleased(key)
end

function love.textinput(text)
	loveframes.textinput(text)
end
