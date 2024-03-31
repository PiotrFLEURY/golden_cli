import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:process/process.dart';

const String worktreePath = '.golden';

/// {@template sample_command}
///
/// `golden_cli sample`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class TestCommand extends Command<int> {
  /// {@macro sample_command}
  TestCommand({
    required Logger logger,
    required ProcessManager processManager,
    required FileSystem fileSystem,
  })  : _logger = logger,
        _processManager = processManager,
        _fileSystem = fileSystem {
    argParser
      ..addOption(
        'ref',
        abbr: 'r',
        help: 'Git refence to compare against',
        defaultsTo: 'main',
      )
      ..addFlag(
        'generate',
        abbr: 'g',
        help: 'Generate golden files before copying it',
        defaultsTo: true,
      )
      ..addFlag(
        'execute',
        abbr: 'e',
        help: 'Execute tests after copying the golden files',
        defaultsTo: true,
      )
      ..addFlag(
        'cleanup',
        abbr: 'c',
        help: 'Cleanup the worktree after the tests',
        defaultsTo: true,
      );
  }

  @override
  String get description =>
      'Executes Flutter Golden tests and compares them against a Git reference';

  @override
  String get name => 'test';

  final Logger _logger;

  final ProcessManager _processManager;

  final FileSystem _fileSystem;

  @override
  Future<int> run() async {
    final ref = argResults?['ref'] as String;
    final generate = argResults?['generate'] as bool;
    final execute = argResults?['execute'] as bool;
    final cleanup = argResults?['cleanup'] as bool;

    _logger.info('Running Flutter Golden tests against $ref');

    final checkRefProgress = await _checkRef(ref: ref);
    if (checkRefProgress.exitCode != 0 ||
        checkRefProgress.stdout.toString().isEmpty) {
      _logger
        ..err('Failed to check ref $ref')
        ..err(checkRefProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(checkRefProgress.stdout.toString());

    // Step 0 - Cleanup
    await _doCleanup(ref);

    // Step 1 - Add the provided git reference to the worktree
    // ignore: cascade_invocations
    _logger.info('Adding $ref to the worktree');
    final addWorktreeProgress = await _addWorktree(ref: ref);
    if (addWorktreeProgress.exitCode != 0) {
      _logger
        ..err('Failed to add worktree for ref $ref')
        ..err(addWorktreeProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(addWorktreeProgress.stdout.toString());

    // Step 2 - Generate the golden files using the provided git reference
    if (generate) {
      _logger.info('Generating golden files using $ref');
      final generateGoldensProgress = await _generateGoldens(ref: ref);
      if (generateGoldensProgress.exitCode != 0) {
        _logger
          ..err('Failed to generate golden files for ref $ref')
          ..err(generateGoldensProgress.stderr.toString());
        return ExitCode.software.code;
      }
      _logger.info(generateGoldensProgress.stdout.toString());
    } else {
      _logger.warn('Skipping golden files generation as desired');
    }

    // Step 3 - Fetch generated golden files
    // ignore: cascade_invocations
    _logger.info('Fetching generated golden files');
    final fetchGoldensProgress = await _fetchGoldens();
    if (!fetchGoldensProgress) {
      _logger
        ..err('Failed to fetch generated golden files')
        ..err(fetchGoldensProgress.toString());
      return ExitCode.software.code;
    }

    // Step 4 - Run Flutter Golden tests
    if (execute) {
      _logger.info('Running Flutter Golden tests');
      final runGoldenTestsProgress = await _runGoldenTests();
      if (runGoldenTestsProgress.exitCode != 0) {
        _logger
          ..err('Failed to run Flutter Golden tests')
          ..err(runGoldenTestsProgress.stderr.toString())
          ..info(runGoldenTestsProgress.stdout.toString());
        return ExitCode.software.code;
      }
      _logger.info(runGoldenTestsProgress.stdout.toString());
    } else {
      _logger.warn('Skipping Flutter Golden tests run as desired');
    }

    // Step 5 - Cleanup
    if (cleanup) {
      await _doCleanup(ref);
    } else {
      _logger.warn('Skipping cleanup as desired');
    }

    // ignore: cascade_invocations
    _logger.info('Done!');
    return ExitCode.success.code;
  }

  Future<int> _doCleanup(String ref) async {
    _logger.info('Cleaning up');
    final cleanupProgress = await _cleanup(ref: ref);
    if (cleanupProgress.exitCode != 0) {
      _logger
        ..err('Failed to cleanup')
        ..err(cleanupProgress.stderr.toString());
      return ExitCode.software.code;
    }
    _logger.info(cleanupProgress.stdout.toString());
    return ExitCode.success.code;
  }

  Future<ProcessResult> _cleanup({
    required String ref,
  }) async {
    final listWorktreeProcess = await _processManager.run(
      [
        'git',
        'worktree',
        'list',
      ],
    );
    if (listWorktreeProcess.exitCode != 0) {
      return listWorktreeProcess;
    }
    if (listWorktreeProcess.stdout.toString().contains(worktreePath)) {
      final removeWorktreeProcess = await _processManager.run(
        [
          'git',
          'worktree',
          'remove',
          '-f',
          worktreePath,
        ],
      );
      if (removeWorktreeProcess.exitCode != 0) {
        return removeWorktreeProcess;
      }
    }

    final listBranchProcess = await _processManager.run(
      [
        'git',
        'branch',
      ],
    );
    if (listBranchProcess.exitCode != 0) {
      return listBranchProcess;
    }
    if (listBranchProcess.stdout.toString().contains('worktree-$ref')) {
      final removeBranchProcess = await _processManager.run(
        [
          'git',
          'branch',
          '-D',
          'worktree-$ref',
        ],
      );
      return removeBranchProcess;
    }
    return ProcessResult(0, 0, 'SUCCESS', '');
  }

  Future<ProcessResult> _runGoldenTests() {
    return _processManager.run(
      [
        'flutter',
        'test',
      ],
    );
  }

  Future<bool> _fetchGoldens() async {
    final goldenFiles = await _getGoldenFiles(
      path: '$worktreePath/test',
    );

    for (final goldenFile in goldenFiles) {
      final directorySeparator = Platform.isWindows ? r'\' : '/';

      final newPath = goldenFile.replaceAll(
        '$worktreePath$directorySeparator',
        '',
      );
      _logger.info('Copying $goldenFile to $newPath');

      _fileSystem.file(goldenFile).copySync(newPath);
    }

    return true;
  }

  Future<List<String>> _getGoldenFiles({
    required String path,
  }) async {
    final contentList = _fileSystem.directory(path).listSync();

    final goldenFiles = <String>[];

    final directories =
        contentList.whereType<Directory>().map((file) => file.path).toList();
    for (final directory in directories) {
      goldenFiles.addAll(
        await _getGoldenFiles(
          path: directory,
        ),
      );
    }

    return contentList
        .where((file) => file.path.endsWith('.png'))
        .map((file) => file.path)
        .toList()
      ..addAll(goldenFiles);
  }

  Future<ProcessResult> _generateGoldens({
    required String ref,
  }) {
    return _processManager.run(
      [
        'flutter',
        'test',
        '--update-goldens',
      ],
      workingDirectory: worktreePath,
    );
  }

  Future<ProcessResult> _addWorktree({
    required String ref,
  }) {
    return _processManager.run(
      [
        'git',
        'worktree',
        'add',
        '-b',
        'worktree-$ref',
        worktreePath,
        ref,
      ],
    );
  }

  Future<ProcessResult> _checkRef({
    required String ref,
  }) {
    return _processManager.run(
      [
        'git',
        'show-ref',
        ref,
      ],
    );
  }
}
