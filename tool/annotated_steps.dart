// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:io";

Uri baseUri = Platform.script.resolve("../../../../../");

int runBuildRunnerInDirectory(String directory) async {
  print("^^^ Current working directory: ${Directory.current}");
  Map<String, String> environment =
      new Map<String, String>.from(Platform.environment);
  Directory.current = directory;
  print("^^^ Current working directory after change: ${Directory.current}");

  Process process1 =
      await Process.start('pub', ['get'], environment: environment);
  stdout.addStream(process1.stdout);
  stderr.addStream(process1.stderr);
  int exitCode = await process1.exitCode;
  if (exitCode != 0) return process1.exitCode;

  Process process2 = await Process.start('pub', ['run', 'build_runner', 'test'],
      environment: environment);
  stdout.addStream(process2.stdout);
  stderr.addStream(process2.stderr);
  return process2.exitCode;
}

// Expects to be called with the path to the package root.
// See .test_config.
main(List<String> arguments) async {
  String packagePath = arguments[0];
  print("^^^ Run 'annotated_steps.dart' in $packagePath");
  int exitCode = await runBuildRunnerInDirectory(packagePath);
  print("^^^ Done 'annotated_steps.dart'");
  if (exitCode != 0) exit(1);
}
