import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';

class JobEndpoint extends Endpoint {
  Future<List<JobBundle>> list(Session session, String accessKey) async {
    final access = await requireShop(session, accessKey);
    final shop = access.shop;
    final jobs = await Job.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      orderBy: (t) => t.dueAt,
    );
    if (jobs.isEmpty) return const [];

    final jobIds = jobs.map((j) => j.id).whereType<int>().toSet();
    final operations = await Operation.db.find(
      session,
      where: (t) => t.jobId.inSet(jobIds),
      orderBy: (t) => t.sequence,
    );
    final byJob = <int, List<Operation>>{};
    for (final op in operations) {
      byJob.putIfAbsent(op.jobId, () => []).add(op);
    }

    return [
      for (final job in jobs)
        JobBundle(
          job: job,
          operations: (byJob[job.id] ?? const <Operation>[])
            ..sort((a, b) => a.sequence.compareTo(b.sequence)),
        ),
    ];
  }

  Future<JobBundle> save(
    Session session,
    String accessKey,
    JobBundle bundle,
  ) async {
    final access = await requireShop(session, accessKey, write: true);
    final shop = access.shop;
    final incoming = bundle.job;
    final code = incoming.code.trim();

    if (code.isEmpty) {
      throw TaktException(message: 'Every job needs a reference.');
    }
    if (incoming.quantity < 1) {
      throw TaktException(message: 'Quantity must be at least 1.');
    }
    if (bundle.operations.isEmpty) {
      throw TaktException(message: 'A job needs at least one routing step.');
    }

    // Validate the whole routing before touching the job. A cross-shop work
    // center id must never enter a routing, and a bad step must not leave an
    // edited job with its old operations already deleted.
    final centers = await WorkCenter.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
    );
    final centerIds = {
      for (final center in centers) center.id,
    }.whereType<int>().toSet();
    for (final op in bundle.operations) {
      if (op.workCenterId <= 0 || !centerIds.contains(op.workCenterId)) {
        throw TaktException(
          message: 'Pick a work center from this shop for every step.',
        );
      }
    }

    Job saved;
    if (incoming.id == null) {
      final rows = await Job.db.insert(session, [
        Job(
          shopId: shop.id!,
          code: code,
          title: incoming.title.trim(),
          customer: incoming.customer.trim(),
          quantity: incoming.quantity,
          dueAt: incoming.dueAt,
          releaseAt: incoming.releaseAt,
          priority: incoming.priority.clamp(1, 3),
          notes: incoming.notes.trim(),
        ),
      ]);
      saved = rows.first;
    } else {
      final rows = await Job.db.find(
        session,
        where: (t) => t.id.equals(incoming.id!),
        limit: 1,
      );
      if (rows.isEmpty || rows.first.shopId != shop.id) {
        throw TaktException(message: 'That job is not in this shop.');
      }
      saved = rows.first;
      saved.code = code;
      saved.title = incoming.title.trim();
      saved.customer = incoming.customer.trim();
      saved.quantity = incoming.quantity;
      saved.dueAt = incoming.dueAt;
      saved.releaseAt = incoming.releaseAt;
      saved.priority = incoming.priority.clamp(1, 3);
      saved.notes = incoming.notes.trim();
      await Job.db.update(session, [saved]);
      await Operation.db.deleteWhere(
        session,
        where: (t) => t.jobId.equals(saved.id!),
      );
    }

    var sequence = 10;
    final rows = <Operation>[];
    for (final op in bundle.operations) {
      rows.add(
        Operation(
          jobId: saved.id!,
          sequence: sequence,
          workCenterId: op.workCenterId,
          setupMinutes: op.setupMinutes < 0 ? 0 : op.setupMinutes,
          unitRunMinutes: op.unitRunMinutes < 0 ? 0 : op.unitRunMinutes,
          description: op.description.trim(),
        ),
      );
      sequence += 10;
    }

    final savedOps = await Operation.db.insert(session, rows);
    savedOps.sort((a, b) => a.sequence.compareTo(b.sequence));
    return JobBundle(job: saved, operations: savedOps);
  }

  Future<bool> remove(Session session, String accessKey, int id) async {
    final access = await requireShop(session, accessKey, write: true);
    final shop = access.shop;
    final rows = await Job.db.find(
      session,
      where: (t) => t.id.equals(id),
      limit: 1,
    );
    if (rows.isEmpty || rows.first.shopId != shop.id) {
      throw TaktException(message: 'That job is not in this shop.');
    }
    await Operation.db.deleteWhere(session, where: (t) => t.jobId.equals(id));
    await Job.db.deleteWhere(session, where: (t) => t.id.equals(id));
    return true;
  }
}
