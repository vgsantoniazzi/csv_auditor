## Welcome to CSV Auditor

Define rules to audit your CSV files — and the pacman will do the job.

```sh
Time: 00:00:02 (3/10)              ᗧ･･･････････････････････････････ 30% Progress
```

## Getting Started

```sh
$ exe/audit --file examples/complete_example/audit.csv --output examples/complete_example/audited.csv --config examples/complete_example/.csv_auditor.yml
```

## Contributing

I :heart: Open source!

[Follow github guides for forking a project](https://guides.github.com/activities/forking/)

[Follow github guides for contributing open source](https://guides.github.com/activities/contributing-to-open-source/#contributing)

[Squash pull request into a single commit](http://eli.thegreenplace.net/2014/02/19/squashing-github-pull-requests-into-a-single-commit/)

##### Clone

```
$ git clone git@github.com:vgsantoniazzi/csv_auditor.git
```

##### Setup

```
$ bin/setup
```

##### execute

```
$ exe/autit

Usage: audit [options]
    -f, --file file.csv              File to audit (required)
    -o, --output audited.csv         File to output to (default: audited.csv)
    -c, --config .csv_auditor.csv    Configuration file (default: .csv_auditor.yml)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CsvAuditor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vgsantoniazzi/csv_auditor/blob/master/CODE_OF_CONDUCT.md).
