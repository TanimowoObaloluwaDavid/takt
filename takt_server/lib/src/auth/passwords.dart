import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';

/// Password hashing and bearer-token helpers.
///
/// Passwords use Argon2id with 19 MiB of memory and two passes. The PHC
/// string stores its own parameters, so the cost can be raised later without
/// invalidating existing hashes. Argon2 runs in an isolate so a login cannot
/// block other requests.
const _memoryKiB = 19456;
const _iterations = 2;
const _lanes = 1;
const _hashLength = 32;
const _saltLength = 16;

final _random = Random.secure();
final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String normalizeEmail(String raw) => raw.trim().toLowerCase();

bool isValidEmail(String email) =>
    email.length <= 254 && _emailPattern.hasMatch(email);

/// Returns an error message, or null when the password is acceptable.
String? validatePassword(String password) {
  if (password.length < 10) {
    return 'Use at least 10 characters for your password.';
  }
  if (password.length > 128) {
    return 'Use 128 characters or fewer for your password.';
  }
  return null;
}

String? validateDisplayName(String raw) {
  final name = raw.trim();
  if (name.isEmpty) return 'Tell us what to call you.';
  if (name.length > 60) return 'Keep your name to 60 characters or fewer.';
  return null;
}

/// A 256-bit, URL-safe session token. The prefix makes tokens easy to
/// distinguish from workspace keys without weakening their entropy.
String generateSessionToken() {
  final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
  return 'takt_${base64UrlEncode(bytes).replaceAll('=', '')}';
}

String hashToken(String token) => sha256.convert(utf8.encode(token)).toString();

Future<String> hashPassword(String password) async {
  final salt = _randomBytes(_saltLength);
  final hash = await _argon2(
    password: password,
    salt: salt,
    memory: _memoryKiB,
    iterations: _iterations,
    lanes: _lanes,
    length: _hashLength,
  );
  return '\$argon2id\$v=19\$m=$_memoryKiB,t=$_iterations,p=$_lanes'
      '\$${base64Encode(salt)}\$${base64Encode(hash)}';
}

Future<bool> verifyPassword(String password, String encoded) async {
  final parts = encoded.split(r'$');
  if (parts.length != 6 ||
      parts[0].isNotEmpty ||
      parts[1] != 'argon2id' ||
      parts[2] != 'v=19') {
    return false;
  }

  final params = <String, int>{};
  for (final part in parts[3].split(',')) {
    final pieces = part.split('=');
    if (pieces.length != 2) return false;
    final value = int.tryParse(pieces[1]);
    if (value == null) return false;
    params[pieces[0]] = value;
  }

  final memory = params['m'];
  final iterations = params['t'];
  final lanes = params['p'];
  if (memory == null ||
      iterations == null ||
      lanes == null ||
      memory < 1024 ||
      memory > 65536 ||
      iterations < 1 ||
      iterations > 8 ||
      lanes < 1 ||
      lanes > 4) {
    return false;
  }

  final Uint8List salt;
  final Uint8List expected;
  try {
    salt = base64Decode(parts[4]);
    expected = base64Decode(parts[5]);
  } catch (_) {
    return false;
  }
  if (salt.length < 8 || expected.isEmpty || expected.length > 64) {
    return false;
  }

  final actual = await _argon2(
    password: password,
    salt: salt,
    memory: memory,
    iterations: iterations,
    lanes: lanes,
    length: expected.length,
  );
  return _constantTimeEquals(actual, expected);
}

/// Verifying an unknown email still performs one Argon2 derivation so the
/// response time does not reveal whether the account exists.
String? _dummyHash;
Future<void> burnPasswordTime(String password) async {
  _dummyHash ??= await hashPassword('takt-dummy-password-for-timing');
  await verifyPassword(password, _dummyHash!);
}

Future<Uint8List> _argon2({
  required String password,
  required Uint8List salt,
  required int memory,
  required int iterations,
  required int lanes,
  required int length,
}) {
  return Isolate.run(() {
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      desiredKeyLength: length,
      memory: memory,
      iterations: iterations,
      lanes: lanes,
    );
    final generator = Argon2BytesGenerator()..init(parameters);
    return generator.process(Uint8List.fromList(utf8.encode(password)));
  });
}

Uint8List _randomBytes(int length) =>
    Uint8List.fromList(List<int>.generate(length, (_) => _random.nextInt(256)));

bool _constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var difference = 0;
  for (var index = 0; index < a.length; index++) {
    difference |= a[index] ^ b[index];
  }
  return difference == 0;
}

/// Small in-process throttle. It is deliberately simple: a single Serverpod
/// isolate protects one process, and the account is still protected by
/// Argon2 if this cache is cleared by a restart.
class LoginThrottle {
  static const _maxFailures = 5;
  static const _window = Duration(minutes: 10);
  static final _failures = <String, _FailureWindow>{};

  static void check(String email) {
    final window = _failures[email];
    if (window == null) return;
    if (DateTime.now().difference(window.startedAt) > _window) {
      _failures.remove(email);
      return;
    }
    if (window.count >= _maxFailures) {
      throw const ThrottledLoginException();
    }
  }

  static void fail(String email) {
    final now = DateTime.now();
    final existing = _failures[email];
    if (existing == null || now.difference(existing.startedAt) > _window) {
      _failures[email] = _FailureWindow(now, 1);
    } else {
      existing.count += 1;
    }
  }

  static void succeed(String email) => _failures.remove(email);
}

class _FailureWindow {
  _FailureWindow(this.startedAt, this.count);
  final DateTime startedAt;
  int count;
}

class ThrottledLoginException implements Exception {
  const ThrottledLoginException();
  @override
  String toString() =>
      'Too many sign-in attempts. Wait a few minutes and try again.';
}
