import 'package:serverpod/serverpod.dart';

import '../access/access.dart';
import '../generated/protocol.dart';

/// Loads a realistic high-mix job shop so a new workspace is useful in one
/// tap. This is sample *data*, not sample behaviour: every row goes through
/// the same solver and endpoints as anything the user types.
class DemoService {
  const DemoService();

  Future<int> load(Session session, Shop shop) async {
    final existing = await Job.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      limit: 1,
    );
    final existingCenters = await WorkCenter.db.find(
      session,
      where: (t) => t.shopId.equals(shop.id!),
      limit: 1,
    );
    if (existing.isNotEmpty || existingCenters.isNotEmpty) {
      throw WorkspaceException(
        'This workspace already has data. Delete its jobs and work centers '
        'before loading the sample.',
      );
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    final centers = await WorkCenter.db.insert(session, [
      WorkCenter(
        shopId: shop.id!,
        name: 'CNC Mill 1',
        code: 'CNC-01',
        machines: 2,
        changeoverMinutes: 25,
        notes: 'Two 3-axis vertical mills',
      ),
      WorkCenter(
        shopId: shop.id!,
        name: 'CNC Mill 2',
        code: 'CNC-02',
        machines: 1,
        changeoverMinutes: 30,
        notes: 'Large-envelope mill, single spindle',
      ),
      WorkCenter(
        shopId: shop.id!,
        name: 'Turning',
        code: 'LATHE',
        machines: 1,
        changeoverMinutes: 20,
        notes: 'CNC lathe with bar feeder',
      ),
      WorkCenter(
        shopId: shop.id!,
        name: 'Deburr',
        code: 'DEBURR',
        machines: 2,
        changeoverMinutes: 5,
        notes: 'Manual benches',
      ),
      WorkCenter(
        shopId: shop.id!,
        name: 'Assembly',
        code: 'ASSY',
        machines: 2,
        changeoverMinutes: 10,
        notes: 'Fitters, two bays',
      ),
      WorkCenter(
        shopId: shop.id!,
        name: 'Inspection',
        code: 'INSP',
        machines: 1,
        changeoverMinutes: 5,
        notes: 'CMM and hand tools',
      ),
      WorkCenter(
        shopId: shop.id!,
        name: 'Paint',
        code: 'PAINT',
        machines: 1,
        changeoverMinutes: 40,
        notes: 'Batch booth, colour changes hurt',
      ),
    ]);

    final centerByCode = <String, int>{
      for (final center in centers) center.code: center.id!,
    };

    for (final demo in _demoJobs) {
      final inserted = await Job.db.insert(session, [
        Job(
          shopId: shop.id!,
          code: demo.code,
          title: demo.title,
          customer: demo.customer,
          quantity: demo.quantity,
          dueAt: start.add(Duration(days: demo.dueDays, hours: 17)),
          releaseAt: start.add(Duration(days: demo.releaseDays)),
          priority: demo.priority,
          notes: demo.notes,
        ),
      ]);
      final job = inserted.first;

      final operations = <Operation>[];
      var sequence = 10;
      for (final step in demo.routing) {
        operations.add(
          Operation(
            jobId: job.id!,
            sequence: sequence,
            workCenterId: centerByCode[step.center]!,
            setupMinutes: step.setupMinutes,
            unitRunMinutes: step.runMinutesPerUnit,
            description: step.description,
          ),
        );
        sequence += 10;
      }
      await Operation.db.insert(session, operations);
    }
    return _demoJobs.length;
  }
}

class _DemoJob {
  const _DemoJob({
    required this.code,
    required this.title,
    required this.customer,
    required this.quantity,
    required this.dueDays,
    required this.releaseDays,
    required this.priority,
    required this.routing,
    this.notes = '',
  });

  final String code;
  final String title;
  final String customer;
  final int quantity;
  final int dueDays;
  final int releaseDays;
  final int priority;
  final List<_Step> routing;
  final String notes;
}

class _Step {
  const _Step({
    required this.center,
    required this.description,
    required this.setupMinutes,
    required this.runMinutesPerUnit,
  });

  final String center;
  final String description;
  final int setupMinutes;
  final double runMinutesPerUnit;
}

const _demoJobs = <_DemoJob>[
  _DemoJob(
    code: 'J-1041',
    title: 'Hydraulic manifold block',
    customer: 'Northline Hydraulics',
    quantity: 12,
    dueDays: 3,
    releaseDays: 0,
    priority: 3,
    notes: 'Customer inspection required before dispatch.',
    routing: [
      _Step(
        center: 'CNC-01',
        description: 'Face and pocket',
        setupMinutes: 60,
        runMinutesPerUnit: 8,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 5,
        runMinutesPerUnit: 2,
      ),
      _Step(
        center: 'INSP',
        description: 'CMM check',
        setupMinutes: 10,
        runMinutesPerUnit: 3,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1042',
    title: 'Pump housing',
    customer: 'Northline Hydraulics',
    quantity: 60,
    dueDays: 2,
    releaseDays: 0,
    priority: 2,
    routing: [
      _Step(
        center: 'CNC-02',
        description: 'Bore and face',
        setupMinutes: 90,
        runMinutesPerUnit: 14,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 5,
        runMinutesPerUnit: 2,
      ),
      _Step(
        center: 'ASSY',
        description: 'Fit seals',
        setupMinutes: 20,
        runMinutesPerUnit: 6,
      ),
      _Step(
        center: 'INSP',
        description: 'Pressure test',
        setupMinutes: 10,
        runMinutesPerUnit: 2,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1043',
    title: 'Valve body',
    customer: 'Meridian Fluid',
    quantity: 25,
    dueDays: 2,
    releaseDays: 0,
    priority: 3,
    routing: [
      _Step(
        center: 'LATHE',
        description: 'Turn and thread',
        setupMinutes: 45,
        runMinutesPerUnit: 9,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 5,
        runMinutesPerUnit: 2,
      ),
      _Step(
        center: 'INSP',
        description: 'Thread gauge',
        setupMinutes: 8,
        runMinutesPerUnit: 3,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1044',
    title: 'Gearbox cover',
    customer: 'Calder Drive',
    quantity: 60,
    dueDays: 7,
    releaseDays: 0,
    priority: 1,
    routing: [
      _Step(
        center: 'CNC-01',
        description: 'Rough and finish',
        setupMinutes: 75,
        runMinutesPerUnit: 11,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 5,
        runMinutesPerUnit: 1,
      ),
      _Step(
        center: 'PAINT',
        description: 'Prime and topcoat',
        setupMinutes: 30,
        runMinutesPerUnit: 4,
      ),
      _Step(
        center: 'ASSY',
        description: 'Fit breather',
        setupMinutes: 15,
        runMinutesPerUnit: 3,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1045',
    title: 'Bracket set',
    customer: 'Calder Drive',
    quantity: 300,
    dueDays: 1,
    releaseDays: 0,
    priority: 2,
    routing: [
      _Step(
        center: 'CNC-02',
        description: 'Mill profile',
        setupMinutes: 40,
        runMinutesPerUnit: 3,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Tumble and deburr',
        setupMinutes: 10,
        runMinutesPerUnit: 1,
      ),
      _Step(
        center: 'PAINT',
        description: 'Powder coat',
        setupMinutes: 25,
        runMinutesPerUnit: 2,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1046',
    title: 'Drive shaft',
    customer: 'Voss Equipment',
    quantity: 30,
    dueDays: 6,
    releaseDays: 0,
    priority: 1,
    routing: [
      _Step(
        center: 'LATHE',
        description: 'Turn journals',
        setupMinutes: 60,
        runMinutesPerUnit: 12,
      ),
      _Step(
        center: 'INSP',
        description: 'Runout check',
        setupMinutes: 12,
        runMinutesPerUnit: 4,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1047',
    title: 'Manifold block (rush)',
    customer: 'Northline Hydraulics',
    quantity: 6,
    dueDays: 1,
    releaseDays: 0,
    priority: 3,
    notes: 'Air-freight slots already booked.',
    routing: [
      _Step(
        center: 'CNC-01',
        description: 'Face and drill',
        setupMinutes: 60,
        runMinutesPerUnit: 10,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 5,
        runMinutesPerUnit: 3,
      ),
      _Step(
        center: 'INSP',
        description: 'CMM check',
        setupMinutes: 10,
        runMinutesPerUnit: 3,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1048',
    title: 'Housing weldment',
    customer: 'Voss Equipment',
    quantity: 30,
    dueDays: 3,
    releaseDays: 2,
    priority: 1,
    notes: 'Castings land on day two.',
    routing: [
      _Step(
        center: 'CNC-02',
        description: 'Face mounting pads',
        setupMinutes: 80,
        runMinutesPerUnit: 16,
      ),
      _Step(
        center: 'ASSY',
        description: 'Weld and align',
        setupMinutes: 30,
        runMinutesPerUnit: 10,
      ),
      _Step(
        center: 'INSP',
        description: 'Dimensional report',
        setupMinutes: 12,
        runMinutesPerUnit: 3,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1049',
    title: 'Piston rod',
    customer: 'Voss Equipment',
    quantity: 80,
    dueDays: 9,
    releaseDays: 0,
    priority: 1,
    routing: [
      _Step(
        center: 'LATHE',
        description: 'Turn and polish',
        setupMinutes: 50,
        runMinutesPerUnit: 6,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Chamfer',
        setupMinutes: 8,
        runMinutesPerUnit: 1,
      ),
      _Step(
        center: 'INSP',
        description: 'Hardness and finish',
        setupMinutes: 10,
        runMinutesPerUnit: 2,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1050',
    title: 'Control arm',
    customer: 'Meridian Fluid',
    quantity: 45,
    dueDays: 3,
    releaseDays: 0,
    priority: 2,
    routing: [
      _Step(
        center: 'CNC-01',
        description: 'Mill slot and holes',
        setupMinutes: 55,
        runMinutesPerUnit: 7,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 5,
        runMinutesPerUnit: 2,
      ),
      _Step(
        center: 'PAINT',
        description: 'Topcoat',
        setupMinutes: 20,
        runMinutesPerUnit: 3,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1051',
    title: 'Adapter plate',
    customer: 'Meridian Fluid',
    quantity: 240,
    dueDays: 1,
    releaseDays: 0,
    priority: 1,
    routing: [
      _Step(
        center: 'CNC-02',
        description: 'Mill outline and holes',
        setupMinutes: 35,
        runMinutesPerUnit: 4,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Tumble and deburr',
        setupMinutes: 10,
        runMinutesPerUnit: 1,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1052',
    title: 'Sensor mount',
    customer: 'Alder Controls',
    quantity: 300,
    dueDays: 10,
    releaseDays: 1,
    priority: 1,
    routing: [
      _Step(
        center: 'CNC-01',
        description: 'Mill profile',
        setupMinutes: 45,
        runMinutesPerUnit: 2,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Tumble',
        setupMinutes: 10,
        runMinutesPerUnit: 1,
      ),
      _Step(
        center: 'INSP',
        description: 'Sample check',
        setupMinutes: 8,
        runMinutesPerUnit: 1,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1053',
    title: 'Valve stem',
    customer: 'Alder Controls',
    quantity: 150,
    dueDays: 4,
    releaseDays: 0,
    priority: 2,
    routing: [
      _Step(
        center: 'LATHE',
        description: 'Turn and thread',
        setupMinutes: 40,
        runMinutesPerUnit: 4,
      ),
      _Step(
        center: 'DEBURR',
        description: 'Break edges',
        setupMinutes: 8,
        runMinutesPerUnit: 1,
      ),
      _Step(
        center: 'INSP',
        description: 'Thread gauge',
        setupMinutes: 8,
        runMinutesPerUnit: 1,
      ),
    ],
  ),
  _DemoJob(
    code: 'J-1054',
    title: 'End cap',
    customer: 'Alder Controls',
    quantity: 160,
    dueDays: 1,
    releaseDays: 0,
    priority: 1,
    routing: [
      _Step(
        center: 'CNC-02',
        description: 'Turn and face',
        setupMinutes: 50,
        runMinutesPerUnit: 5,
      ),
      _Step(
        center: 'PAINT',
        description: 'Topcoat',
        setupMinutes: 25,
        runMinutesPerUnit: 2,
      ),
    ],
  ),
];
