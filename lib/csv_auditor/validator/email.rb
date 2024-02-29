module CsvAuditor
  class Validator
    class Email
      def self.validate(row:, fields:, name:, instance_hash:, options: {})
        raise ArgumentError, "only allowed one field validation for format" if fields.length > 1

        email = row[fields.first]
        email = email&.strip if options["strip"]

        return if email =~ URI::MailTo::EMAIL_REGEXP

        row[name] = "#{fields.first}: #{email} does not match regex #{URI::MailTo::EMAIL_REGEXP}"
      end
    end
  end
end
