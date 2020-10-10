print("Length: ")
length = tonumber(read())

print("Width: ")
width = tonumber(read())

blueprint = {}

for j=1, length do
    blueprint[j] = {}
    print(j)
    
    turtle.forward()
    turtle.turnRight()

    for i=1, width do
        print(i)
        print("-------")
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

function save(table,name)
    local file = fs.open(name,'w')
    file.write(textutils.serialise(table))
    file.close()
end

save(blueprint,"TEST")
