--Script Information----------------------------------------------------------------------------------------------------------------------
--Version: 1.6
--Created by: Rost
--For Support:
     --Discord: Rost#6764
     --Ingame: RostNerd
--GitHub: https://github.com/RostCS/DU-FuelScreen

--Script Configuration--------------------------------------------------------------------------------------------------------------------

--Debug Mode(prints extra values to help with troubleshooting) -- Default: false
debug = false

--Tank Type Order -- Default: 1
--1 - Space,Atmo,Rocket
--2 - Space,Rocket,Atmo
--3 - Atmo,Space,Rocket
--4 - Atmo,Rocket,Space
--5 - Rocket,Space,Atmo
--6 - Rocket,Atmo,Space
tankOrder = 1

--Player Distance controlled updates -- Default: false
--If the player that activated the script walks out of range of the programming board, the script will disable
--If you are using a detection zone to control the PB, this setting should be disabled
playerToggle = false --export: Enable if not using a detection zone

--Hides the widget in the bottom right -- Default: true
hideWidget = true

--Update Speed(rate at which the screen updates in seconds -- Default: 1
updateSpeed = 1

--
--Look and feel section. Update below to change the colors and the look of the display.
--

--Show the Percent Filled next to the bar -- Default: true
showPercents = true

--Header Text
windowName = "Fuel Management" 

--Background Color -- Default: #2f343d
backgroundColor = "#2f343d" 

--Bar Border Color -- Default: white
borderColor = "white" 

--Header Text Color -- Default: white
headerColor = "white" 

--Space Text Color -- Default: orange
spaceNameColor = "orange" 

--Space Bar Color -- Default: orange
spaceBarColor = "orange" 

--Space Percent Color -- Default: white
spacePercentColor = "white"

--Atmo Text Color -- Default: 34b1eb
atmoNameColor = "#34b1eb" 

--Atmo Bar Color -- Default: 34b1eb
atmoBarColor = "#34b1eb" 

--Atmo Percent Color -- Default: white
atmoPercentColor = "white"

--Rocket Text Color -- Default: 6e3de3
rocketNameColor = "#6e3de3"

--Rocket Bar Color -- Default: 6e3de3
rocketBarColor = "#6e3de3" 

--Rocket Percent Color -- Default: white
rocketPercentColor = "white"

--Script Configuration Done--Modifications beyond here are at your own risk--
------------------------------------------------------------------------------------------------------------------    
function insertionSort(array)-- Basic insertion sort algorithm used to sort the spaceTanks and atmoTanks arrays
    local len = #array
    local j
    for j = 2, len do
        local key = array[j]
        local i = j - 1 --The line below sorts the array using the name field of the tank for consistent results
        while i > 0 and json.decode(array[i].getData()).name > json.decode(key.getData()).name do
            array[i + 1] = array[i]
            i = i - 1
        end
        array[i + 1] = key
    end
    return array
end

atmoTanks = {} -- This array contains a list of all the atmospheric tanks with a link to the PB

for key, value in pairs(unit) do
  if type(value) == "table" and type(value.export) == "table" then -- `value` is an element and `key` is the slot name
    if value.getElementClass then --if it has a class
      if value.getElementClass() == "AtmoFuelContainer" then --if it's an atmo tank
          atmoTanks[#atmoTanks + 1] = value
      end
    end
  end
end 


atmoTanks = insertionSort(atmoTanks)
--We're required to sort the atmoTanks array, as the code that gets it is not consistent, and
--due to some unknown value, the order of the tanks is randomized.
--by sorting the array by the name of the tank, we can verify a consistent order every time

spaceTanks = {} -- This array contains a list of all the space tanks with a link to the PB

for key, value in pairs(unit) do
  if type(value) == "table" and type(value.export) == "table" then -- `value` is an element and `key` is the slot name
    if value.getElementClass then --if it has a class
      if value.getElementClass() == "SpaceFuelContainer" then --if it's a space tank
           spaceTanks[#spaceTanks + 1] = value 
      end
    end
  end
end 

spaceTanks = insertionSort(spaceTanks)
--We're required to sort the spaceTanks array, as the code that gets it is not consistent, and
--due to some unknown value, the order of the tanks is randomized.
--by sorting the array by the name of the tank, we can verify a consistent order every time

rocketTanks = {} -- This array contains a list of all the rocket tanks with a link to the PB

for key, value in pairs(unit) do
  if type(value) == "table" and type(value.export) == "table" then -- `value` is an element and `key` is the slot name
    if value.getElementClass then --if it has a class
      if value.getElementClass() == "RocketFuelContainer" then --if it's a rocket tank
           rocketTanks[#rocketTanks + 1] = value 
      end
    end
  end
end 

rocketTanks = insertionSort(rocketTanks)
--We're required to sort the rocketTanks array, as the code that gets it is not consistent, and
--due to some unknown value, the order of the tanks is randomized.
--by sorting the array by the name of the tank, we can verify a consistent order every time

screens = {}

for key, value in pairs(unit) do
  if type(value) == "table" and type(value.export) == "table" then -- `value` is an element and `key` is the slot name
    if value.getElementClass then -- if it has a class
      if value.getElementClass() == "ScreenUnit" then --if it's a screen
           screens[#screens + 1] = value
      end
    end
  end
end 

if debug then
    system.print('Number of Screens: '..#screens)
    system.print('Number of Space Tanks: '..#spaceTanks)
    system.print('Number of Atmospheric Tanks: '..#atmoTanks)
    system.print('Number of Rocket Tanks: '..#rocketTanks)
end

if hideWidget then
    unit.hide()
else
    unit.show()
end


unit.setTimer('updateFuelDisplay',updateSpeed)