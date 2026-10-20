BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "job" (
    "id" bigserial PRIMARY KEY,
    "shopId" bigint NOT NULL,
    "code" text NOT NULL,
    "title" text NOT NULL,
    "customer" text NOT NULL,
    "quantity" bigint NOT NULL,
    "dueAt" timestamp without time zone NOT NULL,
    "releaseAt" timestamp without time zone NOT NULL,
    "priority" bigint NOT NULL,
    "notes" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "operation" (
    "id" bigserial PRIMARY KEY,
    "jobId" bigint NOT NULL,
    "sequence" bigint NOT NULL,
    "workCenterId" bigint NOT NULL,
    "setupMinutes" bigint NOT NULL,
    "unitRunMinutes" double precision NOT NULL,
    "description" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "schedule_run" (
    "id" bigserial PRIMARY KEY,
    "shopId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "seed" bigint NOT NULL,
    "horizonStart" timestamp without time zone NOT NULL,
    "onTimeJobs" bigint NOT NULL,
    "tardyJobs" bigint NOT NULL,
    "totalTardinessMinutes" bigint NOT NULL,
    "makespanMinutes" bigint NOT NULL,
    "objective" double precision NOT NULL,
    "bottleneckWorkCenterId" bigint NOT NULL,
    "bottleneckUtilization" double precision NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scheduled_op" (
    "id" bigserial PRIMARY KEY,
    "runId" bigint NOT NULL,
    "jobId" bigint NOT NULL,
    "operationId" bigint NOT NULL,
    "workCenterId" bigint NOT NULL,
    "machineIndex" bigint NOT NULL,
    "startMinute" bigint NOT NULL,
    "endMinute" bigint NOT NULL,
    "queueMinutes" bigint NOT NULL,
    "changeoverMinutes" bigint NOT NULL,
    "sequenceOnMachine" bigint NOT NULL,
    "isTardy" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shop" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "accessKey" text NOT NULL,
    "currency" text NOT NULL,
    "minutesPerDay" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "work_center" (
    "id" bigserial PRIMARY KEY,
    "shopId" bigint NOT NULL,
    "name" text NOT NULL,
    "code" text NOT NULL,
    "machines" bigint NOT NULL,
    "changeoverMinutes" bigint NOT NULL,
    "notes" text NOT NULL
);


--
-- MIGRATION VERSION FOR takt
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('takt', '20261020011727224', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261020011727224', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();


COMMIT;
