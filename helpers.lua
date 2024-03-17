function Dump(o, t)
    local _t = t or 0
    local tabStr = ""
    local i = 0
    while (i < _t) do
        tabStr = tabStr.."\t"
        i = i + 1
    end
    if type(o) == 'table' then
        local s = '{ \n'
        tabStr = tabStr..'\t'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. tabStr .. '\t[' .. k .. '] = ' .. Dump(v, i+1) .. ',\n'
        end
        return s .. tabStr .. '}'
    else
        return tostring(o)
    end
end

exports("Dump", Dump)