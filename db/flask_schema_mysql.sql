-- NailFinderStore Flask backend schema (MySQL)
-- Mirrors the SQLAlchemy models defined in https://github.com/xacq/nails

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS nails CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nails;

CREATE TABLE IF NOT EXISTS users (
    id                INT UNSIGNED NOT NULL AUTO_INCREMENT,
    email             VARCHAR(120) NOT NULL,
    password_hash     VARCHAR(255) NOT NULL,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    phone             VARCHAR(20),
    role              ENUM('admin','employee','client') NOT NULL DEFAULT 'client',
    profile_picture   VARCHAR(255),
    date_of_birth     DATE,
    address           TEXT,
    emergency_contact VARCHAR(100),
    emergency_phone   VARCHAR(20),
    notes             TEXT,
    is_active         TINYINT(1) NOT NULL DEFAULT 1,
    email_verified    TINYINT(1) NOT NULL DEFAULT 0,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login        DATETIME,
    PRIMARY KEY (id),
    UNIQUE KEY ux_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS service_categories (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    color_code  VARCHAR(7),
    icon        VARCHAR(50),
    is_active   TINYINT(1) NOT NULL DEFAULT 1,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY ux_service_categories_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS services (
    id                    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name                  VARCHAR(100) NOT NULL,
    description           TEXT,
    price                 DECIMAL(10,2) NOT NULL,
    duration_minutes      INT NOT NULL,
    category_id           INT UNSIGNED,
    image_url             VARCHAR(255),
    is_active             TINYINT(1) NOT NULL DEFAULT 1,
    loyalty_points_earned INT NOT NULL DEFAULT 0,
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_services_category FOREIGN KEY (category_id) REFERENCES service_categories (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS appointments (
    id                INT UNSIGNED NOT NULL AUTO_INCREMENT,
    client_id         INT UNSIGNED NOT NULL,
    employee_id       INT UNSIGNED,
    appointment_date  DATE NOT NULL,
    start_time        TIME NOT NULL,
    end_time          TIME,
    status            ENUM('pending','confirmed','in_progress','completed','cancelled','no_show') NOT NULL DEFAULT 'pending',
    notes             TEXT,
    internal_notes    TEXT,
    total_price       DECIMAL(10,2),
    confirmation_code VARCHAR(20),
    reminder_sent     TINYINT(1) NOT NULL DEFAULT 0,
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY ux_appointments_confirmation_code (confirmation_code),
    CONSTRAINT fk_appointments_client FOREIGN KEY (client_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointments_employee FOREIGN KEY (employee_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS appointment_services (
    appointment_id INT UNSIGNED NOT NULL,
    service_id     INT UNSIGNED NOT NULL,
    PRIMARY KEY (appointment_id, service_id),
    CONSTRAINT fk_appointment_services_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointment_services_service FOREIGN KEY (service_id) REFERENCES services (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS payments (
    id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    appointment_id     INT UNSIGNED,
    client_id          INT UNSIGNED NOT NULL,
    amount             DECIMAL(10,2) NOT NULL,
    payment_method     VARCHAR(50),
    payment_status     ENUM('pending','paid','partial','refunded') NOT NULL DEFAULT 'pending',
    transaction_id     VARCHAR(100),
    notes              TEXT,
    processed_by       INT UNSIGNED,
    processed_at       DATETIME,
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_payments_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_payments_client FOREIGN KEY (client_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_payments_processed_by FOREIGN KEY (processed_by) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS schedules (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    employee_id INT UNSIGNED NOT NULL,
    day_of_week TINYINT NOT NULL,
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    break_start TIME,
    break_end   TIME,
    is_active   TINYINT(1) NOT NULL DEFAULT 1,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_schedules_employee FOREIGN KEY (employee_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS loyalty_points (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id    INT UNSIGNED NOT NULL,
    points     INT NOT NULL,
    reason     VARCHAR(255),
    reference_id INT,
    used       TINYINT(1) NOT NULL DEFAULT 0,
    used_at    DATETIME,
    expires_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_loyalty_points_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS reviews (
    id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    appointment_id INT UNSIGNED NOT NULL,
    client_id      INT UNSIGNED NOT NULL,
    employee_id    INT UNSIGNED,
    rating         INT NOT NULL,
    comment        TEXT,
    is_public      TINYINT(1) NOT NULL DEFAULT 1,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_reviews_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reviews_client FOREIGN KEY (client_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reviews_employee FOREIGN KEY (employee_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS promotions (
    id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name               VARCHAR(100) NOT NULL,
    description        TEXT,
    discount_type      VARCHAR(20),
    discount_value     DECIMAL(10,2),
    min_purchase_amount DECIMAL(10,2),
    max_uses           INT,
    current_uses       INT NOT NULL DEFAULT 0,
    code               VARCHAR(50),
    start_date         DATETIME NOT NULL,
    end_date           DATETIME NOT NULL,
    is_active          TINYINT(1) NOT NULL DEFAULT 1,
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY ux_promotions_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS inventory (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(50),
    brand           VARCHAR(50),
    color           VARCHAR(50),
    quantity        INT NOT NULL DEFAULT 0,
    min_stock_level INT NOT NULL DEFAULT 5,
    unit_cost       DECIMAL(10,2),
    supplier        VARCHAR(100),
    expiry_date     DATE,
    notes           TEXT,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS businesses (
    id                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name               VARCHAR(150) NOT NULL,
    slug               VARCHAR(100) NOT NULL,
    description        TEXT,
    business_type      ENUM('NAIL_SALON','BEAUTY_SALON','SPA','BARBERSHOP','STUDIO') NOT NULL DEFAULT 'NAIL_SALON',
    phone              VARCHAR(20),
    email              VARCHAR(150),
    website            VARCHAR(255),
    address            TEXT NOT NULL,
    city               VARCHAR(100) NOT NULL,
    state              VARCHAR(100),
    country            VARCHAR(100) NOT NULL,
    postal_code        VARCHAR(20),
    latitude           DECIMAL(10,8),
    longitude          DECIMAL(11,8),
    location_verified  TINYINT(1) NOT NULL DEFAULT 0,
    timezone           VARCHAR(50) NOT NULL DEFAULT 'America/Mexico_City',
    currency           VARCHAR(3) NOT NULL DEFAULT 'MXN',
    language           VARCHAR(5) NOT NULL DEFAULT 'es',
    instagram_handle   VARCHAR(100),
    facebook_url       VARCHAR(255),
    whatsapp_number    VARCHAR(20),
    logo_url           VARCHAR(255),
    cover_image_url    VARCHAR(255),
    gallery_images     JSON,
    operating_hours    JSON,
    business_hours     JSON,
    allow_online_booking TINYINT(1) NOT NULL DEFAULT 1,
    require_deposit    TINYINT(1) NOT NULL DEFAULT 0,
    deposit_percentage DECIMAL(5,2) NOT NULL DEFAULT 0,
    booking_advance_days INT NOT NULL DEFAULT 30,
    booking_advance_hours INT NOT NULL DEFAULT 2,
    rating_average     DECIMAL(3,2) NOT NULL DEFAULT 0,
    reviews_count      INT NOT NULL DEFAULT 0,
    appointments_total INT NOT NULL DEFAULT 0,
    primary_color      VARCHAR(7),
    secondary_color    VARCHAR(7),
    status             ENUM('PENDING','ACTIVE','SUSPENDED','CANCELLED') NOT NULL DEFAULT 'PENDING',
    registration_date  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_at        DATETIME,
    last_activity      DATETIME,
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active          TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY ux_businesses_slug (slug),
    KEY idx_business_location (latitude, longitude),
    KEY idx_business_type_status (business_type, status),
    KEY idx_business_city_type (city, business_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
