-- For those that want a logo or some info to display when the script is done
-- add your graphics or html in the appropriate variable within the [[ brackets ]].
-- SVG only data has precedence over HTML Data, so use only one!

local htmlData = [[]]
local svgData = [[]]

for i=1,#screens,1 do
    if htmlData or svgData then
        if htmlData then
            screens[i].setHTML(htmlData)
        end
        if svgData then
            screens[i].setSVG(svgData)
        end
    else
        screens[i].clear()
    end
end