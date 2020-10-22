print("Length: ")
length = tonumber(read())

print("Width: ")
width = tonumber(read())

blueprint = {}

function scanLayer()
    for j=1, length do
        blueprint[j] = {}
        
        turtle.forward()
        turtle.turnRight()

        for i=1, width do
            success, block = turtle.inspectDown()
            if success then
                blueprint[j][i] = block
            else
                blueprint[j][i] = {}        
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

function removeLayer()
    full = false

    for j=1, length do   
        turtle.forward()
        turtle.turnRight()

        for i=1, width do
            if full ~= true then
                turtle.digDown()
                blueprintCopy[j][i] = {}
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
    for i,v in ipairs(blueprintCopy) do
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
    for i,v in ipairs(blueprint) do
               
        for j,w in ipairs(v) do
            
            --print(w['name'])
        end 
    
    end 

end


scanLayer()

blueprintCopy = {}
for i,v in ipairs(blueprint) do
    blueprintCopy[i] = v
end


removeLayer()
printLayer()
--save(blueprint,"TEST")
