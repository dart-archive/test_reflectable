// Copyright (c) 2015, the Dart Team. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in
// the LICENSE file.

/// File used to test reflectable code generation.
/// Creates an `AllReflectorsMetaReflector` which may be used to reflect on
/// the set of reflectors themselves.
library test_reflectable.test.reflectors_test;

@GlobalQuantifyCapability(r'.(A|B)$', Reflector3())
@GlobalQuantifyMetaCapability(P, Reflector4())
@GlobalQuantifyCapability(r'^reflectable.reflectable.Reflectable$',
    AllReflectorsMetaReflector())
import 'package:reflectable/reflectable.dart';
import 'package:test/test.dart';
import 'reflectors_test.reflectable.dart';

/// Used to get access to all reflectors.
class AllReflectorsMetaReflector extends Reflectable {
  const AllReflectorsMetaReflector()
      : super(subtypeQuantifyCapability, newInstanceCapability);

  Set<Reflectable> get reflectors {
    Set<Reflectable> result = Set<Reflectable>();
    annotatedClasses.forEach((ClassMirror classMirror) {
      if (classMirror.isAbstract) return;
      Reflectable reflector =
          Reflectable.getInstance(classMirror.reflectedType);
      if (reflector != null) result.add(reflector);
    });
    return result;
  }
}

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability, libraryCapability);
}

class Reflector2 extends Reflectable {
  const Reflector2()
      : super(invokingCapability, metadataCapability, libraryCapability);
}

class Reflector3 extends Reflectable {
  const Reflector3() : super(invokingCapability);
}

class Reflector4 extends Reflectable {
  const Reflector4() : super(declarationsCapability);
}

class ReflectorUpwardsClosed extends Reflectable {
  const ReflectorUpwardsClosed()
      : super(superclassQuantifyCapability, invokingCapability,
            declarationsCapability, typeRelationsCapability);
}

class ReflectorUpwardsClosedToA extends Reflectable {
  const ReflectorUpwardsClosedToA()
      : super(const SuperclassQuantifyCapability(A), invokingCapability,
            declarationsCapability);
}

class ReflectorUpwardsClosedUntilA extends Reflectable {
  const ReflectorUpwardsClosedUntilA()
      : super(const SuperclassQuantifyCapability(A, excludeUpperBound: true),
            invokingCapability, declarationsCapability);
}

@Reflector()
@Reflector2()
@P()
class M1 {
  foo() {}
  var field;
  static staticFoo(x) {}
}

class P {
  const P();
}

@Reflector()
@Reflector2()
class M2 {}

@Reflector()
@Reflector2()
class M3 {}

@Reflector()
class A {
  foo() {}
  var field;
  static staticFoo(x) {}
  static staticBar() {}
}

@Reflector()
@Reflector2()
class B extends A with M1 {}

@Reflector()
@Reflector2()
@ReflectorUpwardsClosed()
@ReflectorUpwardsClosedUntilA()
class C extends B with M2, M3 {}

@Reflector()
@Reflector2()
@ReflectorUpwardsClosed()
@ReflectorUpwardsClosedToA()
class D = A with M1;

void main() {
  initializeReflectable();

  List<Reflectable> reflectors =
      const AllReflectorsMetaReflector().reflectors.toList();

  test('Mixin, superclasses not included', () {
    expect(
        reflectors,
        const [
          Reflector(),
          Reflector2(),
          Reflector3(),
          Reflector4(),
          ReflectorUpwardsClosed(),
          ReflectorUpwardsClosedToA(),
          ReflectorUpwardsClosedUntilA(),
          AllReflectorsMetaReflector(),
        ].toSet());
  });
}
