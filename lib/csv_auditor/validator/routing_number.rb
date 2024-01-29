module CsvAuditor
  class Validator
    class RoutingNumber
      def self.validate(row:, fields:, name:, processed_rows:, options: {})
        raise ArgumentError, "only allowed one field validation for routing_number" if fields.length > 1

        return if routing_number_valid?(row[fields.first])

        row[name] = "#{fields.first}: #{row[fields.first]} is not a valid routing number"
      end

      def self.routing_number_valid?(routing_number)
        routing_number &&
          routing_number.length == 9 &&
          /\A\d+\z/.match(routing_number) &&
          routing_checksum(routing_number)
      end

      def self.routing_checksum(rt_num)
        x = rt_num[0].to_i + rt_num[3].to_i + rt_num[6].to_i
        y = rt_num[1].to_i + rt_num[4].to_i + rt_num[7].to_i
        z = rt_num[2].to_i + rt_num[5].to_i + rt_num[8].to_i

        ((3 * x + 7 * y + z) % 10).zero?
      end
    end
  end
end
