import 'dart:io';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:golden_cli/src/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:process/process.dart';
import 'package:test/test.dart';

import 'golden_command_test.mocks.dart';

@GenerateMocks([
  Logger,
  ProcessManager,
])
void main() {
  group('golden command', () {
    late Logger mockLogger;
    late MockProcessManager mockProcessManager;
    late FileSystem mockFileSystem;
    late GoldenCliCommandRunner commandRunner;

    setUp(() {
      mockLogger = MockLogger();
      mockProcessManager = MockProcessManager();
      mockFileSystem = MemoryFileSystem();

      commandRunner = GoldenCliCommandRunner(
        logger: mockLogger,
        processManager: mockProcessManager,
        fileSystem: mockFileSystem,
      );
      when(mockProcessManager.run(any)).thenAnswer(
        (_) async => ProcessResult(0, 0, 'SUCCESS', ''),
      );
      when(
        mockProcessManager.run(
          any,
          workingDirectory: anyNamed('workingDirectory'),
        ),
      ).thenAnswer(
        (_) async => ProcessResult(0, 0, 'SUCCESS', ''),
      );
      mockFileSystem.directory('.golden/test').createSync(recursive: true);
    });

    test('test should run without arguments', () async {
      // GIVEN

      // WHEN
      final exitCode = await commandRunner.run(['test']);

      // THEN
      expect(exitCode, ExitCode.success.code);
    });

    test('clean should run without arguments', () async {
      // GIVEN

      // WHEN
      final exitCode = await commandRunner.run(['clean']);

      // THEN
      expect(exitCode, ExitCode.success.code);
    });

    test('get should run without arguments', () async {
      // GIVEN

      // WHEN
      final exitCode = await commandRunner.run(['get']);

      // THEN
      expect(exitCode, ExitCode.success.code);
    });

    test('gen should run without arguments', () async {
      // GIVEN

      // WHEN
      final exitCode = await commandRunner.run(['gen']);

      // THEN
      expect(exitCode, ExitCode.success.code);
    });
  });
}
