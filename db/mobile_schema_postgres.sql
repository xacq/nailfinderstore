-- NailFinderStore PostgreSQL schema
-- Targets multi-tenant backend shared by web and mobile apps

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Optional: place everything in a dedicated schema
CREATE SCHEMA IF NOT EXISTS nailfinderstore;
SET search_path TO nailfinderstore;

-- -----------------------------------------------------------------------------
-- Enum type definitions
-- -----------------------------------------------------------------------------

CREATE TYPE user_status AS ENUM ('active', 'invited', 'suspended');
CREATE TYPE gender_type AS ENUM ('female', 'male', 'non_binary', 'prefer_not_to_say');
CREATE TYPE business_user_status AS ENUM ('invited', 'active', 'inactive');
CREATE TYPE difficulty_level AS ENUM ('beginner', 'intermediate', 'advanced');
CREATE TYPE appointment_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled', 'no_show');
CREATE TYPE cart_status AS ENUM ('active', 'converted', 'abandoned');
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'fulfilled', 'cancelled', 'refunded');
CREATE TYPE payment_status AS ENUM ('pending', 'authorized', 'paid', 'failed', 'refunded');
CREATE TYPE lesson_content_type AS ENUM ('video', 'article', 'download', 'quiz');
CREATE TYPE course_access_type AS ENUM ('lifetime', 'subscription', 'rental');
CREATE TYPE lesson_progress_status AS ENUM ('not_started', 'in_progress', 'completed');
CREATE TYPE loyalty_source_type AS ENUM ('appointment', 'order', 'manual', 'promotion');
CREATE TYPE discount_type AS ENUM ('percentage', 'fixed');
CREATE TYPE verification_channel AS ENUM ('email', 'sms');
CREATE TYPE ticket_status AS ENUM ('open', 'in_progress', 'resolved', 'closed');
CREATE TYPE ticket_priority AS ENUM ('low', 'medium', 'high');

-- -----------------------------------------------------------------------------
-- Core multi-tenant tables
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS businesses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(150) NOT NULL,
    legal_name      VARCHAR(150),
    tax_id          VARCHAR(50),
    email           VARCHAR(150),
    phone           VARCHAR(30),
    description     TEXT,
    logo_url        VARCHAR(500),
    cover_image_url VARCHAR(500),
    timezone        VARCHAR(50) NOT NULL DEFAULT 'UTC',
    currency        VARCHAR(3) NOT NULL DEFAULT 'USD',
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS business_locations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    name            VARCHAR(150) NOT NULL,
    address_line1   VARCHAR(200) NOT NULL,
    address_line2   VARCHAR(200),
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100),
    postal_code     VARCHAR(20),
    country         VARCHAR(100) NOT NULL,
    latitude        NUMERIC(10,8),
    longitude       NUMERIC(11,8),
    phone           VARCHAR(30),
    email           VARCHAR(150),
    is_default      BOOLEAN NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS roles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    is_system   BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE SET NULL,
    email           VARCHAR(150) NOT NULL,
    phone           VARCHAR(30),
    password_hash   VARCHAR(255) NOT NULL,
    auth_provider   VARCHAR(50) NOT NULL DEFAULT 'password',
    is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    status          user_status NOT NULL DEFAULT 'active',
    last_login_at   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ,
    UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS user_profiles (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL UNIQUE REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    birthdate       DATE,
    gender          gender_type,
    avatar_url      VARCHAR(500),
    loyalty_opt_in  BOOLEAN NOT NULL DEFAULT TRUE,
    marketing_opt_in BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_roles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    role_id     UUID NOT NULL REFERENCES roles (id) ON UPDATE CASCADE ON DELETE CASCADE,
    business_id UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, role_id, business_id)
);

CREATE TABLE IF NOT EXISTS business_users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    role_id         UUID REFERENCES roles (id) ON UPDATE CASCADE ON DELETE SET NULL,
    invitation_email VARCHAR(150),
    invited_at      TIMESTAMPTZ,
    accepted_at     TIMESTAMPTZ,
    status          business_user_status NOT NULL DEFAULT 'active',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (business_id, user_id)
);

CREATE TABLE IF NOT EXISTS user_addresses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    business_id     UUID REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE SET NULL,
    label           VARCHAR(100),
    address_line1   VARCHAR(200) NOT NULL,
    address_line2   VARCHAR(200),
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100),
    postal_code     VARCHAR(20),
    country         VARCHAR(100) NOT NULL,
    is_default      BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Portfolio and media
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS nail_designs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    title           VARCHAR(150) NOT NULL,
    description     TEXT,
    difficulty      difficulty_level,
    duration_minutes INTEGER,
    price           NUMERIC(10,2),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS nail_design_images (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    design_id       UUID NOT NULL REFERENCES nail_designs (id) ON UPDATE CASCADE ON DELETE CASCADE,
    image_url       VARCHAR(500) NOT NULL,
    is_cover        BOOLEAN NOT NULL DEFAULT FALSE,
    position        INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Services and scheduling
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS service_categories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    position        INTEGER NOT NULL DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS services (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    category_id     UUID NOT NULL REFERENCES service_categories (id) ON UPDATE CASCADE ON DELETE CASCADE,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    duration_minutes INTEGER NOT NULL,
    price           NUMERIC(10,2) NOT NULL,
    preparation_time_minutes INTEGER NOT NULL DEFAULT 0,
    buffer_time_minutes INTEGER NOT NULL DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS technicians (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    display_name    VARCHAR(150) NOT NULL,
    bio             TEXT,
    specialization  VARCHAR(200),
    rating_average  NUMERIC(3,2),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS technician_services (
    technician_id   UUID NOT NULL REFERENCES technicians (id) ON UPDATE CASCADE ON DELETE CASCADE,
    service_id      UUID NOT NULL REFERENCES services (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (technician_id, service_id)
);

CREATE TABLE IF NOT EXISTS business_hours (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    location_id     UUID REFERENCES business_locations (id) ON UPDATE CASCADE ON DELETE SET NULL,
    weekday         SMALLINT NOT NULL,
    opens_at        TIME NOT NULL,
    closes_at       TIME NOT NULL,
    is_closed       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS technician_availability (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    technician_id   UUID NOT NULL REFERENCES technicians (id) ON UPDATE CASCADE ON DELETE CASCADE,
    weekday         SMALLINT NOT NULL,
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS appointments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    location_id     UUID REFERENCES business_locations (id) ON UPDATE CASCADE ON DELETE SET NULL,
    service_id      UUID NOT NULL REFERENCES services (id) ON UPDATE CASCADE ON DELETE CASCADE,
    technician_id   UUID NOT NULL REFERENCES technicians (id) ON UPDATE CASCADE ON DELETE CASCADE,
    client_id       UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    start_time      TIMESTAMPTZ NOT NULL,
    end_time        TIMESTAMPTZ NOT NULL,
    status          appointment_status NOT NULL DEFAULT 'pending',
    notes           TEXT,
    price           NUMERIC(10,2),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cancelled_at    TIMESTAMPTZ,
    cancellation_reason VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS appointment_status_history (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    appointment_id  UUID NOT NULL REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE CASCADE,
    status          appointment_status NOT NULL,
    changed_by      UUID REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    changed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes           VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS service_reviews (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    appointment_id  UUID REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE SET NULL,
    service_id      UUID NOT NULL REFERENCES services (id) ON UPDATE CASCADE ON DELETE CASCADE,
    reviewer_id     UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    rating          SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Ecommerce tables
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS product_categories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    parent_id       UUID REFERENCES product_categories (id) ON UPDATE CASCADE ON DELETE SET NULL,
    position        INTEGER NOT NULL DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    category_id     UUID REFERENCES product_categories (id) ON UPDATE CASCADE ON DELETE SET NULL,
    name            VARCHAR(200) NOT NULL,
    description     TEXT,
    sku             VARCHAR(100),
    price           NUMERIC(10,2) NOT NULL,
    compare_at_price NUMERIC(10,2),
    tax_rate        NUMERIC(5,2),
    unit            VARCHAR(50),
    weight_grams    NUMERIC(10,2),
    is_digital      BOOLEAN NOT NULL DEFAULT FALSE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS product_images (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      UUID NOT NULL REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
    image_url       VARCHAR(500) NOT NULL,
    is_primary      BOOLEAN NOT NULL DEFAULT FALSE,
    position        INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS inventory_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    location_id     UUID REFERENCES business_locations (id) ON UPDATE CASCADE ON DELETE SET NULL,
    product_id      UUID NOT NULL REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
    quantity        INTEGER NOT NULL DEFAULT 0,
    safety_stock    INTEGER NOT NULL DEFAULT 0,
    restock_level   INTEGER NOT NULL DEFAULT 0,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS carts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID REFERENCES users (id) ON UPDATE CASCADE ON DELETE SET NULL,
    status          cart_status NOT NULL DEFAULT 'active',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cart_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id         UUID NOT NULL REFERENCES carts (id) ON UPDATE CASCADE ON DELETE CASCADE,
    product_id      UUID NOT NULL REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
    quantity        INTEGER NOT NULL DEFAULT 1,
    unit_price      NUMERIC(10,2) NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    cart_id         UUID REFERENCES carts (id) ON UPDATE CASCADE ON DELETE SET NULL,
    order_number    VARCHAR(50) NOT NULL,
    status          order_status NOT NULL DEFAULT 'pending',
    subtotal_amount NUMERIC(10,2) NOT NULL,
    discount_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
    tax_amount      NUMERIC(10,2) NOT NULL DEFAULT 0,
    shipping_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
    total_amount    NUMERIC(10,2) NOT NULL,
    placed_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fulfilled_at    TIMESTAMPTZ,
    cancelled_at    TIMESTAMPTZ,
    cancellation_reason VARCHAR(255),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (order_number)
);

CREATE TABLE IF NOT EXISTS order_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL REFERENCES orders (id) ON UPDATE CASCADE ON DELETE CASCADE,
    product_id      UUID NOT NULL REFERENCES products (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    quantity        INTEGER NOT NULL,
    unit_price      NUMERIC(10,2) NOT NULL,
    tax_amount      NUMERIC(10,2) NOT NULL DEFAULT 0,
    discount_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
    total_amount    NUMERIC(10,2) NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS shipping_addresses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL REFERENCES orders (id) ON UPDATE CASCADE ON DELETE CASCADE,
    recipient_name  VARCHAR(150) NOT NULL,
    address_line1   VARCHAR(200) NOT NULL,
    address_line2   VARCHAR(200),
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100),
    postal_code     VARCHAR(20),
    country         VARCHAR(100) NOT NULL,
    phone           VARCHAR(30),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    order_id        UUID REFERENCES orders (id) ON UPDATE CASCADE ON DELETE SET NULL,
    appointment_id  UUID REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE SET NULL,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    provider        VARCHAR(50) NOT NULL,
    provider_payment_id VARCHAR(100),
    amount          NUMERIC(10,2) NOT NULL,
    currency        VARCHAR(3) NOT NULL DEFAULT 'USD',
    status          payment_status NOT NULL DEFAULT 'pending',
    paid_at         TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS product_reviews (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    product_id      UUID NOT NULL REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
    reviewer_id     UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    rating          SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Courses / academy
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS courses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    instructor_id   UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    title           VARCHAR(200) NOT NULL,
    slug            VARCHAR(200) NOT NULL,
    description     TEXT,
    cover_image_url VARCHAR(500),
    level           difficulty_level,
    price           NUMERIC(10,2) NOT NULL DEFAULT 0,
    duration_minutes INTEGER,
    is_published    BOOLEAN NOT NULL DEFAULT FALSE,
    published_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (slug)
);

CREATE TABLE IF NOT EXISTS course_sections (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id       UUID NOT NULL REFERENCES courses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    title           VARCHAR(200) NOT NULL,
    position        INTEGER NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS lessons (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id      UUID NOT NULL REFERENCES course_sections (id) ON UPDATE CASCADE ON DELETE CASCADE,
    title           VARCHAR(200) NOT NULL,
    content_url     VARCHAR(500),
    content_type    lesson_content_type NOT NULL DEFAULT 'video',
    duration_minutes INTEGER,
    position        INTEGER NOT NULL,
    is_preview      BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS course_purchases (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id       UUID NOT NULL REFERENCES courses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    order_id        UUID REFERENCES orders (id) ON UPDATE CASCADE ON DELETE SET NULL,
    payment_id      UUID REFERENCES payments (id) ON UPDATE CASCADE ON DELETE SET NULL,
    purchased_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at      TIMESTAMPTZ,
    access_type     course_access_type NOT NULL DEFAULT 'lifetime'
);

CREATE TABLE IF NOT EXISTS lesson_progress (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id       UUID NOT NULL REFERENCES lessons (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    status          lesson_progress_status NOT NULL DEFAULT 'not_started',
    last_watched_second INTEGER,
    completed_at    TIMESTAMPTZ,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (lesson_id, user_id)
);

CREATE TABLE IF NOT EXISTS course_reviews (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id       UUID NOT NULL REFERENCES courses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    reviewer_id     UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    rating          SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Loyalty & marketing
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS loyalty_wallets (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    balance         INTEGER NOT NULL DEFAULT 0,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (business_id, user_id)
);

CREATE TABLE IF NOT EXISTS loyalty_transactions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id       UUID NOT NULL REFERENCES loyalty_wallets (id) ON UPDATE CASCADE ON DELETE CASCADE,
    source_type     loyalty_source_type NOT NULL,
    source_id       UUID,
    points          INTEGER NOT NULL,
    description     VARCHAR(255),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS promotions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    discount_type   discount_type NOT NULL,
    discount_value  NUMERIC(10,2) NOT NULL,
    starts_at       TIMESTAMPTZ NOT NULL,
    ends_at         TIMESTAMPTZ,
    min_purchase_amount NUMERIC(10,2),
    usage_limit     INTEGER,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS coupons (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID NOT NULL REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE CASCADE,
    code            VARCHAR(50) NOT NULL,
    description     TEXT,
    discount_type   discount_type NOT NULL,
    discount_value  NUMERIC(10,2) NOT NULL,
    max_uses        INTEGER,
    max_uses_per_user INTEGER,
    starts_at       TIMESTAMPTZ NOT NULL,
    ends_at         TIMESTAMPTZ,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (business_id, code)
);

CREATE TABLE IF NOT EXISTS promotion_applications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    promotion_id    UUID REFERENCES promotions (id) ON UPDATE CASCADE ON DELETE SET NULL,
    coupon_id       UUID REFERENCES coupons (id) ON UPDATE CASCADE ON DELETE SET NULL,
    order_id        UUID REFERENCES orders (id) ON UPDATE CASCADE ON DELETE SET NULL,
    appointment_id  UUID REFERENCES appointments (id) ON UPDATE CASCADE ON DELETE SET NULL,
    applied_value   NUMERIC(10,2) NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Communication & support
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS notifications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    business_id     UUID REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE SET NULL,
    title           VARCHAR(150) NOT NULL,
    body            TEXT NOT NULL,
    type            VARCHAR(50) NOT NULL,
    read_at         TIMESTAMPTZ,
    sent_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata        JSONB
);

CREATE TABLE IF NOT EXISTS verification_codes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    channel         verification_channel NOT NULL,
    code            VARCHAR(10) NOT NULL,
    expires_at      TIMESTAMPTZ NOT NULL,
    consumed_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS support_tickets (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id     UUID REFERENCES businesses (id) ON UPDATE CASCADE ON DELETE SET NULL,
    user_id         UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    subject         VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    status          ticket_status NOT NULL DEFAULT 'open',
    priority        ticket_priority NOT NULL DEFAULT 'medium',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS support_ticket_messages (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id       UUID NOT NULL REFERENCES support_tickets (id) ON UPDATE CASCADE ON DELETE CASCADE,
    sender_id       UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    message         TEXT NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

