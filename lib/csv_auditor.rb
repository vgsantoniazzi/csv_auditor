require "csv"
require "yaml"
require "json"
require "ruby-progressbar"
require "optparse"
require "csv_auditor/version"
require "csv_auditor/validator"
require "csv_auditor/configuration"
require "csv_auditor/runner"

module CsvAuditor
  def self.run(csv_file)
    CsvAuditor::Runner.run(csv_file)
  end
end
