// Copyright (c) 2016, the Dart Team. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in
// the LICENSE file.

// File being transformed by the reflectable transformer.
// Uses a function type in type annotations.

@reflector
library test_reflectable.test.function_type_annotation_test;

import 'package:reflectable/reflectable.dart';
import 'package:test/test.dart';
import 'function_type_annotation_test.reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(instanceInvokeCapability, topLevelInvokeCapability,
            declarationsCapability, reflectedTypeCapability, libraryCapability);
}

const reflector = const Reflector();

typedef int Int2IntFunc(int _);

Int2IntFunc int2int = (int x) => x;

@reflector
class C {
  Int2IntFunc get getter => int2int;
  void set setter(Int2IntFunc int2int) {}
  void method(int noNameType(int _), {Int2IntFunc int2int: null}) {}
}

main() {
  initializeReflectable();

  LibraryMirror libraryMirror = reflector
      .findLibrary("test_reflectable.test.function_type_annotation_test");
  VariableMirror variableMirror = libraryMirror.declarations["int2int"];
  ClassMirror classMirror = reflector.reflectType(C);
  MethodMirror getterMirror = classMirror.declarations["getter"];
  MethodMirror setterMirror = classMirror.declarations["setter="];
  MethodMirror methodMirror = classMirror.declarations["method"];
  ParameterMirror setterArgumentMirror = setterMirror.parameters[0];
  ParameterMirror methodArgument0Mirror = methodMirror.parameters[0];
  ParameterMirror methodArgument1Mirror = methodMirror.parameters[1];

  Type int2intType = const TypeValue<int Function(int)>().type;

  test('Function type as annotation', () {
    expect(variableMirror.hasReflectedType, true);
    expect(variableMirror.reflectedType, int2intType);
    expect(getterMirror.hasReflectedReturnType, true);
    expect(getterMirror.reflectedReturnType, int2intType);
    expect(setterArgumentMirror.hasReflectedType, true);
    expect(setterArgumentMirror.reflectedType, int2intType);
    expect(methodArgument1Mirror.hasReflectedType, true);
    expect(methodArgument1Mirror.reflectedType, int2intType);
    expect(variableMirror.hasDynamicReflectedType, true);
    expect(variableMirror.dynamicReflectedType, int2intType);
    expect(getterMirror.hasDynamicReflectedReturnType, true);
    expect(getterMirror.dynamicReflectedReturnType, int2intType);
    expect(setterArgumentMirror.hasDynamicReflectedType, true);
    expect(setterArgumentMirror.dynamicReflectedType, int2intType);
    expect(methodArgument0Mirror.hasReflectedType, true);
    expect(methodArgument0Mirror.reflectedType, int2intType);
    expect(methodArgument0Mirror.hasDynamicReflectedType, true);
    expect(methodArgument0Mirror.dynamicReflectedType, int2intType);
    expect(methodArgument1Mirror.hasDynamicReflectedType, true);
    expect(methodArgument1Mirror.dynamicReflectedType, int2intType);
  });
}
