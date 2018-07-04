local alphabet = require('src.data.alphabet')
local packages = require('src.data.packages')
local noise = require('src.data.noise')
local letter_numbers = require('src.data.letter_numbers')
local string_transformer = require('src.scripts.utils.string_transformer')
local probability_calculator = require('src.scripts.probability_calculator')
local entropy_calculator = require('src.scripts.entropy_calculator')
local information_calculator = require('src.scripts.information_calculator')
local decoder = require('src.scripts.decoder')
local frequency_of_letters = require('src.data.frequency_of_letters')
local calculator_of_arithmetic_means = require('src.scripts.utils.calculator_of_arithmetic_means')

---[[Чтобы можно было закомментировать ненужные функции.
--- Каждый вызов функции у functions можно спокойно закомментировать]]
local functions = {}

function functions.calculate_a_posteriori_for_the_sequential_transmission(a_priori, letter_number, alphabet, packages, noise)
    local probabilities = {}
    for index, value in pairs(a_priori) do
        probabilities[index] = value
    end
    for index, package in pairs(packages.codes) do
        local codes = string_transformer.split_by_spaces(package)
        print('Апостериорные вероятности для сообщения №' .. index .. ' (' .. letter_number .. '-й символ):')
        local a_posteriori =
            probability_calculator.calculate_a_posteriori(alphabet, probabilities, codes[letter_number], noise)
        for _, element in pairs(a_posteriori) do
            io.write(element ^ (1 / 25) .. ', ')
        end
        print()
        probabilities = a_posteriori
    end
    print()
end

function functions.calculate_a_posteriori_when_duplicating(a_priori, letter_number, alphabet, packages, noise)
    local probabilities = {}
    for index, package in pairs(packages.codes) do
        local codes = string_transformer.split_by_spaces(package)
        local a_posteriori =
            probability_calculator.calculate_a_posteriori(alphabet, a_priori, codes[letter_number], noise)
        probabilities[index] = a_posteriori
    end
    local average_probabilities = calculator_of_arithmetic_means.find_the_average_values(probabilities)
    print('Апостериорные вероятности для посылки с многократным дублированием (' .. letter_number .. '-й символ):')
    for _, element in pairs(average_probabilities) do
        io.write(element ^ (1 / 25) .. ', ')
    end
    print()
end

function functions.decode_message_for_the_sequential_transmission(a_priori, alphabet, packages, noise)
    print('Расшифрованное сообщение для ' .. #packages.codes .. ' посылки:')
    local caracters = decoder.decode_for_the_sequential_transmission(alphabet, a_priori, packages, noise)
    io.write('"')
    for _, char in pairs(caracters) do
        io.write(char)
    end
    io.write('"')
    print()
end

function functions.decode_message_when_duplicating(a_priori, alphabet, packages, noise)
    print('Расшифрованное сообщение для посылки с многократным дублированием:')
    local caracters = decoder.decode_when_duplicating(alphabet, a_priori, packages, noise)
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
        functions.decode_message_for_the_sequential_transmission(a_priori, alphabet, pac, noise)
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

function functions.calculate_entropy_for_the_sequential_transmission(a_priori, packages, alphabet, letter_number, noise)
    local entropy = entropy_calculator.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)
    print('Энтропия для ' .. letter_number .. '-го символа:')
    for _, value in pairs(entropy) do
        io.write(value .. ', ')
    end
    print()
    local average_entropy =
        entropy_calculator.calculate_average_entropy(entropy, packages, letter_number, noise, a_priori)
    print('Средняя условная энтропия для ' .. letter_number .. '-го символа:')
    print(average_entropy)
    print()
end

function functions.calculate_information_for_the_sequential_transmission(a_priori, packages, alphabet, letter_number, noise)
    local information = information_calculator.calculate_information(a_priori, packages, alphabet, letter_number, noise)
    print('Информация для ' .. letter_number .. '-го символа:')
    for _, value in pairs(information) do
        io.write(value .. ', ')
    end
    print()
    local average_information =
        information_calculator.calculate_average_information(information, packages, letter_number, noise, a_priori)
    print('Средняя взаимная информация для ' .. letter_number .. '-го символа:')
    print(average_information)
    print()
end

print()
print('======= Последовательная передача одинаковых сообщений =======')

print()
print('------- Символы равновероятны -------')
print()

---[[Априорные вероятности, символы равновероятны]]
local a_priori = probability_calculator.calculate_a_priori(alphabet)
--functions.print_a_priory(a_priori)

---[[Апостериорные вероятности, символы равновероятны]]
--functions.calculate_a_posteriori_for_the_sequential_transmission(a_priori, letter_numbers.for_probabilities, alphabet, packages, noise)

---[[Расшифровка сообщений, символы равновероятны]]
--functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)

---[[Энтропия, символы равновероятны]]
--functions.calculate_entropy_for_the_sequential_transmission(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---[[Информация, символы равновероятны]]
--functions.calculate_information_for_the_sequential_transmission(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

print()
print('------- Вероятность символа зависит от частоты использования -------')
print()

---[[Априорные вероятности, вероятность символа зависит от частоты использования]]
local a_priori = probability_calculator.calculate_a_priori_with_frequency_of_letters(alphabet, frequency_of_letters)
--functions.print_a_priory(a_priori)

---[[Апостериорные вероятности, вероятность символа зависит от частоты использования]]
--functions.calculate_a_posteriori_for_the_sequential_transmission(a_priori, letter_number.for_probabilities, alphabet, packages, noise)

---[[Расшифровка сообщений, вероятность символа зависит от частоты использования]]
--functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)

---[[Энтропия, вероятность символа зависит от частоты использования]]
--functions.calculate_entropy_for_the_sequential_transmission(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---[[Информация, вероятность символа зависит от частоты использования]]
--functions.calculate_information_for_the_sequential_transmission(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

print()
print('======= Передача сообщения путем многократного дублирования =======')

print()
print('------- Символы равновероятны -------')
print()

---[[Априорные вероятности, символы равновероятны]]
local a_priori = probability_calculator.calculate_a_priori(alphabet)
--functions.print_a_priory(a_priori)

---[[Апостериорные вероятности, символы равновероятны]]
--functions.calculate_a_posteriori_when_duplicating(a_priori, letter_numbers.for_probabilities, alphabet, packages, noise)

---[[Расшифровка сообщений, символы равновероятны]]
--functions.decode_message_when_duplicating(a_priori, alphabet, packages, noise)

---[[Энтропия, символы равновероятны]]
--functions.calculate_entropy_when_duplicating(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---[[Информация, символы равновероятны]]
--functions.calculate_information_when_duplicating(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

print()
print('------- Вероятность символа зависит от частоты использования -------')
print()

---[[Априорные вероятности, вероятность символа зависит от частоты использования]]
local a_priori = probability_calculator.calculate_a_priori_with_frequency_of_letters(alphabet, frequency_of_letters)
--functions.print_a_priory(a_priori)

---[[Апостериорные вероятности, вероятность символа зависит от частоты использования]]
--functions.calculate_a_posteriori_when_duplicating(a_priori, letter_numbers.for_probabilities, alphabet, packages, noise)

---[[Расшифровка сообщений, вероятность символа зависит от частоты использования]]
--functions.decode_message_when_duplicating(a_priori, alphabet, packages, noise)

---[[Энтропия, вероятность символа зависит от частоты использования]]
--functions.calculate_entropy_when_duplicating(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---[[Информация, вероятность символа зависит от частоты использования]]
--functions.calculate_information_when_duplicating(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)