local inv = {}
local args = {...}

for i=1,16 do
    inv[i] = {}
    inv[i][1] = turtle.getItemDetail(i)
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


function save(table,name)
    local file = fs.open(name,'w')
    file.write(textutils.serialise(table))
    file.close()
end

function getSlot(name)
 notFound = true
 
 for i=1,#inv do
    if #inv[i] >= 1 then
        if args[1] == "-names" then
            print(inv[i][1]['name'] .. ',' .. inv[i][1]['damage'])
        end
        
            
 
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
                return
            end 
        end
    end
 end
 
 if notFound == true then
     print("Coundn't Find: " .. name)
 end
end

if args[1] then 
    getSlot(args[1])
end
save(inv,"INV")
