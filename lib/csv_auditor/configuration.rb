require "yaml"

module CsvAuditor
  class << self
    attr_accessor :configuration

    def configure
      @configuration ||= Configuration.new
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :config_file_path, :output, :executions, :validators

    EXPECTED_EXECUTION_COLUMNS = %w[file output validations].freeze
    EXPECTED_VALIDATION_COLUMNS = %w[name validation columns].freeze

    def config_file_path
      @config_file_path ||= ".csv_auditor.yml"
    end

    def executions
      @executions ||= load_executions!
    end

    def validators
      @validators ||= load_validators!
    end

    private

    def load_executions!
      executions = YAML.load_file(config_file_path)

      executions.each do |execution|
        EXPECTED_EXECUTION_COLUMNS.each do |column|
          raise "Configuration invalid! Missing #{column}" unless execution[column]

          execution["validations"].each do |validation|
            EXPECTED_VALIDATION_COLUMNS.each do |column|
              raise "Configuration invalid! Missing #{column}" unless validation[column]
            end
          end
        end
      end

      executions
    end

    def load_validators!
      validators = CsvAuditor::Validator.new
      executions.each do |execution|
        execution["validations"].each do |validation|
          loadable_module = validation["validation"]

          validators.add(loadable_module) unless validators.validators[loadable_module]
        end
      end

      validators
    end
  end
end
