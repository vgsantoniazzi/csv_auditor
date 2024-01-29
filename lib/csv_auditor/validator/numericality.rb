module CsvAuditor
  class Validator
    class Numericality
      def self.validate(row:, fields:, name:, processed_rows:, options: {})
        raise ArgumentError, "only allowed one field validation for numericality" if fields.length > 1

        unless float?(row[fields.first])
          row[name] = "#{fields.first}: #{row[fields.first]} is not a number"
          return
        end

        return unless options["greater_than"] && row[fields.first].to_f <= options["greater_than"]

        row[name] = "#{fields.first}: #{row[fields.first]} is not greater than #{options["greater_than"]}"
      end

      def self.float?(string)
        true if Float(string)
      rescue StandardError
        false
      end
    end
  end
end
