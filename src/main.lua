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

---[[Чтобы можно было закомментировать ненужные функции.
--- Каждый вызов функции у functions можно спокойно закомментировать]]
local functions = {}

function functions.calculate_a_posteriori(a_priori, letter_number, alphabet, packages, noise)
    local splitted_packages = {}
    for index, package in pairs(packages.codes) do
        splitted_packages[index] = string_transformer.split_by_spaces(package)
    end
    functions.calculate_a_posteriori_for_splitted_packages(a_priori, letter_number, alphabet, splitted_packages, noise)
end

function functions.calculate_a_posteriori_for_splitted_packages(a_priori, letter_number, current_alphabet, splitted_packages, noise)
    local probabilities = {}
    for index, value in pairs(a_priori) do
        probabilities[index] = value
    end
    for index, codes in pairs(splitted_packages) do
        print('Апостериорные вероятности для сообщения №' .. index .. ' (' .. letter_number .. '-й символ):')
        local a_posteriori =
            probability_calculator.calculate_a_posteriori(current_alphabet, probabilities, codes[letter_number], noise)
        local modified_a_posteriori = {}
        for code, element in pairs(a_posteriori) do
            modified_a_posteriori[code] = element ^ (1 / 25)
        end
        functions.print_table_with_alphabet_for_python(modified_a_posteriori, current_alphabet)
        print()
        probabilities = a_posteriori
    end
    print()
end

function functions.decode_message(a_priori, alphabet, packages, noise)
    local splitted_packages = {}
    for index, package in pairs(packages.codes) do
        splitted_packages[index] = string_transformer.split_by_spaces(package)
    end
    functions.decode_message_for_splitted_packages(a_priori, alphabet, splitted_packages, packages.number_of_characters, noise)
end

function functions.decode_message_for_splitted_packages(a_priori, alphabet, splitted_packages, number_of_characters, noise)
    print('Расшифрованное сообщение для ' .. #splitted_packages .. ' посылки:')
    local caracters = decoder.decode(alphabet, a_priori, splitted_packages, number_of_characters, noise)
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
    print()
end

function functions.print_a_priory(a_priori, current_alphabet)
    print('Априорные вероятности каждой буквы:')
    local modified_a_priori = {}
    for index, element in pairs(a_priori) do
        modified_a_priori[index] = element ^ (1 / 25)
    end
    functions.print_table_with_alphabet_for_python(modified_a_priori, current_alphabet)
    print()
    print()
end

function functions.calculate_entropy(a_priori, packages, alphabet, letter_number, noise)
    local splitted_packages = {}
    for index, package in pairs(packages.codes) do
        splitted_packages[index] = string_transformer.split_by_spaces(package)
    end
    functions.calculate_entropy_for_splitted_packages(a_priori, splitted_packages, alphabet, letter_number, noise)
end

function functions.calculate_entropy_for_splitted_packages(a_priori, splitted_packages, alphabet, letter_number, noise)
    local entropy = entropy_calculator.calculate_entropy(a_priori, splitted_packages, alphabet, letter_number, noise)
    print('Энтропия для ' .. letter_number .. '-го символа:')
    functions.print_table_for_python(entropy)
    print()
    local average_entropy =
        entropy_calculator.calculate_average_entropy(entropy, splitted_packages, letter_number, noise, a_priori)
    print('Средняя условная энтропия для ' .. letter_number .. '-го символа:')
    print(average_entropy)
    print()
end

function functions.calculate_information(a_priori, packages, alphabet, letter_number, noise)
    local splitted_packages = {}
    for index, package in pairs(packages.codes) do
        splitted_packages[index] = string_transformer.split_by_spaces(package)
    end
    functions.calculate_information_for_splitted_packages(a_priori, splitted_packages, alphabet, letter_number, noise)
end

function functions.calculate_information_for_splitted_packages(a_priori, splitted_packages, alphabet, letter_number, noise)
    local information = information_calculator.calculate_information(a_priori, splitted_packages, alphabet, letter_number, noise)
    print('Информация для ' .. letter_number .. '-го символа:')
    functions.print_table_for_python(information)
    print()
    local average_information =
        information_calculator.calculate_average_information(information, splitted_packages, letter_number, noise, a_priori)
    print('Средняя взаимная информация для ' .. letter_number .. '-го символа:')
    print(average_information)
    print()
end

function functions.print_table_for_python(table)
    io.write('values = [')
    local chart_labels = ''
    local is_first = true
    for index, value in pairs(table) do
        if is_first then
            is_first = false
            chart_labels = chart_labels .. '"' .. index .. '"'
        else
            io.write(', ')
            chart_labels = chart_labels .. ', "' .. index .. '"'
        end
        io.write(value)
    end
    io.write(']')
    print()
    io.write('names = [' .. chart_labels .. ']')
end

function functions.print_table_with_alphabet_for_python(table, current_alphabet)
    io.write('values = [')
    local chart_labels = ""
    local is_first = true
    for _, code in pairs(current_alphabet.character_order) do
        local character = current_alphabet.codes[code]
        local value = table[code]
        if is_first then
            is_first = false
            chart_labels = chart_labels .. '"' .. character .. '"'
        else
            io.write(', ')
            chart_labels = chart_labels .. ', "' .. character .. '"'
        end
        io.write(value)
    end
    io.write(']')
    print()
    io.write('names = [' .. chart_labels .. ']')
end

print()
print('1.1 Расшифрование сообщения при равных априорных вероятностях')
print()

---[[Априорные вероятности, символы равновероятны]]
local a_priori = probability_calculator.calculate_a_priori(alphabet)
functions.print_a_priory(a_priori, alphabet)

---[[Апостериорные вероятности, символы равновероятны]]
functions.calculate_a_posteriori(a_priori, letter_numbers.for_probabilities, alphabet, packages, noise)

---[[Расшифровка сообщений, символы равновероятны]]
functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)

---[[Энтропия, символы равновероятны]]
functions.calculate_entropy(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---[[Информация, символы равновероятны]]
functions.calculate_information(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

print()
print('1.2 Расшифрование сообщения с учётом частоты использования русских букв')
print()

---[[Априорные вероятности, вероятность символа зависит от частоты использования]]
local a_priori = probability_calculator.calculate_a_priori_with_frequency_of_letters(alphabet, frequency_of_letters)
functions.print_a_priory(a_priori, alphabet)

---[[Апостериорные вероятности, вероятность символа зависит от частоты использования]]
functions.calculate_a_posteriori(a_priori, letter_numbers.for_probabilities, alphabet, packages, noise)

---[[Расшифровка сообщений, вероятность символа зависит от частоты использования]]
functions.decode_message_for_each_package(a_priori, alphabet, packages, noise)

---[[Энтропия, вероятность символа зависит от частоты использования]]
functions.calculate_entropy(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---[[Информация, вероятность символа зависит от частоты использования]]
functions.calculate_information(a_priori, packages, alphabet, letter_numbers.for_entropy_and_information, noise)

---Передача сообщения путем многократного дублирования

local alphabet_with_duplication = {}
alphabet_with_duplication.codes = {}
local package_with_duplication = {}
local number_of_packages = 0
for index, package in pairs(packages.codes) do
    number_of_packages = index
    local splitted_package = string_transformer.split_by_spaces(package)
    for i, code in pairs(splitted_package) do
        if package_with_duplication[i] == nil then
            package_with_duplication[i] = code
        else
            package_with_duplication[i] = package_with_duplication[i] .. code
        end
    end
end
alphabet_with_duplication.character_order = {}
for _, code in pairs(alphabet.character_order) do
    local code_with_duplication = ''
    for _ = 1, number_of_packages do
        code_with_duplication = code_with_duplication .. code
    end
    table.insert(alphabet_with_duplication.character_order, code_with_duplication)
    local character = alphabet.codes[code]
    alphabet_with_duplication.codes[code_with_duplication] = character
end
alphabet_with_duplication.depth = alphabet.depth * number_of_packages
local list_with_package_with_duplication = {}
list_with_package_with_duplication[1] = package_with_duplication
local number_of_characters = packages.number_of_characters

print()
print('2.1 Расшифрование одного длинного сообщения при равных априорных вероятностях')
print()

---[[Априорные вероятности, символы равновероятны]]
local a_priori = probability_calculator.calculate_a_priori(alphabet_with_duplication)
functions.print_a_priory(a_priori, alphabet_with_duplication)

---[[Апостериорные вероятности, символы равновероятны]]
functions.calculate_a_posteriori_for_splitted_packages(a_priori, letter_numbers.for_probabilities, alphabet_with_duplication, list_with_package_with_duplication, noise)

---[[Расшифровка сообщений, символы равновероятны]]
functions.decode_message_for_splitted_packages(a_priori, alphabet_with_duplication, list_with_package_with_duplication, number_of_characters, noise)
print()

---[[Энтропия, символы равновероятны]]
functions.calculate_entropy_for_splitted_packages(a_priori, list_with_package_with_duplication, alphabet_with_duplication, letter_numbers.for_entropy_and_information, noise)

---[[Информация, символы равновероятны]]
functions.calculate_information_for_splitted_packages(a_priori, list_with_package_with_duplication, alphabet_with_duplication, letter_numbers.for_entropy_and_information, noise)

print()
print('2.2 Расшифрование одного длинного сообщения с учётом частоты использования русских букв')
print()

---[[Априорные вероятности, вероятность символа зависит от частоты использования]]
local a_priori = probability_calculator.calculate_a_priori_with_frequency_of_letters(alphabet_with_duplication, frequency_of_letters)
functions.print_a_priory(a_priori, alphabet_with_duplication)

---[[Апостериорные вероятности, вероятность символа зависит от частоты использования]]
functions.calculate_a_posteriori_for_splitted_packages(a_priori, letter_numbers.for_probabilities, alphabet_with_duplication, list_with_package_with_duplication, noise)

---[[Расшифровка сообщений, вероятность символа зависит от частоты использования]]
functions.decode_message_for_splitted_packages(a_priori, alphabet_with_duplication, list_with_package_with_duplication, number_of_characters, noise)
print()

---[[Энтропия, вероятность символа зависит от частоты использования]]
functions.calculate_entropy_for_splitted_packages(a_priori, list_with_package_with_duplication, alphabet_with_duplication, letter_numbers.for_entropy_and_information, noise)

---[[Информация, вероятность символа зависит от частоты использования]]
functions.calculate_information_for_splitted_packages(a_priori, list_with_package_with_duplication, alphabet_with_duplication, letter_numbers.for_entropy_and_information, noise)