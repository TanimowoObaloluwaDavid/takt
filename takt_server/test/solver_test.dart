import 'package:takt_server/src/solver/diagnosis.dart';
import 'package:takt_server/src/solver/solver.dart';
import 'package:test/test.dart';

SolverOperation op({
  required int id,
  required int wc,
  int setup = 0,
  required int run,
}) {
  return SolverOperation(
    id: id,
    workCenterId: wc,
    setupMinutes: setup,
    runMinutes: run,
  );
}

SolverJob job({
  required int id,
  required int due,
  int release = 0,
  int priority = 1,
  required List<SolverOperation> ops,
  String? code,
}) {
  return SolverJob(
    id: id,
    code: code ?? 'J-$id',
    title: 'Job $id',
    dueMinute: due,
    releaseMinute: release,
    priority: priority,
    operations: ops,
  );
}

SolverWorkCenter wc({
  required int id,
  int machines = 1,
  int changeover = 0,
  String? name,
}) {
  return SolverWorkCenter(
    id: id,
    name: name ?? 'WC-$id',
    machines: machines,
    changeoverMinutes: changeover,
  );
}

void main() {
  group('construction', () {
    test('empty input produces an empty schedule', () {
      const solver = TaktSolver();
      final result = solver.solve(
        const SolverInput(jobs: [], workCenters: [], seed: 1),
      );
      expect(result.placed, isEmpty);
      expect(result.makespan, 0);
    });

    test('a single operation starts at release and finishes on time', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(id: 1, due: 100, ops: [op(id: 10, wc: 1, run: 30)]),
          ],
          workCenters: [wc(id: 1)],
          seed: 1,
        ),
      );
      expect(result.placed, hasLength(1));
      expect(result.jobFinishMinutes[1], 30);
      expect(result.tardinessPerJobForTest(1), 0);
      expect(result.tardyJobs, 0);
    });

    test('operations respect precedence', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(
              id: 1,
              due: 500,
              ops: [
                op(id: 10, wc: 1, run: 20),
                op(id: 11, wc: 2, run: 30),
              ],
            ),
          ],
          workCenters: [wc(id: 1), wc(id: 2)],
          seed: 7,
        ),
      );
      final first = result.placed.firstWhere((p) => p.operationId == 10);
      final second = result.placed.firstWhere((p) => p.operationId == 11);
      expect(second.startMinute, greaterThanOrEqualTo(first.endMinute));
      expect(result.jobFinishMinutes[1], 50);
    });

    test('release dates are respected', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(
              id: 1,
              due: 1000,
              release: 200,
              ops: [op(id: 10, wc: 1, run: 40)],
            ),
          ],
          workCenters: [wc(id: 1)],
          seed: 1,
        ),
      );
      final placed = result.placed.single;
      expect(placed.startMinute, greaterThanOrEqualTo(200));
      expect(placed.endMinute, 240);
    });
  });

  group('capacity', () {
    test('a machine never runs two operations at once', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            for (var i = 0; i < 4; i++)
              job(
                id: i + 1,
                due: 500,
                ops: [op(id: 10 + i, wc: 1, run: 30)],
              ),
          ],
          workCenters: [wc(id: 1)],
          seed: 3,
        ),
      );

      final machine =
          result.placed
              .where((p) => p.workCenterId == 1 && p.machineIndex == 0)
              .toList()
            ..sort((a, b) => a.startMinute.compareTo(b.startMinute));

      expect(machine, hasLength(4));
      for (var i = 1; i < machine.length; i++) {
        expect(
          machine[i].startMinute,
          greaterThanOrEqualTo(machine[i - 1].endMinute),
        );
      }
    });

    test('parallel machines run two jobs concurrently', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(id: 1, due: 500, ops: [op(id: 10, wc: 1, run: 60)]),
            job(id: 2, due: 500, ops: [op(id: 11, wc: 1, run: 60)]),
          ],
          workCenters: [wc(id: 1, machines: 2)],
          seed: 1,
        ),
      );
      expect(result.makespan, 60);
      expect(
        result.placed.map((p) => p.machineIndex).toSet(),
        {0, 1},
      );
    });

    test('changeover is charged when a machine switches jobs', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(id: 1, due: 500, ops: [op(id: 10, wc: 1, run: 30)]),
            job(id: 2, due: 500, ops: [op(id: 11, wc: 1, run: 30)]),
          ],
          workCenters: [wc(id: 1, changeover: 15)],
          seed: 1,
        ),
      );
      expect(result.makespan, 75);
      final second = result.placed.firstWhere((p) => p.changeoverMinutes == 15);
      expect(second.changeoverMinutes, 15);
    });

    test('the first job on a machine pays no changeover', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(id: 1, due: 500, ops: [op(id: 10, wc: 1, run: 30)]),
          ],
          workCenters: [wc(id: 1, changeover: 15)],
          seed: 1,
        ),
      );
      expect(result.placed.single.changeoverMinutes, 0);
      expect(result.makespan, 30);
    });
  });

  group('lateness', () {
    test('tardiness is measured from the due minute', () {
      const solver = TaktSolver();
      final result = solver.solve(
        SolverInput(
          jobs: [
            job(id: 1, due: 50, ops: [op(id: 10, wc: 1, run: 60)]),
            job(id: 2, due: 300, ops: [op(id: 11, wc: 1, run: 60)]),
          ],
          workCenters: [wc(id: 1)],
          seed: 1,
        ),
      );
      expect(result.jobFinishMinutes[1], 60);
      expect(result.jobFinishMinutes[2], 120);
      expect(result.totalTardinessMinutes, 10);
      expect(result.tardyJobs, 1);
      expect(result.onTimeJobs, 1);
    });

    test('local search never worsens the objective', () {
      const solver = TaktSolver();
      final jobs = [
        for (var i = 0; i < 6; i++)
          job(
            id: i + 1,
            due: 80 + i * 20,
            ops: [
              op(id: 100 + i * 2, wc: 1, run: 25 + i * 5),
              op(id: 101 + i * 2, wc: 2, run: 20 + i * 3),
            ],
          ),
      ];
      final centers = [wc(id: 1), wc(id: 2)];

      final coarse = solver.solve(
        SolverInput(jobs: jobs, workCenters: centers, seed: 11, iterations: 1),
      );
      final refined = solver.solve(
        SolverInput(
          jobs: jobs,
          workCenters: centers,
          seed: 11,
          iterations: 700,
        ),
      );

      expect(refined.objective, lessThanOrEqualTo(coarse.objective));
    });

    test('the same seed produces an identical schedule', () {
      const solver = TaktSolver();
      final jobs = [
        for (var i = 0; i < 7; i++)
          job(
            id: i + 1,
            due: 60 + i * 37,
            release: i.isEven ? 0 : 15,
            priority: 1 + i % 3,
            ops: [
              op(id: 100 + i * 3, wc: 1, run: 18 + i * 4),
              op(id: 101 + i * 3, wc: 2, run: 22 + i * 2),
              op(id: 102 + i * 3, wc: 3, run: 12 + i),
            ],
          ),
      ];
      final centers = [wc(id: 1), wc(id: 2), wc(id: 3, machines: 2)];

      final a = solver.solve(
        SolverInput(jobs: jobs, workCenters: centers, seed: 42),
      );
      final b = solver.solve(
        SolverInput(jobs: jobs, workCenters: centers, seed: 42),
      );

      expect(a.objective, b.objective);
      expect(a.makespan, b.makespan);
      expect(a.placed.length, b.placed.length);
      for (var i = 0; i < a.placed.length; i++) {
        expect(a.placed[i].startMinute, b.placed[i].startMinute);
        expect(a.placed[i].endMinute, b.placed[i].endMinute);
        expect(a.placed[i].machineIndex, b.placed[i].machineIndex);
      }
    });

    test('a different seed is allowed to explore a different order', () {
      const solver = TaktSolver();
      final jobs = [
        for (var i = 0; i < 6; i++)
          job(
            id: i + 1,
            due: 100,
            ops: [
              op(id: 100 + i, wc: 1, run: 30),
              op(id: 200 + i, wc: 2, run: 30),
            ],
          ),
      ];
      final centers = [wc(id: 1), wc(id: 2)];
      final a = solver.solve(
        SolverInput(jobs: jobs, workCenters: centers, seed: 1),
      );
      final b = solver.solve(
        SolverInput(jobs: jobs, workCenters: centers, seed: 2),
      );
      expect(a.placed.length, b.placed.length);
    });
  });

  group('diagnosis', () {
    test('bottleneck is the most loaded work center', () {
      const solver = TaktSolver();
      final input = SolverInput(
        jobs: [
          for (var i = 0; i < 4; i++)
            job(
              id: i + 1,
              due: 2000,
              ops: [
                op(id: 100 + i * 2, wc: 1, run: 100),
                op(id: 101 + i * 2, wc: 2, run: 5),
              ],
            ),
        ],
        workCenters: [
          wc(id: 1, name: 'CNC'),
          wc(id: 2, name: 'Deburr'),
        ],
        seed: 5,
      );
      final result = solver.solve(input);
      final verdict = buildDiagnosis(input: input, result: result);
      expect(verdict.bottleneckWorkCenterId, 1);
      expect(verdict.bottleneckWorkCenterName, 'CNC');
      expect(verdict.bottleneckUtilization, greaterThan(0.8));
    });

    test('a late job names the work center where it lost the most time', () {
      const solver = TaktSolver();
      final input = SolverInput(
        jobs: [
          job(
            id: 1,
            due: 100,
            ops: [
              op(id: 10, wc: 1, run: 80),
              op(id: 11, wc: 2, run: 10),
            ],
          ),
          job(id: 2, due: 5, ops: [op(id: 12, wc: 1, run: 80)]),
        ],
        workCenters: [
          wc(id: 1, name: 'CNC-02'),
          wc(id: 2, name: 'Assembly'),
        ],
        seed: 2,
      );
      final result = solver.solve(input);
      final verdict = buildDiagnosis(input: input, result: result);
      final late = verdict.jobs.firstWhere((j) => j.jobId == 1);

      expect(late.isTardy, isTrue);
      expect(late.tardinessMinutes, greaterThan(0));
      expect(late.bindingWorkCenterName, 'CNC-02');
      expect(late.explanation, contains('queue time'));
      expect(late.chain, isNotEmpty);
    });

    test('an on-time job is explained without inventing lateness', () {
      const solver = TaktSolver();
      final input = SolverInput(
        jobs: [
          job(id: 1, due: 500, ops: [op(id: 10, wc: 1, run: 30)]),
        ],
        workCenters: [wc(id: 1, name: 'Laser')],
        seed: 1,
      );
      final result = solver.solve(input);
      final verdict = buildDiagnosis(input: input, result: result);
      final only = verdict.jobs.single;

      expect(only.isTardy, isFalse);
      expect(only.tardinessMinutes, 0);
      expect(only.explanation, contains('On time'));
    });

    test('late jobs are listed before on-time jobs', () {
      const solver = TaktSolver();
      final input = SolverInput(
        jobs: [
          job(id: 1, due: 5000, ops: [op(id: 10, wc: 1, run: 10)]),
          job(id: 2, due: 5, ops: [op(id: 11, wc: 1, run: 10)]),
        ],
        workCenters: [wc(id: 1)],
        seed: 1,
      );
      final result = solver.solve(input);
      final verdict = buildDiagnosis(input: input, result: result);
      expect(verdict.jobs.first.isTardy, isTrue);
      expect(verdict.jobs.last.isTardy, isFalse);
    });
  });

  group('formatting', () {
    test('formats minutes compactly', () {
      expect(formatMinutes(0), '0m');
      expect(formatMinutes(45), '45m');
      expect(formatMinutes(60), '1h');
      expect(formatMinutes(130), '2h 10m');
      expect(formatMinutes(-90), '-1h 30m');
    });
  });
}

extension on SolverResult {
  int tardinessPerJobForTest(int jobId) => jobTardinessMinutes[jobId] ?? 0;
}
