local probability_calculator = {}

---[[return Map<string, number>]]
function probability_calculator.calculate_a_priori(alphabet)
    local a_priori = {}
    local size = 0
    for _, _ in pairs(alphabet.codes) do size = size + 1 end
    local probability_of_symbol = 1 / size
    for alphabet_code, _ in pairs(alphabet.codes) do
        a_priori[alphabet_code] = probability_of_symbol
    end
    return a_priori
end

---[[return Map<string, number>]]
function probability_calculator.calculate_a_priori_with_frequency_of_letters(alphabet, frequency_of_letters)
    --[[Наверняка вероятности тут считаются неправильно, т. к. даны вероятности не всех символов,
    -- и в сумме эти вероятности равны единице. Какова вероятность появления других символов - не известно.
    -- Поэтому как-то так. Тем символам, вероятность которых неизвестна, присваивается вероятность 1/N.
    -- Затем каждая вероятность делится на сумму всех вероятностей, чтобы в сумме получилось 1]]
    local a_priori = {}
    local size = 0
    for _, _ in pairs(alphabet.codes) do size = size + 1 end
    local probability_of_symbol = 1 / size
    local sum = 0
    for alphabet_code, character in pairs(alphabet.codes) do
        if frequency_of_letters[character] ~= nil then
            a_priori[alphabet_code] = frequency_of_letters[character]
            sum = sum + frequency_of_letters[character]
        else
            a_priori[alphabet_code] = probability_of_symbol
            sum = sum + probability_of_symbol
        end
    end
    for alphabet_code, probability in pairs(a_priori) do
        a_priori[alphabet_code] = probability / sum
    end
    return a_priori
end

---[[return Map<string, number>]]
function probability_calculator.calculate_a_posteriori(alphabet, a_priori, char_code, noise)
    local realistic_probabilities = {}
    local divider = 0
    for alphabet_code, _ in pairs(alphabet.codes) do
        local realistic = probability_calculator.calculate_realistic(alphabet_code, char_code, noise)
        realistic_probabilities[alphabet_code] = realistic
        divider = divider + realistic * a_priori[alphabet_code]
    end
    local a_posteriori = {}
    for alphabet_code, _ in pairs(alphabet.codes) do
        a_posteriori[alphabet_code] = realistic_probabilities[alphabet_code] * a_priori[alphabet_code] / divider
    end
    return a_posteriori
end

---[[return number]]
function probability_calculator.calculate_realistic(alphabet_code, char_code, noise)
    local realistic = 1.0
    for index = 1, string.len(char_code) do
        if alphabet_code:sub(index, index) == char_code:sub(index, index) then
            realistic = realistic * (1.0 - noise);
        else
            realistic = realistic * noise;
        end
    end
    return realistic;
end

---[[return number]]
function probability_calculator.calculate_probability_of_receiving(char_code, noise, a_priori)
    local pyj = 0
    for alphabet_code, probability in pairs(a_priori) do
        local realistic = probability_calculator.calculate_realistic(alphabet_code, char_code, noise)
        pyj = pyj + realistic * probability
    end
    return pyj
end


return probability_calculator