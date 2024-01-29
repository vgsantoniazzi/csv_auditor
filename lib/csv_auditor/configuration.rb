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
    attr_accessor :config_file_path, :output, :validations, :validators

    EXPECTED_COLUMNS = %w[name validation columns].freeze

    def config_file_path
      @config_file_path ||= ".csv_auditor.yml"
    end

    def output
      @output ||= "audited.csv"
    end

    def validations
      @validations ||= load_validations!
    end

    def validators
      @validators ||= load_validators!
    end

    private

    def load_validations!
      validations = YAML.load_file(config_file_path)["validations"]
      validations.each do |validation|
        EXPECTED_COLUMNS.each do |column|
          raise "Configuration invalid! Missing #{column}" unless validation[column]
        end
      end

      validations
    end

    def load_validators!
      validators = CsvAuditor::Validator.new
      validations.each do |validation|
        loadable_module = validation["validation"]

        validators.add(loadable_module) unless validators.validators[loadable_module]
      end

      validators
    end
  end
end
