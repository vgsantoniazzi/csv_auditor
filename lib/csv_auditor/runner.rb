module CsvAuditor
  class Runner
    def self.run(execution)
      new(execution).run
    end

    attr_accessor :execution, :processed_rows, :instance_hash, :progress_bar

    def initialize(execution)
      @execution = execution
      @processed_rows = []
      @instance_hash = {}
      @progress_bar = ProgressBar.create(
        format: "%a (%c/%C) %b\u{15E7}%i %p%% %t",
        progress_mark: " ",
        length: 80,
        remainder_mark: "\u{FF65}",
        total: total_rows
      )
    end

    def run
      CSV.foreach(execution["file"], headers: true) do |row|
        execute_validations!(row)

        processed_rows << row

        progress_bar.increment
      end

      progress_bar.finish

      save_results!
    end

    private

    def execute_validations!(row)
      execution["validations"].each do |validation|
        validator(validation["validation"]).validate(
          name: validation["name"],
          row: row,
          instance_hash: instance_hash,
          fields: validation["columns"],
          options: validation["options"]
        )
      end
    end

    def save_results!
      headers = processed_rows.map(&:headers).flatten.uniq

      CSV.open(execution["output"], "w") do |csv|
        csv << headers
        processed_rows.each do |row|
          csv << row.fields(*headers)
        end
      end
    end

    def total_rows
      @total_rows ||= CSV.read(execution["file"]).count
    end

    def validator(name)
      CsvAuditor.configuration.validators.validators[name]
    end
  end
end
