import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';

class WorkCenterEndpoint extends Endpoint {
  Future<List<WorkCenter>> list(Session session, String accessKey) async {
    final shop = await requireShop(session, accessKey);
    return WorkCenter.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      orderBy: (t) => t.code,
    );
  }

  Future<WorkCenter> save(
    Session session,
    String accessKey,
    WorkCenter center,
  ) async {
    final shop = await requireShop(session, accessKey);
    final name = center.name.trim();
    if (name.isEmpty) {
      throw WorkspaceException('Give the work center a name.');
    }

    final code = center.code.trim().isEmpty
        ? _deriveCode(name)
        : center.code.trim().toUpperCase();
    final machines = center.machines < 1
        ? 1
        : center.machines > 99
        ? 99
        : center.machines;
    final changeover = center.changeoverMinutes < 0
        ? 0
        : center.changeoverMinutes;

    if (center.id == null) {
      final rows = await WorkCenter.db.insert(session, [
        WorkCenter(
          shopId: shop.id!,
          name: name,
          code: code,
          machines: machines,
          changeoverMinutes: changeover,
          notes: center.notes.trim(),
        ),
      ]);
      return rows.first;
    }

    final rows = await WorkCenter.db.find(
      session,
      where: (t) => t.id.equals(center.id!),
      limit: 1,
    );
    if (rows.isEmpty || rows.first.shopId != shop.id) {
      throw WorkspaceException('That work center is not in this shop.');
    }

    final row = rows.first;
    row.name = name;
    row.code = code;
    row.machines = machines;
    row.changeoverMinutes = changeover;
    row.notes = center.notes.trim();
    await WorkCenter.db.update(session, [row]);
    return row;
  }

  Future<bool> remove(Session session, String accessKey, int id) async {
    final shop = await requireShop(session, accessKey);
    final rows = await WorkCenter.db.find(
      session,
      where: (t) => t.id.equals(id),
      limit: 1,
    );
    if (rows.isEmpty || rows.first.shopId != shop.id) {
      throw WorkspaceException('That work center is not in this shop.');
    }

    final used = await Operation.db.find(
      session,
      where: (t) => t.workCenterId.equals(id),
      limit: 1,
    );
    if (used.isNotEmpty) {
      throw WorkspaceException(
        'That work center is used in a routing. Remove those steps first.',
      );
    }

    await WorkCenter.db.deleteWhere(session, where: (t) => t.id.equals(id));
    return true;
  }

  String _deriveCode(String name) {
    final letters = name
        .toUpperCase()
        .split(RegExp('[^A-Z0-9]+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (letters.isEmpty) return 'WC';
    if (letters.length == 1) {
      return letters.first.substring(0, letters.first.length.clamp(1, 8));
    }
    return letters.map((part) => part[0]).join().substring(0, 6);
  }
}
