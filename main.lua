loveframes = require "lib.loveframes"
require "lib.widgets"
WIDTH, HEIGHT = love.graphics.getDimensions()

function px(x)
  return (x * WIDTH) / 100
end

function py(y)
  return (y * HEIGHT) / 100
end

function love.load()
  love.window.setTitle("Linear")
  love.graphics.setBackgroundColor(200,200,200)
end

function love.update(dt)
  loveframes.update(dt)
end

function love.draw()
  loveframes.draw()
end

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

function love.keyreleased(key)
	loveframes.keyreleased(key)
end

function love.textinput(text)
	loveframes.textinput(text)
end
