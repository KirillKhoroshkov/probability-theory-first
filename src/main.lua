local alphabet = require('src.data.alphabet')
local packages = require('src.data.packages')
local noise = require('src.data.noise')
local letter_number = require('src.data.letter_number')
local string_transformer = require('src.scripts.utils.string_transformer')
local probability_calculator = require('src.scripts.probability_calculator')
local decoder = require('src.scripts.decoder')
local frequency_of_letters = require('src.data.frequency_of_letters')

print()
print('------- Символы равновероятны -------')
print()
--[[Априорные вероятности, символы равновероятны]]
print('Априорные вероятности каждой буквы:')
local a_priori = probability_calculator.calculate_a_priori(alphabet)
for _, element in pairs(a_priori) do
    io.write(element .. ', ')
end
print('')

--[[Апостериорные вероятности, символы равновероятны]]
local probabilities = {}
for index, value in pairs(a_priori) do
    probabilities[index] = value
end
for index, package in pairs(packages.codes) do
    local codes = string_transformer.split_by_spaces(package)
    print('Апостериорные вероятности в сообщении №' .. index .. ' (' .. letter_number .. '-й символ):')
    local a_posteriori = probability_calculator.calculate_a_posteriori(alphabet, probabilities, codes[letter_number], noise)
    for _, element in pairs(a_posteriori) do
        io.write(element .. ', ')
    end
    print()
    probabilities = a_posteriori
end
print()

--[[Расшифровка сообщения, символы равновероятны]]
local probabilities = {}
for index, value in pairs(a_priori) do
    probabilities[index] = value
end
print('Расшифрованное сообщение:')
local caracters = decoder.decode(alphabet, probabilities, packages, noise)
for _, char in pairs(caracters) do
    io.write(char)
end
print()
print()

print('------- Вероятность символа зависит от частоты использования -------')
print()
--[[Априорные вероятности, вероятность символа зависит от частоты использования]]
local sum_of_probabilities = 0
for _, frequency_of_letter in pairs(frequency_of_letters) do
    sum_of_probabilities = sum_of_probabilities + frequency_of_letter
end
print(sum_of_probabilities)