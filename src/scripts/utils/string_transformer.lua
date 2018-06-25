local string_transformer = {}

function string_transformer.split_by_spaces(package)
    local codes = {}
    for code in package:gmatch("%S+") do
        table.insert(codes, code)
    end
    return codes
end

return string_transformer