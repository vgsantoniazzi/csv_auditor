module CsvAuditor
  class Runner
    def self.run(csv_file)
      new(csv_file).run
    end

    attr_accessor :csv_file, :processed_rows, :progress_bar

    def initialize(csv_file)
      @csv_file = csv_file
      @processed_rows = []
      @progress_bar = ProgressBar.create(
        format: "%a (%c/%C) %b\u{15E7}%i %p%% %t",
        progress_mark: " ",
        length: 80,
        remainder_mark: "\u{FF65}",
        total: total_rows
      )
    end

    def run
      CSV.foreach(csv_file, headers: true) do |row|
        execute_validations!(row)

        processed_rows << row

        progress_bar.increment
        sleep 0.3
      end

      progress_bar.finish

      save_results!
    end

    private

    def execute_validations!(row)
      config.validations.each do |validation|
        validator(validation["validation"]).validate(
          name: validation["name"],
          row: row,
          processed_rows: processed_rows,
          fields: validation["columns"],
          options: validation["options"]
        )
      end
    end

    def save_results!
      headers = processed_rows.map(&:headers).flatten.uniq

      CSV.open(config.output, "w") do |csv|
        csv << headers
        processed_rows.each do |row|
          csv << row.fields(*headers)
        end
      end
    end

    def total_rows
      @total_rows ||= CSV.read(csv_file).count
    end

    def config
      @config ||= CsvAuditor.configuration
    end

    def validator(name)
      config.validators.validators[name]
    end
  end
end
