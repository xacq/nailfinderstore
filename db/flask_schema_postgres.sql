-- NailFinderStore Flask backend schema (PostgreSQL)
-- Mirrors the SQLAlchemy models defined in https://github.com/xacq/nails

-- Create the database (execute separately if needed)
-- CREATE DATABASE nails;
-- \c nails

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role_enum') THEN
        CREATE TYPE user_role_enum AS ENUM ('admin', 'employee', 'client');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'appointment_status_enum') THEN
        CREATE TYPE appointment_status_enum AS ENUM (
            'pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show'
        );
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_status_enum') THEN
        CREATE TYPE payment_status_enum AS ENUM ('pending', 'paid', 'partial', 'refunded');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'business_type_enum') THEN
        CREATE TYPE business_type_enum AS ENUM ('NAIL_SALON', 'BEAUTY_SALON', 'SPA', 'BARBERSHOP', 'STUDIO');
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'business_status_enum') THEN
        CREATE TYPE business_status_enum AS ENUM ('PENDING', 'ACTIVE', 'SUSPENDED', 'CANCELLED');
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS users (
    id                BIGSERIAL PRIMARY KEY,
    email             VARCHAR(120) NOT NULL UNIQUE,
    password_hash     VARCHAR(255) NOT NULL,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    phone             VARCHAR(20),
    role              user_role_enum NOT NULL DEFAULT 'client',
    profile_picture   VARCHAR(255),
    date_of_birth     DATE,
    address           TEXT,
    emergency_contact VARCHAR(100),
    emergency_phone   VARCHAR(20),
    notes             TEXT,
    is_active         BOOLEAN NOT NULL DEFAULT TRUE,
    email_verified    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login        TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS service_categories (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    color_code  VARCHAR(7),
    icon        VARCHAR(50),
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS services (
    id                    BIGSERIAL PRIMARY KEY,
    name                  VARCHAR(100) NOT NULL,
    description           TEXT,
    price                 NUMERIC(10,2) NOT NULL,
    duration_minutes      INTEGER NOT NULL,
    category_id           BIGINT REFERENCES service_categories (id) ON UPDATE CASCADE ON DELETE SET NULL,
    image_url             VARCHAR(255),
    is_active             BOOLEAN NOT NULL DEFAULT TRUE,
    loyalty_points_earned INTEGER NOT NULL DEFAULT 0,
    created_at            TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS appointments (
    id                BIGSERIAL PRIMARY KEY,
    client_id         BIGINT NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    employee_id       BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    appointment_date  DATE NOT NULL,
    start_time        TIME NOT NULL,
    end_time          TIME,
    status            appointment_status_enum NOT NULL DEFAULT 'pending',
    notes             TEXT,
    internal_notes    TEXT,
    total_price       NUMERIC(10,2),
    confirmation_code VARCHAR(20) UNIQUE,
    reminder_sent     BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS appointment_services (
    appointment_id BIGINT NOT NULL REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE CASCADE,
    service_id     BIGINT NOT NULL REFERENCES services (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (appointment_id, service_id)
);

CREATE TABLE IF NOT EXISTS payments (
    id                 BIGSERIAL PRIMARY KEY,
    appointment_id     BIGINT REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE SET NULL,
    client_id          BIGINT NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    amount             NUMERIC(10,2) NOT NULL,
    payment_method     VARCHAR(50),
    payment_status     payment_status_enum NOT NULL DEFAULT 'pending',
    transaction_id     VARCHAR(100),
    notes              TEXT,
    processed_by       BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    processed_at       TIMESTAMP WITHOUT TIME ZONE,
    created_at         TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS schedules (
    id          BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL,
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    break_start TIME,
    break_end   TIME,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS loyalty_points (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    points      INTEGER NOT NULL,
    reason      VARCHAR(255),
    reference_id BIGINT,
    used        BOOLEAN NOT NULL DEFAULT FALSE,
    used_at     TIMESTAMP WITHOUT TIME ZONE,
    expires_at  TIMESTAMP WITHOUT TIME ZONE,
    created_at  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reviews (
    id             BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT NOT NULL REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE CASCADE,
    client_id      BIGINT NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    employee_id    BIGINT REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    rating         INTEGER NOT NULL,
    comment        TEXT,
    is_public      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS promotions (
    id                   BIGSERIAL PRIMARY KEY,
    name                 VARCHAR(100) NOT NULL,
    description          TEXT,
    discount_type        VARCHAR(20),
    discount_value       NUMERIC(10,2),
    min_purchase_amount  NUMERIC(10,2),
    max_uses             INTEGER,
    current_uses         INTEGER NOT NULL DEFAULT 0,
    code                 VARCHAR(50) UNIQUE,
    start_date           TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    end_date             TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    is_active            BOOLEAN NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS inventory (
    id              BIGSERIAL PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(50),
    brand           VARCHAR(50),
    color           VARCHAR(50),
    quantity        INTEGER NOT NULL DEFAULT 0,
    min_stock_level INTEGER NOT NULL DEFAULT 5,
    unit_cost       NUMERIC(10,2),
    supplier        VARCHAR(100),
    expiry_date     DATE,
    notes           TEXT,
    created_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS businesses (
    id                   BIGSERIAL PRIMARY KEY,
    name                 VARCHAR(150) NOT NULL,
    slug                 VARCHAR(100) NOT NULL UNIQUE,
    description          TEXT,
    business_type        business_type_enum NOT NULL DEFAULT 'NAIL_SALON',
    phone                VARCHAR(20),
    email                VARCHAR(150),
    website              VARCHAR(255),
    address              TEXT NOT NULL,
    city                 VARCHAR(100) NOT NULL,
    state                VARCHAR(100),
    country              VARCHAR(100) NOT NULL,
    postal_code          VARCHAR(20),
    latitude             NUMERIC(10,8),
    longitude            NUMERIC(11,8),
    location_verified    BOOLEAN NOT NULL DEFAULT FALSE,
    timezone             VARCHAR(50) NOT NULL DEFAULT 'America/Mexico_City',
    currency             VARCHAR(3) NOT NULL DEFAULT 'MXN',
    language             VARCHAR(5) NOT NULL DEFAULT 'es',
    instagram_handle     VARCHAR(100),
    facebook_url         VARCHAR(255),
    whatsapp_number      VARCHAR(20),
    logo_url             VARCHAR(255),
    cover_image_url      VARCHAR(255),
    gallery_images       JSONB,
    operating_hours      JSONB,
    business_hours       JSONB,
    allow_online_booking BOOLEAN NOT NULL DEFAULT TRUE,
    require_deposit      BOOLEAN NOT NULL DEFAULT FALSE,
    deposit_percentage   NUMERIC(5,2) NOT NULL DEFAULT 0,
    booking_advance_days INTEGER NOT NULL DEFAULT 30,
    booking_advance_hours INTEGER NOT NULL DEFAULT 2,
    rating_average       NUMERIC(3,2) NOT NULL DEFAULT 0,
    reviews_count        INTEGER NOT NULL DEFAULT 0,
    appointments_total   INTEGER NOT NULL DEFAULT 0,
    primary_color        VARCHAR(7),
    secondary_color      VARCHAR(7),
    status               business_status_enum NOT NULL DEFAULT 'PENDING',
    registration_date    TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_at          TIMESTAMP WITHOUT TIME ZONE,
    last_activity        TIMESTAMP WITHOUT TIME ZONE,
    created_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active            BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_business_location ON businesses (latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_business_type_status ON businesses (business_type, status);
CREATE INDEX IF NOT EXISTS idx_business_city_type ON businesses (city, business_type);
