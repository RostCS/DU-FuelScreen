--Configuration for this script can be found in the start() function in the menu to your left
--Edit code in this section at your own risk

local function getFuelSVG(fuelTanks, tankColor)
    local fuelPercents = {}
    local returnSVG=[[]]
    local percent = [[]]
    for i=1,#fuelTanks,1 do
        fuelPercents[i] = 1890*((json.decode(fuelTanks[i].getData()).percentage)/100)
        if showPercents then
            if fuelPercents[i]>200 then
            	percent = [[<text x="]]..(fuelPercents[i]-145)..[["y="]]..135+((.43)*barAndTextHeight)+(numBars*barAndTextHeight)..[[" font-size="60" text-anchor="start" fill="]]..spacePercentColor..[[">]]..json.decode(fuelTanks[i].getData()).percentage..[[%</text>]]
            else
                 percent = [[<text x="]]..(fuelPercents[i]+25)..[["y="]]..135+((.43)*barAndTextHeight)+(numBars*barAndTextHeight)..[[" font-size="60" text-anchor="start" fill="]]..spacePercentColor..[[">]]..json.decode(fuelTanks[i].getData()).percentage..[[%</text>]]
            end
        else
            percent = [[]]
        end
        local tankName = json.decode(fuelTanks[i].getData()).name		
        returnSVG = returnSVG..[[<text x="15" y="]]..120+(numBars * barAndTextHeight)..[[" font-size="40" text-anchor="start" fill="]]..tankColor..[[">]]..tankName..[[</text>
		                     <rect x="15" y="]]..135+(numBars * barAndTextHeight)..[[" width="]]..fuelPercents[i]..[[" height="]]..(barAndTextHeight-60)..[[" fill="]]..tankColor..[[" stroke-width="0"/>
        				  <rect x="15" y="]]..135+(numBars * barAndTextHeight)..[[" width="1890" height="]]..(barAndTextHeight-60)..[[" fill="]]..backgroundColor..[[" fill-opacity="0" stroke="]]..borderColor..[[" stroke-width="5"/>
        				  ]]..percent..[[]]
        numBars = numBars+1
    end
    return returnSVG
end

local function getBarSVG()
	--1 - Space,Atmo,Rocket
	--2 - Space,Rocket,Atmo
	--3 - Atmo,Space,Rocket
	--4 - Atmo,Rocket,Space
	--5 - Rocket,Space,Atmo
	--6 - Rocket,Atmo,Space
    if tankOrder == 2 then
        return getFuelSVG(spaceTanks, spaceNameColor)..getFuelSVG(atmoTanks, atmoNameColor)..getFuelSVG(rocketTanks, rocketNameColor)
    elseif tankOrder == 3 then
        return getFuelSVG(atmoTanks, atmoNameColor)..getFuelSVG(spaceTanks, spaceNameColor)..getFuelSVG(rocketTanks, rocketNameColor)
    elseif tankOrder == 4 then
        return getFuelSVG(atmoTanks, atmoNameColor)..getFuelSVG(rocketTanks, rocketNameColor)..getFuelSVG(spaceTanks, spaceNameColor)
    elseif tankOrder == 5 then
        return getFuelSVG(rocketTanks, rocketNameColor)..getFuelSVG(spaceTanks, spaceNameColor)..getFuelSVG(atmoTanks, atmoNameColor)
    elseif tankOrder == 6 then
        return getFuelSVG(rocketTanks, rocketNameColor)..getFuelSVG(atmoTanks, atmoNameColor)..getFuelSVG(spaceTanks, spaceNameColor)
    else
        return getFuelSVG(spaceTanks, spaceNameColor)..getFuelSVG(atmoTanks, atmoNameColor)..getFuelSVG(rocketTanks, rocketNameColor)
    end
end
    
local function update()
    if playerToggle then
        playerDistance = vec3(unit.getMasterPlayerRelativePosition()):len()
    else
        playerDistance = 0
    end
    
    if(playerDistance < 200) then
        barAndTextHeight = (1120-120)/(#spaceTanks + #atmoTanks + #rocketTanks)
        numBars=0
        bars = getBarSVG()

        svg = [[<svg class="bootstrap" viewBox="0 0 1920 1120" style="width:100%; height:100%"><svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg">
  
	           <rect width="100%" height="100%" fill="]]..backgroundColor..[[" />

 	           <text x="15" y="55" font-size="60" text-anchor='start' fill="]]..headerColor..[[">]]..windowName..[[</text>
    
 	           <line x1="0" x2="1920" y1="75" y2="75" stroke="]]..borderColor..[[", fill="]]..borderColor..[["/>
	
                ]]..bars..[[

	           </svg></svg>]]

	   for i=1,#screens,1 do
     	   screens[i].setSVG(svg)
	   end
    end
end

update()
