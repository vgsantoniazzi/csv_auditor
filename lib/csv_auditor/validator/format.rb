module CsvAuditor
  class Validator
    class Format
      def self.validate(row:, fields:, name:, instance_hash:, options: {})
        raise ArgumentError, "only allowed one field validation for format" if fields.length > 1

        return if row[fields.first] =~ Regexp.new(options["regex"])

        row[name] = "#{fields.first}: #{row[fields.first]} does not match regex #{options["regex"]}"
      end
    end
  end
end
