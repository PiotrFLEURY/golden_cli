import 'package:args/command_runner.dart';
import 'package:golden_cli/src/services/golden_service.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template gen_command}
///
/// `golden gen`
/// A [Command] to generate the golden files from a git reference and copy them
/// {@endtemplate}
class GenCommand extends Command<int> {
  /// {@macro gen_command}
  GenCommand({
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
  String get description => 'Generate the golden files from a git reference';

  @override
  String get name => 'gen';

  final Logger _logger;

  final GoldenService _goldenService;

  @override
  Future<int> run() async {
    final ref = argResults!['ref'] as String;

    _logger.info('Getting golden files from $ref');

    final checkRefProgress = await _goldenService.checkRef(ref: ref);
    if (checkRefProgress.exitCode != 0 ||
        checkRefProgress.stdout.toString().isEmpty) {
      _logger
        ..err('Failed to check ref $ref')
        ..err(checkRefProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(checkRefProgress.stdout.toString());

    await _goldenService.doCleanup(ref);

    _logger.info('Adding $ref to the worktree');
    final addWorktreeProgress = await _goldenService.addWorktree(ref: ref);
    if (addWorktreeProgress.exitCode != 0) {
      _logger
        ..err('Failed to add worktree for ref $ref')
        ..err(addWorktreeProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(addWorktreeProgress.stdout.toString());

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

    await _goldenService.fetchGoldens();

    _logger.info('Done!');
    return ExitCode.success.code;
  }
}
