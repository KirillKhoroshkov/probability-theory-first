local entropy_calculator = {}

local probability_calculator = require('src.scripts.probability_calculator')
local string_transformer = require('src.scripts.utils.string_transformer')

function entropy_calculator.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)
    local entropy = {}
    for index, package in pairs(packages.codes) do
        local probabilities = {}
        for index, value in pairs(a_priori) do
            probabilities[index] = value
        end
        local codes = string_transformer.split_by_spaces(package)
        local a_posteriori = probability_calculator.calculate_a_posteriori(alphabet, probabilities, codes[letter_number], noise)
        local sum = 0
        for _, probability in pairs(a_posteriori) do
            sum = sum - probability * math.log(probability) / math.log(2)
        end
        entropy[index] = sum
    end
    return entropy
end

function entropy_calculator.calculate_mid_entropy(entropy, packages, letter_number, noise, a_priori)
    local mid_entropy = 0
    for index, package in pairs(packages.codes) do
        local splitted_package = string_transformer.split_by_spaces(package)
        local probability_of_receiving =
            probability_calculator.calculate_probability_of_receiving(splitted_package[letter_number], noise, a_priori)
        mid_entropy = mid_entropy + probability_of_receiving * entropy[index]
    end
    return mid_entropy
end

return entropy_calculator