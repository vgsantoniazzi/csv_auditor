class Cpf
  def self.validate(row:, fields:, name:, instance_hash:, options: {})
    fields.each do |field|
      cpf = row[field]
      row[name] = "#{field}: #{cpf} is not a valid CPF" unless cpf_valid?(cpf)
    end
  end

  def self.cpf_valid?(cpf)
    cpf.gsub!(/[^\d]/, "")

    cpf_numbers = cpf.chars.map(&:to_i)
    first_digit_valid?(cpf_numbers) && second_digit_valid?(cpf_numbers)
  end

  def self.first_digit_valid?(cpf_numbers)
    first_digits = cpf_numbers[0..9]
    multiplied = first_digits.map.with_index do |number, index|
      number * (10 - index)
    end

    mod = multiplied.reduce(:+) % 11

    fst_verifier_digit = 11 - mod > 9 ? 0 : mod
    fst_verifier_digit == cpf_numbers[10]
  end

  def self.second_digit_valid?(cpf_numbers)
    second_digits = cpf_numbers[0..10]
    multiplied = second_digits.map.with_index do |number, index|
      number * (11 - index)
    end

    mod = multiplied.reduce(:+) % 11

    snd_verifier_digit = 11 - mod > 9 ? 0 : mod
    snd_verifier_digit == cpf_numbers[11]
  end
end
