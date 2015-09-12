local panel = require "panel"

WIDTH, HEIGHT = love.graphics.getDimensions()

function px(x)
  return (x * WIDTH) / 100
end

function py(y)
  return (y * HEIGHT) / 100
end

function love.load()
  local drawButtons = {"1", "2", "3", "4", "5"}
  local drawPanelColor = {r=100,b=200,g=100,a=255}
  drawPanel = Panel.new("draw", 10, 10, drawButtons, false, px(15), py(5), drawPanelColor)
end

function love.update(dt)
  drawPanel:update(dt)

end

function love.draw()
  drawPanel:draw()
end
