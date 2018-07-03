local entropy_calculator = {}

local probability_calculator = require('src.scripts.probability_calculator')
local string_transformer = require('src.scripts.utils.string_transformer')

function entropy_calculator.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)
    local entropy = {}
    for index, package in pairs(packages.codes) do
        local codes = string_transformer.split_by_spaces(package)
        local a_posteriori =
            probability_calculator.calculate_a_posteriori(alphabet, a_priori, codes[letter_number], noise)
        entropy[index] = entropy_calculator.calculate_entropy_for_one(a_posteriori)
    end
    return entropy
end

function entropy_calculator.calculate_entropy_for_one(a_posteriori)
    local sum = 0
    for _, probability in pairs(a_posteriori) do
        sum = sum - probability * math.log(probability) / math.log(2)
    end
    return sum
end

function entropy_calculator.calculate_average_entropy(entropy, packages, letter_number, noise, a_priori)
    local average_entropy = 0
    for index, package in pairs(packages.codes) do
        local splitted_package = string_transformer.split_by_spaces(package)
        local probability_of_receiving =
            probability_calculator.calculate_probability_of_receiving(splitted_package[letter_number], noise, a_priori)
        average_entropy = average_entropy + probability_of_receiving * entropy[index]
    end
    return average_entropy
end

return entropy_calculator