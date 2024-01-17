function onLoad()
    sInput = nil
    while true do
        term.clear()
        term.setCursorPos(1,1)
        term.write("Type C to Copy a Structure")
        term.setCursorPos(1,2)
        term.write("Type V to Paste a Structure")
        term.setCursorPos(1,3)
        sInput = read()
        if sInput ~= nil or sInput ~= "" then
            term.clear()
            term.setCursorPos(1,1)
            if sInput == "C" then
                return true
            else
                return false
            end
        end
    end
end

function readDims()
    print("Length: ")
    length = tonumber(read())

    print("Width: ")
    width = tonumber(read())

    print("Height: ")
    height = tonumber(read())

    print("Name of Blueprint Save File: ")
    nameOfFile = tostring(read())
end


blueprint = {}

function goUp()
    for h=1, height do
        turtle.up()
    end
end

function scanLayer()
    for h=1, height do 
        blueprint[h] = {} 
    for j=1, length do
        blueprint[h][j] = {}
        
        turtle.forward()
        turtle.turnRight()

        for i=1, width do
            success, block = turtle.inspectDown()
            if success then
                blueprint[h][j][i] = block
            else
                blueprint[h][j][i] = {}        
            end
            turtle.forward()
        end
        
        turtle.turnLeft()
        turtle.turnLeft()

        for i=1, width do
            turtle.forward()
        end

        turtle.turnRight()

    end
    turtle.turnLeft()
    turtle.turnLeft()

    for i=1, length do
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()

    
    blueprintCopy = deepcopy(blueprint)        
    removeLayer(h)
    
    turtle.digDown()
    turtle.down()
    
    end
end

function save(table,name)
    local file = fs.open(name,'w')
    file.write(textutils.serialise(table))
    file.close()
end

function mysplit(inputstr,sep)
    if sep == nil then
        sep = '%s'
    end
    
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t,str)
    end
    return t
end

-- Save copied tables in `copies`, indexed by original table.
function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function selectItem(name)
    notFound = true
    
    for i=1,#inv do
        if #inv[i] >= 1 then
            --print(inv[i][1]['count'])
            --print(inv[i][1]['name'])
            t = mysplit(name,",")
            name_first = t[1]
            damage = tonumber(t[2])
            
            if name_first == inv[i][1]['name'] then
                if damage == nil then
                    turtle.select(i)
                    notFound = false
                end
                
                if damage == inv[i][1]['damage'] then
                    turtle.select(i)
                    notFound = false
                    return true
                end 
            end
        end
    end
    
    if notFound == true then
        return false
    end

    return true
end

function scanInv()
    for i=1,16 do
        inv[i] = {}
        inv[i][1] = turtle.getItemDetail(i)
    end
end

function removeLayer(num)
    full = false
    
    for j=1, length do   
        turtle.forward()
        turtle.turnRight()

        for i=1, width do
            if full ~= true then
                turtle.digDown()
                blueprintCopy[num][j][i] = {}
            end

            if turtle.getItemCount(16) > 0 then
                full = true
            end

            turtle.forward()
        end
        
        turtle.turnLeft()
        turtle.turnLeft()

        for i=1, width do
            turtle.forward()
        end

        turtle.turnRight()

    end

    --Return Home and Face Forward
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1, length do
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()
    
    done = true
    --save(blueprintCopy,"TEST")
    for i,v in ipairs(blueprintCopy[num]) do
        for j,w in ipairs(v) do
            if next(w) ~= nil then
                --save(w,"TEST")
                done = false
                break
            end
        end
        if done == false then
            break
        end
    end

    if done == false then
        --save(blueprintCopy,'TEST')
        print("Going 1 Recursion Deeper")
        
        for i = 1,16 do
            turtle.select(i)
            turtle.drop()
        end
        
        
        removeLayer()
    end
    
end

function printLayer()
    --save(blueprint,"TEST")
    for i,x in ipairs(blueprint) do
    for i,v in ipairs(x) do
               
        for j,w in ipairs(v) do
            
            --print(w['name'])
        end 
    
    end 
    end
end

function checkFileLoad()
    print("Printing New Blueprint")
    print("Type name of blueprint")
    fname = tostring(read())
    if fs.exists(fname) == true then
        h = fs.open(fname, "r")
        data = h.readAll()
        h.close()
        return data
    else
        print("Invalid File Name")
        checkFileLoad()
    end 
end

function getTotals(bp)
    --print(textutils.serialise(bp))
    totals = {}
    for key, layers in ipairs(bp) do
    for key, rows in ipairs(layers) do
    for key, cells in ipairs(rows) do
        if cells['name'] ~= nil then
            if totals[cells['name']] == nil then
                totals[cells['name']] = 0
            end
        
            if cells['name'] ~= nil then
                totals[cells['name']] = totals[cells['name']] + 1
            end
        end
    end
    end
    end
    return totals
end

function printTotals(totals)
    for key, values in pairs(totals) do
        --print(key, " ", values)
    end    
end

function checkInv(totals)
    inv = {}
    for i = 1, 16 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data ~= nil then
            if inv[data['name']] == nil then
                inv[data['name']] = data['count']
            else
                inv[data['name']] = inv[data['name']] + data['count']
            end    
        end
    end
    return inv 
end


function compareInvtoBp(bp)
        totals = getTotals(bp)
        printTotals(totals)
        inv = checkInv(totals)        
        --print(textutils.serialise(totals))
        term.clear()
        term.setCursorPos(1,1)
        
        missing = {}
        for key in pairs(totals) do
            if totals[key] ~= inv[key] then
                if inv[key] ~= nil then
                    missing[key] = totals[key] - inv[key]
                else
                    missing[key] = totals[key]
                end
            end
        end
        
        
        print("Please Provide the following:")
        for key in pairs(missing) do
            print(key, ": ", missing[key])
        end
        
        
        count = 0
        for _ in pairs(missing) do
            count = count + 1
        end
        
        if count > 0 then
            os.sleep(5)
            compareInvtoBp(bp)
        else
            beginBuilding(bp)
        end
        
end

function beginBuilding(bp)
    layers = 0
    rows = 0
    cells = 0
    for key, layer in ipairs(bp) do
        layers = layers + 1
    for key, row in ipairs(layer) do
        rows = rows + 1
    for key, cell in ipairs(row) do
        cells = cells + 1
        --print(textutils.serialise(cell))
        if cell['name'] ~= nil then
            print(cell['name'])
        end
    end
    end
    end
    rows = rows / layers
    cells = cells / rows / layers
    
    turtle.up()
    
    for k = 1, layers do
    for j = 1, rows do
        turtle.forward()
        turtle.turnRight()
        for i = 1, cells do
            placeBlock(bp[layers-k+1][rows-j+1][cells-i+1]['name'])
            turtle.forward()
        end
        turtle.turnLeft()
        turtle.turnLeft()
    
        for i = 1, cells do
            turtle.forward()
        end
        turtle.turnRight()
    end
    
    turtle.turnRight()
    turtle.turnRight()
    for j = 1 , rows do
        turtle.forward()
    end
    
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.up()
    end
    
    for k = 1, layers + 1 do
        turtle.down()
    end    
end

function placeBlock(block)
    if block ~= nil then
    for i = 1, 16 do
        turtle.select(i)
        selected = turtle.getItemDetail()
        if selected ~= nil then
        if selected['name'] == block then
            turtle.placeDown()
        end
        end
    end
    end        
end


if onLoad() == true then
    readDims()
    goUp()
    scanLayer()
    printLayer()
    save(blueprint, nameOfFile)
else
    term.clear()
    blueprintFile = checkFileLoad() 
    bp = textutils.unserialise(blueprintFile)
    compareInvtoBp(bp)
                
end
