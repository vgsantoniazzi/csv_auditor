require_relative "lib/csv_auditor/version"

Gem::Specification.new do |spec|
  spec.name = "csv_auditor"
  spec.version = CsvAuditor::VERSION
  spec.authors = ["Victor Antoniazzi"]
  spec.email = ["vgsantoniazzi@gmail.com"]

  spec.summary = "Audit your CSV files. Check for problems and write your own rules."
  spec.homepage = "https://github.com/vgsantoniazzi/csv_auditor"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = "https://github.com/vgsantoniazzi/csv_auditor"
  spec.metadata["source_code_uri"] = "https://github.com/vgsantoniazzi/csv_auditor"
  spec.metadata["changelog_uri"] = "https://github.com/vgsantoniazzi/csv_auditor/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("lucky_case", "1.1.0")
  spec.add_dependency("optparse", "0.4.0")
  spec.add_dependency("ruby-progressbar", "1.13.0")
end
