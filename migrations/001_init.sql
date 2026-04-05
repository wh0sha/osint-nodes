-- 1. Источники
CREATE TABLE IF NOT EXISTS sources (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    url VARCHAR(500) NOT NULL UNIQUE,
    fetched_at TIMESTAMP NOT NULL DEFAULT NOW(),
    content_hash VARCHAR(64),
    raw_html_path VARCHAR(255)
);

-- 2. Компании
CREATE TABLE IF NOT EXISTS companies (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    owner_name VARCHAR(255),
    description TEXT,
    source_id INTEGER REFERENCES sources(id),
    found_at TIMESTAMP DEFAULT NOW()
);

-- 3. Люди
CREATE TABLE IF NOT EXISTS persons (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    current_position VARCHAR(255),
    past_positions TEXT[],
    description TEXT,
    source_id INTEGER REFERENCES sources(id),
    found_at TIMESTAMP DEFAULT NOW()
);

-- 4. Связи (граф)
CREATE TABLE IF NOT EXISTS relationships (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    from_type VARCHAR(20),
    from_id INTEGER,
    to_type VARCHAR(20),
    to_id INTEGER,
    relation_type VARCHAR(50),
    source_id INTEGER REFERENCES sources(id),
    discovered_at TIMESTAMP DEFAULT NOW()
);

-- ограничения CHECK
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_rel_from_type') THEN
        ALTER TABLE relationships ADD CONSTRAINT chk_rel_from_type CHECK (from_type IN ('company', 'person'));
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_rel_to_type') THEN
        ALTER TABLE relationships ADD CONSTRAINT chk_rel_to_type CHECK (to_type IN ('company', 'person'));
    END IF;
END $$;