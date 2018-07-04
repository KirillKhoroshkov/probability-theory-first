local decoder = {}

local probability_calculator = require('src.scripts.probability_calculator')
local string_transformer = require('src.scripts.utils.string_transformer')
local calculator_of_arithmetic_means = require('src.scripts.utils.calculator_of_arithmetic_means')

---[[return array of chars]]
function decoder.decode_for_the_sequential_transmission(alphabet, a_priori, packages, noise)
    local splitted_packages = {}
    for index, package in pairs(packages.codes) do
        splitted_packages[index] = string_transformer.split_by_spaces(package)
    end
    local message = {}
    for code_index = 1, packages.number_of_characters do
        local probabilities = {}
        for index, value in pairs(a_priori) do
            probabilities[index] = value
        end
        for _, codes in pairs(splitted_packages) do
            local a_posteriori =
                probability_calculator.calculate_a_posteriori(alphabet, probabilities, codes[code_index], noise)
            probabilities = a_posteriori
        end
        local most_probable_code = decoder.find_most_probable(probabilities)
        local character = alphabet.codes[most_probable_code]
        table.insert(message, character)
    end
    return message
end

function decoder.decode_when_duplicating(alphabet, a_priori, packages, noise)
    local splitted_packages = {}
    for index, package in pairs(packages.codes) do
        splitted_packages[index] = string_transformer.split_by_spaces(package)
    end
    local message = {}
    for code_index = 1, packages.number_of_characters do
        local probabilities = {}
        for package_index, codes in pairs(splitted_packages) do
            local a_posteriori =
                probability_calculator.calculate_a_posteriori(alphabet, a_priori, codes[code_index], noise)
            probabilities[package_index] = a_posteriori
        end
        local average_probabilities = calculator_of_arithmetic_means.find_the_average_values(probabilities)
        local most_probable_code = decoder.find_most_probable(average_probabilities)
        local character = alphabet.codes[most_probable_code]
        table.insert(message, character)
    end
    return message
end

function decoder.find_most_probable(codes_and_probabilities)
    local most_probable = {}
    for code, probability in pairs(codes_and_probabilities) do --[[я не знаю, как по-другому получить первый элемент]]
        most_probable.code = code
        most_probable.probability = probability
        break
    end
    for code, probability in pairs(codes_and_probabilities) do
        if most_probable.probability < probability then
            most_probable.code = code
            most_probable.probability = probability
        end
    end
    return most_probable.code
end

return decoder