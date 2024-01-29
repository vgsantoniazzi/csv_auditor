module CsvAuditor
  class Validator
    class Uniqueness
      def self.validate(row:, fields:, name:, processed_rows:, options: {})
        processed_rows.each_with_index do |r, index|
          if fields.all? { |field| r[field] == row[field] }
            row[name] = "#{fields.join(", ")}: is not unique (duplicate found: row #{index + 2})"
            break
          end
        end
      end
    end
  end
end
