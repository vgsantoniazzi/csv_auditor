# Load all gem-specified validators. This will be required
# if the configuration file specifies any of the default ones.
# See `lib/csv_auditor/validator` for more details.
#
Dir[File.join(__dir__, "validator", "*.rb")].sort.each { |file| require file }

# Allows the user to use a custom validator. If the user creates
# a new file.rb and specifies the class, we can call that class
# as a validator.
#
# Check the `/examples/custom_validator` for more examples.
$LOAD_PATH << Dir.pwd

module CsvAuditor

  # Validators are the top level executors to search for problems.
  # For each row, we will call the validator specified and execute
  # them. This top level class specified the default ones and how
  # to add a new validator.
  #
  class Validator
    attr_accessor :validators

    # Load all the default validators by default. If one of them
    # is specified in the validations file, we can use it.
    #
    def initialize
      @validators = {}

      load_default_validators
    end

    # To add a new validator, the current execution path was
    # previously defined as `$LOAD_PATH`. It will load any
    # specified class in the configuration file.
    def add(validator)
      require validator.snake_case
      validators[validator.snake_case] = validator.pascal_case.constantize
    end

    private

    # Load all the default validators. This will be called
    # when the class is initialized.
    #
    def load_default_validators
      self.class.constants.map { |c| validators[c.to_s.snake_case] = "CsvAuditor::Validator::#{c}".constantize }
    end
  end
end
