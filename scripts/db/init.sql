CREATE TABLE IF NOT EXISTS nodes (
    node_id       TEXT        PRIMARY KEY,
    hostname      TEXT        NOT NULL,
    os            TEXT        NOT NULL,
    arch          TEXT        NOT NULL,
    task_manifest JSONB       NOT NULL DEFAULT '{}',
    version       TEXT        NOT NULL DEFAULT '',
    tags          TEXT[]      NOT NULL DEFAULT '{}',
    status        INTEGER     NOT NULL DEFAULT 0,
    last_seen_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS telemetry (
    id         BIGSERIAL   PRIMARY KEY,
    node_id    TEXT        NOT NULL,
    type       TEXT        NOT NULL,
    ts         BIGINT      NOT NULL,
    payload    JSONB       NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXIST node_executors (
    node_id     TEXT         NOT NULL,
    executors   JSONB        NOT NULL DEFAULT '[]',
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NULLABLE
)

CREATE INDEX IF NOT EXISTS idx_telemetry_node_type_ts ON telemetry (node_id, type, ts DESC);
