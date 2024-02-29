module CsvAuditor
  class Validator
    class Uniqueness
      def self.validate(row:, fields:, name:, instance_hash:, options: {})
        uniqueness_hash = hash(fields, row, options: options)
        if instance_hash.dig(name, uniqueness_hash)
          row[name] = "#{fields.join(", ")}: is not unique"
        else
          instance_hash[name] ||= {}
          instance_hash[name][uniqueness_hash] = true
        end
      end

      def self.hash(fields, row, options: {})
        values = fields.map { |field| options&.fetch(:case_sensitive, false) ? row[field].downcase : row[field] }
        Digest::MD5.hexdigest(values.join(","))
      end
    end
  end
end
