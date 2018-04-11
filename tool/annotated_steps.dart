// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:io";

Uri baseUri = Platform.script.resolve("../../../../../");

runBuildRunnerInDirectory(String directory) async {
  print("^^^^^ Current working directory: ${Directory.current}");
  Map<String, String> environment =
      new Map<String, String>.from(Platform.environment);
  Directory.current = directory;  
    Process process = await Process.start(
      'pub', ['run', 'build_runner', 'test'], environment: environment);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  return process.exitCode;
}

// Expects to be called with the path to the package root.
// See .test_config.
main(List<String> arguments) async {
  String packagePath = arguments[0];
  print("^^^^^^^ Run 'annotated_steps.dart' in $packagePath");
  int exitCode = await runBuildRunnerInDirectory(packagePath);
  print("^^^^^^^ Done 'annotated_steps.dart'");
  if (exitCode != 0) exit(1);
}
