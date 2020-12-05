-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()


local backGroup 
local mainGroup 

-- include Corona's "physics" library
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0)

-- Activate multitouch
system.activate( "multitouch" )

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH = display.actualContentWidth, display.actualContentHeight
local halfW, halfH = display.contentCenterX, display.contentCenterY

local function dragBat( event )
 
    local bat = event.target
    local phase = event.phase

 	if ( "began" == phase ) then
        -- Set touch focus on the bat
        display.currentStage:setFocus( bat )
        -- Store initial offset position
        bat.touchOffsetX = event.x - bat.x
        bat.touchOffsetY = event.y - bat.y
 
    elseif ( "moved" == phase )
	then 
    	if(bat.name == 'Green' and event.y - bat.touchOffsetY < ((display.contentHeight/2) - 50)) then
        -- Move the bat to the new touch position
        	bat.x = event.x - bat.touchOffsetX
       		bat.y = event.y - bat.touchOffsetY
    	elseif(bat.name == 'Red' and event.y - bat.touchOffsetY > ((display.contentHeight/2) + 50) )then 
    		bat.x = event.x - bat.touchOffsetX
        	bat.y = event.y - bat.touchOffsetY
    	end

    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the bat
        display.currentStage:setFocus( nil )
    end
    
    return true  -- Prevents touch propagation to underlying objects

end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )
	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( backGroup, display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .21, 0.58, 1)
	
	local Table = display.newImageRect( backGroup, 'Image/table.png', 910/4, 1617/4)
	Table.x = halfW
	Table.y = halfH
	
	local ball = display.newImageRect( mainGroup, 'Image/ball.png', 219/9, 225/9 )
	ball.x = halfW
	ball.y = halfH 

	local redBat = display.newImageRect( mainGroup, 'Image/redBat.png', 410/8, 600/8)
	redBat.x = halfW
	redBat.y = halfH + 100
	redBat.name = 'Red'

	redBat:addEventListener( "touch", dragBat )

	local greenBat = display.newImageRect(mainGroup, 'Image/greenBat.png', 416/8, 620/8)
	greenBat.x = halfW
	greenBat.y = halfH - 100
	greenBat.name = 'Green'

	greenBat:addEventListener( "touch", dragBat )

	-- all display objects must be inserted into group


end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene