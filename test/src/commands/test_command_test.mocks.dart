// Mocks generated by Mockito 5.4.4 from annotations
// in golden_cli/test/src/commands/test_command_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:convert' as _i7;
import 'dart:io' as _i3;

import 'package:mason_logger/mason_logger.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:process/src/interface/process_manager.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLogTheme_0 extends _i1.SmartFake implements _i2.LogTheme {
  _FakeLogTheme_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProgressOptions_1 extends _i1.SmartFake
    implements _i2.ProgressOptions {
  _FakeProgressOptions_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProgress_2 extends _i1.SmartFake implements _i2.Progress {
  _FakeProgress_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProcess_3 extends _i1.SmartFake implements _i3.Process {
  _FakeProcess_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i2.Logger {
  MockLogger() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.LogTheme get theme => (super.noSuchMethod(
        Invocation.getter(#theme),
        returnValue: _FakeLogTheme_0(
          this,
          Invocation.getter(#theme),
        ),
      ) as _i2.LogTheme);

  @override
  _i2.Level get level => (super.noSuchMethod(
        Invocation.getter(#level),
        returnValue: _i2.Level.verbose,
      ) as _i2.Level);

  @override
  set level(_i2.Level? _level) => super.noSuchMethod(
        Invocation.setter(
          #level,
          _level,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.ProgressOptions get progressOptions => (super.noSuchMethod(
        Invocation.getter(#progressOptions),
        returnValue: _FakeProgressOptions_1(
          this,
          Invocation.getter(#progressOptions),
        ),
      ) as _i2.ProgressOptions);

  @override
  set progressOptions(_i2.ProgressOptions? _progressOptions) =>
      super.noSuchMethod(
        Invocation.setter(
          #progressOptions,
          _progressOptions,
        ),
        returnValueForMissingStub: null,
      );

  @override
  void flush([void Function(String?)? print]) => super.noSuchMethod(
        Invocation.method(
          #flush,
          [print],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void write(String? message) => super.noSuchMethod(
        Invocation.method(
          #write,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void info(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #info,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void delayed(String? message) => super.noSuchMethod(
        Invocation.method(
          #delayed,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Progress progress(
    String? message, {
    _i2.ProgressOptions? options,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #progress,
          [message],
          {#options: options},
        ),
        returnValue: _FakeProgress_2(
          this,
          Invocation.method(
            #progress,
            [message],
            {#options: options},
          ),
        ),
      ) as _i2.Progress);

  @override
  void err(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #err,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void alert(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #alert,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void detail(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #detail,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void warn(
    String? message, {
    String? tag = r'WARN',
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #warn,
          [message],
          {
            #tag: tag,
            #style: style,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void success(
    String? message, {
    _i2.LogStyle? style,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #success,
          [message],
          {#style: style},
        ),
        returnValueForMissingStub: null,
      );

  @override
  String prompt(
    String? message, {
    Object? defaultValue,
    bool? hidden = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prompt,
          [message],
          {
            #defaultValue: defaultValue,
            #hidden: hidden,
          },
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #prompt,
            [message],
            {
              #defaultValue: defaultValue,
              #hidden: hidden,
            },
          ),
        ),
      ) as String);

  @override
  List<String> promptAny(
    String? message, {
    String? separator = r',',
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #promptAny,
          [message],
          {#separator: separator},
        ),
        returnValue: <String>[],
      ) as List<String>);

  @override
  bool confirm(
    String? message, {
    bool? defaultValue = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirm,
          [message],
          {#defaultValue: defaultValue},
        ),
        returnValue: false,
      ) as bool);

  @override
  T chooseOne<T extends Object?>(
    String? message, {
    required List<T>? choices,
    T? defaultValue,
    String Function(T)? display,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #chooseOne,
          [message],
          {
            #choices: choices,
            #defaultValue: defaultValue,
            #display: display,
          },
        ),
        returnValue: _i4.dummyValue<T>(
          this,
          Invocation.method(
            #chooseOne,
            [message],
            {
              #choices: choices,
              #defaultValue: defaultValue,
              #display: display,
            },
          ),
        ),
      ) as T);

  @override
  List<T> chooseAny<T extends Object?>(
    String? message, {
    required List<T>? choices,
    List<T>? defaultValues,
    String Function(T)? display,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #chooseAny,
          [message],
          {
            #choices: choices,
            #defaultValues: defaultValues,
            #display: display,
          },
        ),
        returnValue: <T>[],
      ) as List<T>);
}

/// A class which mocks [ProcessManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockProcessManager extends _i1.Mock implements _i5.ProcessManager {
  MockProcessManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i3.Process> start(
    List<Object>? command, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool? includeParentEnvironment = true,
    bool? runInShell = false,
    _i3.ProcessStartMode? mode = _i3.ProcessStartMode.normal,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #start,
          [command],
          {
            #workingDirectory: workingDirectory,
            #environment: environment,
            #includeParentEnvironment: includeParentEnvironment,
            #runInShell: runInShell,
            #mode: mode,
          },
        ),
        returnValue: _i6.Future<_i3.Process>.value(_FakeProcess_3(
          this,
          Invocation.method(
            #start,
            [command],
            {
              #workingDirectory: workingDirectory,
              #environment: environment,
              #includeParentEnvironment: includeParentEnvironment,
              #runInShell: runInShell,
              #mode: mode,
            },
          ),
        )),
      ) as _i6.Future<_i3.Process>);

  @override
  _i6.Future<_i3.ProcessResult> run(
    List<Object>? command, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool? includeParentEnvironment = true,
    bool? runInShell = false,
    _i7.Encoding? stdoutEncoding = const _i3.SystemEncoding(),
    _i7.Encoding? stderrEncoding = const _i3.SystemEncoding(),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #run,
          [command],
          {
            #workingDirectory: workingDirectory,
            #environment: environment,
            #includeParentEnvironment: includeParentEnvironment,
            #runInShell: runInShell,
            #stdoutEncoding: stdoutEncoding,
            #stderrEncoding: stderrEncoding,
          },
        ),
        returnValue: _i6.Future<_i3.ProcessResult>.value(
            _i4.dummyValue<_i3.ProcessResult>(
          this,
          Invocation.method(
            #run,
            [command],
            {
              #workingDirectory: workingDirectory,
              #environment: environment,
              #includeParentEnvironment: includeParentEnvironment,
              #runInShell: runInShell,
              #stdoutEncoding: stdoutEncoding,
              #stderrEncoding: stderrEncoding,
            },
          ),
        )),
      ) as _i6.Future<_i3.ProcessResult>);

  @override
  _i3.ProcessResult runSync(
    List<Object>? command, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool? includeParentEnvironment = true,
    bool? runInShell = false,
    _i7.Encoding? stdoutEncoding = const _i3.SystemEncoding(),
    _i7.Encoding? stderrEncoding = const _i3.SystemEncoding(),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #runSync,
          [command],
          {
            #workingDirectory: workingDirectory,
            #environment: environment,
            #includeParentEnvironment: includeParentEnvironment,
            #runInShell: runInShell,
            #stdoutEncoding: stdoutEncoding,
            #stderrEncoding: stderrEncoding,
          },
        ),
        returnValue: _i4.dummyValue<_i3.ProcessResult>(
          this,
          Invocation.method(
            #runSync,
            [command],
            {
              #workingDirectory: workingDirectory,
              #environment: environment,
              #includeParentEnvironment: includeParentEnvironment,
              #runInShell: runInShell,
              #stdoutEncoding: stdoutEncoding,
              #stderrEncoding: stderrEncoding,
            },
          ),
        ),
      ) as _i3.ProcessResult);

  @override
  bool canRun(
    dynamic executable, {
    String? workingDirectory,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #canRun,
          [executable],
          {#workingDirectory: workingDirectory},
        ),
        returnValue: false,
      ) as bool);

  @override
  bool killPid(
    int? pid, [
    _i3.ProcessSignal? signal = _i3.ProcessSignal.sigterm,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #killPid,
          [
            pid,
            signal,
          ],
        ),
        returnValue: false,
      ) as bool);
}