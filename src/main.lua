local alphabet = require('src.data.alphabet')
local packages = require('src.data.packages')
local noise = require('src.data.noise')
local letter_number = require('src.data.letter_number')
local string_transformer = require('src.scripts.utils.string_transformer')
local probability_calculator = require('src.scripts.probability_calculator')
local entropy_calculator = require('src.scripts.entropy_calculator')
local decoder = require('src.scripts.decoder')
local frequency_of_letters = require('src.data.frequency_of_letters')

---[[Чтобы можно было закомментировать ненужные функции.
--- Каждый вызов функции у functions можно спокойно закомментировать]]
local functions = {}

function functions.calculate_a_posteriori(a_priori, letter_number, alphabet, packages, noise)
    local probabilities = {}
    for index, value in pairs(a_priori) do
        probabilities[index] = value
    end
    for index, package in pairs(packages.codes) do
        local codes = string_transformer.split_by_spaces(package)
        print('Апостериорные вероятности для сообщения №' .. index .. ' (' .. letter_number .. '-й символ):')
        local a_posteriori = probability_calculator.calculate_a_posteriori(alphabet, probabilities, codes[letter_number], noise)
        for _, element in pairs(a_posteriori) do
            io.write(element ^ (1 / 25) .. ', ')
        end
        print()
        probabilities = a_posteriori
    end
    print()
end

function functions.decode_message(a_priori, alphabet, packages, noise)
    local probabilities = {}
    for index, value in pairs(a_priori) do
        probabilities[index] = value
    end
    print('Расшифрованное сообщение для ' .. #packages.codes .. ' посылки:')
    local caracters = decoder.decode(alphabet, probabilities, packages, noise)
    io.write('"')
    for _, char in pairs(caracters) do
        io.write(char)
    end
    io.write('"')
    print()
end

function functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)
    for index, _ in pairs(packages.codes) do
        local pac = {}
        pac.codes = {}
        pac.number_of_characters = packages.number_of_characters
        for i = 1, index do
            pac.codes[i] = packages.codes[i]
        end
        functions.decode_message(a_priori, alphabet, pac, noise)
    end
end

function functions.print_a_priory(a_priori)
    print('Априорные вероятности каждой буквы:')
    for _, element in pairs(a_priori) do
        io.write(element ^ (1 / 25) .. ', ')
    end
    print()
    print()
end

function functions.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)
    local entropy = entropy_calculator.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)
    print('Энтропия для ' .. letter_number .. '-го символа:')
    for _, value in pairs(entropy) do
        io.write(value .. ', ')
    end
    print()
    local mid_entropy = entropy_calculator.calculate_mid_entropy(entropy, packages, letter_number, noise, a_priori)
    print('Средняя энтропия для ' .. letter_number .. '-го символа:')
    print(mid_entropy)
    print()
end

print()
print('======= Последовательная передача одинаковых сообщений =======')

print()
print('------- Символы равновероятны -------')
print()

--[[Априорные вероятности, символы равновероятны]]
local a_priori = probability_calculator.calculate_a_priori(alphabet)
--functions.print_a_priory(a_priori)

--[[Апостериорные вероятности, символы равновероятны]]
--functions.calculate_a_posteriori(a_priori, letter_number, alphabet, packages, noise)

--[[Расшифровка сообщений, символы равновероятны]]
--functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)

--[[Энтропия, символы равновероятны]]
--functions.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)

--[[Информация, символы равновероятны]]
--functions.calculate_information(a_priori, alphabet, packages, noise)

print()
print('------- Вероятность символа зависит от частоты использования -------')
print()

--[[Априорные вероятности, вероятность символа зависит от частоты использования]]
local a_priori = probability_calculator.calculate_a_priori_with_frequency_of_letters(alphabet, frequency_of_letters)
--functions.print_a_priory(a_priori)

--[[Апостериорные вероятности, вероятность символа зависит от частоты использования]]
--functions.calculate_a_posteriori(a_priori, letter_number, alphabet, packages, noise)

--[[Расшифровка сообщений, вероятность символа зависит от частоты использования]]
--functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)

--[[Энтропия, вероятность символа зависит от частоты использования]]
--functions.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)

--[[Информация, вероятность символа зависит от частоты использования]]
--functions.calculate_information(a_priori, alphabet, packages, noise)

print()
print('======= Передача сообщения путем многократного дублирования =======')

print()
print('------- Символы равновероятны -------')
print()

print()
print('------- Вероятность символа зависит от частоты использования -------')
print()
