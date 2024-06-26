## golden_cli

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

Generated by the [Very Good CLI][very_good_cli_link] 🤖

A Dart CLI made to help with multi platform Golden comparisons in Flutter.

---

## Getting Started 🚀

If the CLI application is available on [pub](https://pub.dev), activate globally via:

```sh
dart pub global activate golden_cli
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Usage

```sh
# Execute golden test using main branch as reference
$ golden test

# cleanup
$ golden clean

# generate golden files
$ golden gen

# get goldens without generating them
$ golden get

# Using a specific branch
$ golden test -r feature/branch
$ golden clean -r feature/branch
$ golden gen -r feature/branch
$ golden get -r feature/branch

# Show CLI version
$ golden --version

# Show usage help
$ golden --help
```

## Running Tests with coverage 🧪

To run all unit tests use the following command:

```sh
$ dart pub global activate coverage 1.2.0
$ dart test --coverage=coverage
$ dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov)
.

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
