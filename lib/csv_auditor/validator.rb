require "lucky_case/string"

# Load all default validators.
Dir[File.join(__dir__, "validator", "*.rb")].sort.each { |file| require file }

# Load all validators from current user directory.
$LOAD_PATH << Dir.pwd

module CsvAuditor
  class Validator
    attr_accessor :validators

    def initialize
      @validators = {}

      load_default_validators
    end

    def add(validator)
      require validator.snake_case
      validators[validator.snake_case] = validator.pascal_case.constantize
    end

    private

    def load_default_validators
      self.class.constants.map { |c| validators[c.to_s.snake_case] = "CsvAuditor::Validator::#{c}".constantize }
    end
  end
end
