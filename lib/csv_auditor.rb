require "csv"
require "yaml"
require "json"
require "ruby-progressbar"
require "optparse"
require "lucky_case/string"
require "csv_auditor/version"
require "csv_auditor/validator"
require "csv_auditor/configuration"
require "csv_auditor/runner"

# Main module
#
# This module is the entry point for the gem. It will be used to run the auditor.
# It requires all external libraries and start the runner.
#
# You can configure the library to set the output and validation files properly.
# The config block is simple to use, and you can configure everything. Please
# check the `exe/audit` file.
#
module CsvAuditor

  #  The csv_file is the only required argument to run the auditor. It specifies
  # where the csv_file is located and starts auditing it
  #
  def self.run(csv_file)
    CsvAuditor::Runner.run(csv_file)
  end
end
