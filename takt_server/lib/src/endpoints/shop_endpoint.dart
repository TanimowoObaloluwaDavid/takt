import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';
import '../services/demo_service.dart';

class ShopEndpoint extends Endpoint {
  /// Creates a workspace and returns its one-time bearer key.
  Future<Shop> create(
    Session session,
    String name,
    String currency,
  ) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw WorkspaceException('Give the shop a name.');
    }
    final code = currency.trim().isEmpty
        ? 'USD'
        : currency.trim().toUpperCase();

    final rows = await Shop.db.insert(session, [
      Shop(
        name: trimmed,
        accessKey: generateAccessKey(),
        currency: code,
        // Scheduling is continuous-time today; the field is reserved for shift
        // calendars, which are not modelled yet.
        minutesPerDay: 1440,
        createdAt: DateTime.now(),
      ),
    ]);
    return rows.first;
  }

  Future<Shop> fetch(Session session, String accessKey) async {
    return requireShop(session, accessKey);
  }

  Future<Shop> rename(
    Session session,
    String accessKey,
    String name,
  ) async {
    final shop = await requireShop(session, accessKey);
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw WorkspaceException('Give the shop a name.');
    }
    shop.name = trimmed;
    await Shop.db.update(session, [shop]);
    return shop;
  }

  /// Fills an empty workspace with a realistic sample shop. Returns the
  /// number of jobs loaded. Returning a value (rather than void) keeps the
  /// HTTP response well-defined for every client.
  Future<int> loadDemo(Session session, String accessKey) async {
    final shop = await requireShop(session, accessKey);
    return const DemoService().load(session, shop);
  }
}
