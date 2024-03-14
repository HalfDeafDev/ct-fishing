function Dump(o)
    if type(o) == 'table' then
        local s = '{ \n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Dump(v) .. ',\n'
        end
        return s .. '} \n'
    else
        return tostring(o)
    end
end