local information_calculator = {}

local probability_calculator = require('src.scripts.probability_calculator')
local entropy_calculator = require('src.scripts.entropy_calculator')

function information_calculator.calculate_information(a_priori, splitted_packages, alphabet, letter_number, noise)
    local information = {}
    for index_of_package, package in pairs(splitted_packages) do
        local a_posteriori =
            probability_calculator.calculate_a_posteriori(alphabet, a_priori, package[letter_number], noise)
        local entropy = entropy_calculator.calculate_entropy_for_one(a_posteriori)
        local sum = 0
        for index, a_posteriori_probability in pairs(a_posteriori) do
            sum = sum - (a_posteriori_probability * math.log(a_priori[index]))
        end
        information[index_of_package] = sum - entropy
    end
    return information
end

function information_calculator.calculate_average_information(information, splitted_packages, letter_number, noise, a_priori)
    local average_information = 0
    for index, package in pairs(splitted_packages) do
        local probability_of_receiving =
            probability_calculator.calculate_probability_of_receiving(package[letter_number], noise, a_priori)
        average_information = average_information + probability_of_receiving * information[index]
    end
    return average_information
end

return information_calculator