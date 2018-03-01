// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:io";

Map<String, String> environment =
    new Map<String, String>.from(Platform.environment);
Uri packageUri = Platform.script.resolve("../");
Uri baseUri = packageUri.resolve("../../../../");

Future<int> runBuilder(String dartPath) async {
  String builderPath = packageUri.resolve("tool/build.dart").toFilePath();
  String builtFileSpec = 'test/*_test.dart';
  print("^^^^^^^ Running dart $builderPath '$builtFileSpec'");
  Process process = await Process.start(
      dartPath, [builderPath, builtFileSpec], environment: environment);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  return process.exitCode;
}

Future<int> runAnnotatedSteps(String pythonPath) async {
  String annotatedStepsPath = baseUri.resolve(
      "third_party/package-bots/annotated_steps.py").toFilePath();
  print("^^^^^^^ Running $annotatedStepsPath");
  Process process = await Process.start(
      pythonPath, [annotatedStepsPath], environment: environment);
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  return process.exitCode;
}

// Expects to be called with the path to a dart executable as the first
// argument, and a path to a python executable as the second argument.
// See .test_config.
main(List<String> arguments) async {
  String dartPath = arguments[0];
  String pythonPath = arguments[1];
  print("^^^^^^^ Running annotated_steps.dart $dartPath $pythonPath");
  List<int> exitCodes = [
    await runBuilder(dartPath),
    await runAnnotatedSteps(pythonPath),
  ];
  print("^^^^^^^ Done running annotated_steps.dart");
  if (!exitCodes.every((int exitCode) => exitCode == 0)) {
    exit(1);
  }
}
