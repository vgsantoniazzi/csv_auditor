module CsvAuditor

  # The runner class is responsible for parsing the CSV and applying the
  # validations. The notification system is the CLI progress bar that
  # increments when we process each CSV row. At the end of the processing,
  # we save the results in a new .csv file with extra columns:
  #
  # Each validation becomes a new column with the error message.
  #
  class Runner

    # Instantiate the class with the csv file path and call for execution.
    def self.run(csv_file)
      new(csv_file).run
    end

    attr_accessor :csv_file, :processed_rows, :progress_bar

    # We have three main attributes: The csv_file, which is the file path,
    # the processed rows, and the progress bar.
    #
    #   - The ruby CSV library will load the file;
    #   - After processing each row, it will be added to the `processed_rows`;
    #   - The progress_bar is a Pacman-stylish progress bar.
    #
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

    # The process is pretty straightforward. For each CSV line, we:
    # Execute all validations that apply;
    #   - Add the processed row to the `processed_rows` array;
    #   - Increment the progress bar;
    #   - Finish the progress bar;
    #   - Save the results.
    #
    def run
      CSV.foreach(csv_file, headers: true) do |row|
        execute_validations!(row)
        processed_rows << row
        progress_bar.increment
      end

      progress_bar.finish

      save_results!
    end

    private

    # We need to load the proper validations for each row and call it.
    # The validations are pre-loaded into memory based on the file and
    # what we will require. The required arguments are:
    #   - name: This will become the error column name. If we have a
    #     validation called `required_email`, it will later become the
    #     column called `required_email`, and the row value will be
    #     the error message we've found.
    #   - row: The row that we are actually processing. It's an
    #     instance of b ruby's Csv::Row;
    #   - processed_rows: All rows that were processed. Required
    #     in case we need to back search for uniqueness;
    #   - fields: The defined fields (or columns) that we need to validate;
    #   - options: External options specified by the configuration file.
    #
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

    # Stores the content into a CSV file specified by the `output`
    # configuration. Here, it will define the extra columns and
    # store their values.
    #
    def save_results!
      headers = processed_rows.map(&:headers).flatten.uniq

      CSV.open(config.output, "w") do |csv|
        csv << headers
        processed_rows.each do |row|
          csv << row.fields(*headers)
        end
      end
    end

    # Count the total rows in the CSV file. We use this to
    # define the progress bar total.
    #
    def total_rows
      @total_rows ||= CSV.read(csv_file).count
    end

    # Shortcut to the configuration.
    # We use this to access the settings specified previously
    # in the initializer file or via CLI.
    #
    def config
      @config ||= CsvAuditor.configuration
    end

    # Shortcut to the validator.
    # We use this to access the validator specified previously
    # in the configuration file.
    def validator(name)
      config.validators.validators[name]
    end
  end
end
