import 'dart:io';

import 'package:file/file.dart';
import 'package:golden_cli/src/constants.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:process/process.dart';

class GoldenService {
  const GoldenService({
    required Logger logger,
    required ProcessManager processManager,
    required FileSystem fileSystem,
  })  : _logger = logger,
        _processManager = processManager,
        _fileSystem = fileSystem;

  final Logger _logger;
  final ProcessManager _processManager;
  final FileSystem _fileSystem;

  Future<ProcessResult> checkRef({
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

  Future<ProcessResult> addWorktree({
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

  Future<ProcessResult> generateGoldens({
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

  Future<bool> fetchGoldens() async {
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

  Future<ProcessResult> runGoldenTests() {
    return _processManager.run(
      [
        'flutter',
        'test',
      ],
    );
  }

  Future<int> doCleanup(String ref) async {
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
}
