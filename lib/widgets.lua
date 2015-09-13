-- widgets library
widgets = {}
frames = {}
currentFrame = 0
WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()
theImage = nil
widgets.playing = false

function widgets.getImage()
  return theImage
end

function widgets.nextImage()
  if currentFrame == #frames then
    widgets.stop()
    return nil
  else
    updateFrame(currentFrame + 1)
    scrubber:SetValue(currentFrame)
  end
end

function widgets.stop()
  widgets.playing = false
  playButton:SetText("Play")
end

function widgets.Load()
  widgets.CreateToolbar()
end

function widgets.CreateToolbar()
  local width = love.graphics.getWidth()
  local stage = loveframes.stage
  local toolbar = loveframes.Create("panel")

  toolbar:SetSize(width, 35)
  toolbar:SetPos(0,0)

  widgets.drawtoolsbutton = loveframes.Create("button", toolbar)
  widgets.drawtoolsbutton:SetPos(20,5)
  widgets.drawtoolsbutton:SetSize(100,25)
  widgets.drawtoolsbutton:SetText("Drawing tools")
  widgets.drawtoolsbutton.OnClick = function()
    widgets.ToggleDrawTools()
  end

  widgets.animbrowserbutton = loveframes.Create("button", toolbar)
  widgets.animbrowserbutton:SetPos(140,5)
  widgets.animbrowserbutton:SetSize(100,25)
  widgets.animbrowserbutton:SetText("Anim browser")
  widgets.animbrowserbutton.OnClick = function()
    widgets.ToggleAnimBrowser()
  end

  widgets.timelinebutton = loveframes.Create("button", toolbar)
  widgets.timelinebutton:SetPos(260,5)
  widgets.timelinebutton:SetSize(100,25)
  widgets.timelinebutton:SetText("Timeline")
  widgets.timelinebutton.OnClick = function()
    widgets.ToggleTimeline()
  end
end

function widgets.ToggleAnimBrowser()
  -- local toggled = widgets.animbrowser.toggled
  local animBrowser = loveframes.Create("frame")
  local width = love.graphics.getWidth()
  animBrowser:SetName("Animations")
  animBrowser:SetSize(250,300)
  animBrowser:SetPos(width - animBrowser:GetWidth(), 70)

  local textForm = loveframes.Create("form", animBrowser)
  textForm:SetName("Anims Folder")
  textForm:SetPos(5,25)
  -- textForm:SetSize(animBrowser:GetWidth() - 10, 40)
  textForm:SetLayoutType("horizontal")

  local textInput = loveframes.Create("textinput")
  textInput:SetWidth(175)
	textInput.OnEnter = function(object)
		if not textInput.multiline then
			object:Clear()
		end
	end
	textInput:SetFont(love.graphics.newFont(12))
  textInput:SetText("anims")

  textForm:AddItem(textInput)

  local loadButton = loveframes.Create("button")
  loadButton:SetWidth(50)
  loadButton:SetText("load")
  textForm:AddItem(loadButton)
  loadButton.OnClick = function()
    widgets.LoadDir(textInput:GetText())
  end

	animList = loveframes.Create("list", animBrowser)
	animList:SetPos(5, 70)
	animList:SetSize(animBrowser:GetWidth()- 10, animBrowser:GetHeight() - 75)
	animList:SetPadding(5)
	animList:SetSpacing(5)

  widgets.LoadDir(textInput:GetText())

end

function showError(message)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local errorModal = loveframes.Create("frame")
  errorModal:SetModal(true)
  errorModal:SetName("Error")
  errorModal:SetSize(200, 100)
  errorModal:SetPos(width / 2 - 200, height / 2 - 100)

  local errorMsg = loveframes.Create("text", errorModal)
  errorMsg:SetText(message)
  errorMsg:Center()
end

function widgets.AddFrames(path)
  local files = love.filesystem.getDirectoryItems(path)
  for i = 1, #files  do
    local file = path .. '/' .. files[i]
    local ext = file:sub(file:len() - 2,file:len())
      if ext == "png" then
        local img = love.graphics.newImage(file)
        table.insert(frames,img)
      end
  end
  resetCounter(#frames)
end

function widgets.LoadDir(dir)

  animList:Clear()

  if love.filesystem.isDirectory(dir) then
    local dirs = love.filesystem.getDirectoryItems(dir)
    for i = 1, #dirs do
      if love.filesystem.isDirectory(dir .. '/' .. dirs[i]) then
        if dirs[i]:sub(1,1) ~= '.' then
          local btn = loveframes.Create("button")
          btn:SetText(dirs[i])
          btn.OnClick = function ()
            widgets.AddFrames(dir .. '/' .. dirs[i])
          end
          animList:AddItem(btn)
        end
      end
    end
  else
    showError("Error: not a directory.")
  end
end


function widgets.ToggleDrawTools()
  -- local toggled = widgets.drawtools.toggled
  local drawTools = loveframes.Create("frame")
  drawTools:SetName("Drawing")
  drawTools:SetSize(110,330)
  drawTools:SetPos(0,70)

	local toolsList = loveframes.Create("list", drawTools)
	toolsList:SetPos(5, 30)
	toolsList:SetSize(100, 295)
	toolsList:SetPadding(5)
	toolsList:SetSpacing(5)

  local fillColor = {255, 0, 0, 255}
  local lineColor = {0, 0, 0, 255}

	local colorbox = loveframes.Create("panel", toolsList)
	colorbox:SetPos(5, 30)
	colorbox:SetSize(10, 10)
	colorbox.Draw = function(object)
		love.graphics.setColor(fillColor)
		love.graphics.rectangle("fill", object:GetX(), object:GetY(), object:GetWidth(), object:GetHeight())
		love.graphics.setColor(lineColor)
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("smooth")
		love.graphics.rectangle("line", object:GetX(), object:GetY(), object:GetWidth(), object:GetHeight())
	end

  local colorButton = loveframes.Create("button", toolsList)
  colorButton:SetText("Color")
  local drawButton = loveframes.Create("button", toolsList)
  drawButton:SetText("Draw")
  local groupButton = loveframes.Create("button", toolsList)
  groupButton:SetText("Group")
  local editButton = loveframes.Create("button", toolsList)
  editButton:SetText("Edit")

  local editGroup = {}
  local shapesRadio = loveframes.Create("radiobutton", toolsList)
  shapesRadio:SetText("Shapes")
  shapesRadio:SetGroup(editGroup)
  -- shapesRadio:SetSelected(true)
  local pointsRadio = loveframes.Create("radiobutton", toolsList)
  pointsRadio:SetText("Points")
  pointsRadio:SetGroup(editGroup)

end

function widgets.ToggleTimeline()
  -- local toggled = widgets.timeline.toggled
  local timeline = loveframes.Create("frame")
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  timeline:SetName("Timeline")
  timeline:SetSize(width, 65)
  timeline:SetPos(0, height - 65)

  playButton = loveframes.Create("button", timeline)
  playButton:SetText("Play")
  playButton:SetPos(5,30)
  playButton:SetWidth(40)
  local startButton = loveframes.Create("button", timeline)
  startButton:SetText("|<")
  startButton:SetPos(50,30)
  startButton:SetWidth(20)
  local endButton = loveframes.Create("button", timeline)
  endButton:SetText(">|")
  endButton:SetPos(75,30)
  endButton:SetWidth(20)
  local prevButton = loveframes.Create("button", timeline)
  prevButton:SetText("<")
  prevButton:SetPos(100,30)
  prevButton:SetWidth(20)
  local nextButton = loveframes.Create("button", timeline)
  nextButton:SetText(">")
  nextButton:SetPos(125,30)
  nextButton:SetWidth(20)

  scrubber = loveframes.Create("slider", timeline)
  scrubber:SetWidth(width - 220)
  scrubber:SetPos(150, 32)
  scrubber:SetDecimals(0)
  scrubber:SetMinMax(1, #frames)
  scrubber.OnValueChanged = function(object, value)
    updateFrame(value)
  end
  startButton.OnClick = function()
    updateFrame(1)
    scrubber:SetValue(1)
  end
  endButton.OnClick = function()
    updateFrame(#frames)
    scrubber:SetValue(#frames)
  end
  prevButton.OnClick = function()
    local prevFrame = currentFrame - 1
    if prevFrame >= 0 then
      updateFrame(prevFrame)
      scrubber:SetValue(prevFrame)
    end
  end
  nextButton.OnClick = function()
    local nextFrame = currentFrame + 1
    if nextFrame <= #frames then
      updateFrame(nextFrame)
      scrubber:SetValue(nextFrame)
    end
  end

  playButton.OnClick = function()
    if widgets.playing then
      widgets.playing = false
      playButton:SetText("Play")
    else
      widgets.playing = true
      playButton:SetText("Pause")
    end
  end

  frameCounter = loveframes.Create("text", timeline)
  frameCounter:SetText("0/0")
  frameCounter:SetPos(width - 60, 35)

end

function updateFrame(num)
  frameCounter:SetText(num .. "/" .. #frames)
  currentFrame = num
  theImage = frames[num]
end

function resetCounter(num)
  frameCounter:SetText("1/" .. num)
  scrubber:SetMinMax(1, num)
  theImage = frames[1]
end


widgets.Load()
