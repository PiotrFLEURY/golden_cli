import 'package:args/command_runner.dart';
import 'package:golden_cli/src/services/golden_service.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template clean_command}
///
/// `golden clean`
/// A [Command] to clean the git worktree and remove the branch.
/// {@endtemplate}
class CleanCommand extends Command<int> {
  /// {@macro clean_command}
  CleanCommand({
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
  String get description => 'Clean the git worktree and remove the branch';

  @override
  String get name => 'clean';

  final Logger _logger;

  final GoldenService _goldenService;

  @override
  Future<int> run() async {
    final ref = argResults!['ref'] as String;

    _logger.info('Cleaning up worktree and branch $ref');

    await _goldenService.doCleanup(ref);

    _logger.info('Done!');
    return ExitCode.success.code;
  }
}
