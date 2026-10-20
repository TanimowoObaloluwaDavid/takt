BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "takt_user" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "displayName" text NOT NULL,
    "passwordHash" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "takt_user_email_idx" ON "takt_user" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_session" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "tokenHash" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "lastSeenAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_session_token_idx" ON "user_session" USING btree ("tokenHash");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_member" (
    "id" bigserial PRIMARY KEY,
    "shopId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "role" text NOT NULL,
    "accessKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "workspace_member_shop_user_idx" ON "workspace_member" USING btree ("shopId", "userId");
CREATE UNIQUE INDEX "workspace_member_key_idx" ON "workspace_member" USING btree ("accessKey");


--
-- MIGRATION VERSION FOR takt
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('takt', '20261020101119388', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261020101119388', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();


COMMIT;
