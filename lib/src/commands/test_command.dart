import 'package:args/command_runner.dart';
import 'package:golden_cli/src/services/golden_service.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template sample_command}
///
/// `golden test`
/// A [Command] to execute golden test from a git reference.
/// {@endtemplate}
class TestCommand extends Command<int> {
  /// {@macro test_command}
  TestCommand({
    required Logger logger,
    required GoldenService goldenService,
  })  : _logger = logger,
        _goldenService = goldenService {
    argParser.addOption(
      'ref',
      abbr: 'r',
      help: 'Git refence to compare against',
      defaultsTo: 'main',
    );
  }

  @override
  String get description =>
      'Executes Flutter Golden tests and compares them against a Git reference';

  @override
  String get name => 'test';

  final Logger _logger;

  final GoldenService _goldenService;

  @override
  Future<int> run() async {
    final ref = argResults?['ref'] as String;

    _logger.info('Running Flutter Golden tests against $ref');

    final checkRefProgress = await _goldenService.checkRef(ref: ref);
    if (checkRefProgress.exitCode != 0 ||
        checkRefProgress.stdout.toString().isEmpty) {
      _logger
        ..err('Failed to check ref $ref')
        ..err(checkRefProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(checkRefProgress.stdout.toString());

    // Step 0 - Cleanup
    await _goldenService.doCleanup(ref);

    // Step 1 - Add the provided git reference to the worktree
    // ignore: cascade_invocations
    _logger.info('Adding $ref to the worktree');
    final addWorktreeProgress = await _goldenService.addWorktree(ref: ref);
    if (addWorktreeProgress.exitCode != 0) {
      _logger
        ..err('Failed to add worktree for ref $ref')
        ..err(addWorktreeProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(addWorktreeProgress.stdout.toString());

    // Step 2 - Generate the golden files using the provided git reference
    // ignore: cascade_invocations
    _logger.info('Generating golden files using $ref');
    final generateGoldensProgress =
        await _goldenService.generateGoldens(ref: ref);
    if (generateGoldensProgress.exitCode != 0) {
      _logger
        ..err('Failed to generate golden files for ref $ref')
        ..err(generateGoldensProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(generateGoldensProgress.stdout.toString());

    // Step 3 - Fetch generated golden files
    // ignore: cascade_invocations
    _logger.info('Fetching generated golden files');
    final fetchGoldensProgress = await _goldenService.fetchGoldens();
    if (!fetchGoldensProgress) {
      _logger
        ..err('Failed to fetch generated golden files')
        ..err(fetchGoldensProgress.toString());
      return ExitCode.software.code;
    }

    // Step 4 - Run Flutter Golden tests
    _logger.info('Running Flutter Golden tests');
    final runGoldenTestsProgress = await _goldenService.runGoldenTests();
    if (runGoldenTestsProgress.exitCode != 0) {
      _logger
        ..err('Failed to run Flutter Golden tests')
        ..err(runGoldenTestsProgress.stderr.toString())
        ..info(runGoldenTestsProgress.stdout.toString());
      return ExitCode.software.code;
    }
    _logger.info(runGoldenTestsProgress.stdout.toString());

    // Step 5 - Cleanup
    await _goldenService.doCleanup(ref);

    // ignore: cascade_invocations
    _logger.info('Done!');
    return ExitCode.success.code;
  }
}
