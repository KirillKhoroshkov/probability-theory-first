local calculator_of_arithmetic_means = {}

function calculator_of_arithmetic_means.find_the_average_values(list_of_maps)
    local average_values = {}
    local number = 0
    for _, keys_and_values in pairs(list_of_maps) do
        number = number + 1
        for key, value in pairs(keys_and_values) do
            if average_values[key] == nil then
                average_values[key] = value
            else
                average_values[key] = average_values[key] + value
            end
        end
    end
    for key, value in pairs(average_values) do
        average_values[key] = value / number
    end
    return average_values
end

return calculator_of_arithmetic_means