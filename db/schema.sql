-- NailFinderStore MySQL schema
-- Engine: InnoDB, character set utf8mb4 for emoji compatibility

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS nailfinderstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nailfinderstore;

-- ------------------------------------------------------------
-- Core multi-tenant tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS businesses (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    name            VARCHAR(150) NOT NULL,
    legal_name      VARCHAR(150) NULL,
    tax_id          VARCHAR(50) NULL,
    email           VARCHAR(150) NULL,
    phone           VARCHAR(30) NULL,
    description     TEXT NULL,
    logo_url        VARCHAR(500) NULL,
    cover_image_url VARCHAR(500) NULL,
    timezone        VARCHAR(50) NOT NULL DEFAULT 'UTC',
    currency        VARCHAR(3) NOT NULL DEFAULT 'USD',
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME NULL,
    UNIQUE KEY ux_businesses_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS business_locations (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    name            VARCHAR(150) NOT NULL,
    address_line1   VARCHAR(200) NOT NULL,
    address_line2   VARCHAR(200) NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NULL,
    postal_code     VARCHAR(20) NULL,
    country         VARCHAR(100) NOT NULL,
    latitude        DECIMAL(10,8) NULL,
    longitude       DECIMAL(11,8) NULL,
    phone           VARCHAR(30) NULL,
    email           VARCHAR(150) NULL,
    is_default      TINYINT(1) NOT NULL DEFAULT 0,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME NULL,
    CONSTRAINT fk_business_locations_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS roles (
    id          CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    name        VARCHAR(50) NOT NULL,
    description VARCHAR(200) NULL,
    is_system   TINYINT(1) NOT NULL DEFAULT 0,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY ux_roles_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS users (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NULL,
    email           VARCHAR(150) NOT NULL,
    phone           VARCHAR(30) NULL,
    password_hash   VARCHAR(255) NOT NULL,
    auth_provider   VARCHAR(50) NOT NULL DEFAULT 'password',
    is_email_verified TINYINT(1) NOT NULL DEFAULT 0,
    is_phone_verified TINYINT(1) NOT NULL DEFAULT 0,
    status          ENUM('active','invited','suspended') NOT NULL DEFAULT 'active',
    last_login_at   DATETIME NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME NULL,
    UNIQUE KEY ux_users_email (email),
    CONSTRAINT fk_users_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_profiles (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id         CHAR(36) NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    birthdate       DATE NULL,
    gender          ENUM('female','male','non_binary','prefer_not_to_say') NULL,
    avatar_url      VARCHAR(500) NULL,
    loyalty_opt_in  TINYINT(1) NOT NULL DEFAULT 1,
    marketing_opt_in TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_roles (
    id          CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id     CHAR(36) NOT NULL,
    role_id     CHAR(36) NOT NULL,
    business_id CHAR(36) NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY ux_user_roles_assignment (user_id, role_id, business_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS business_users (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    user_id         CHAR(36) NOT NULL,
    role_id         CHAR(36) NULL,
    invitation_email VARCHAR(150) NULL,
    invited_at      DATETIME NULL,
    accepted_at     DATETIME NULL,
    status          ENUM('invited','active','inactive') NOT NULL DEFAULT 'active',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_business_users (business_id, user_id),
    CONSTRAINT fk_business_users_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_business_users_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_business_users_role FOREIGN KEY (role_id) REFERENCES roles (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_addresses (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id         CHAR(36) NOT NULL,
    business_id     CHAR(36) NULL,
    label           VARCHAR(100) NULL,
    address_line1   VARCHAR(200) NOT NULL,
    address_line2   VARCHAR(200) NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NULL,
    postal_code     VARCHAR(20) NULL,
    country         VARCHAR(100) NOT NULL,
    is_default      TINYINT(1) NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_addresses_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_user_addresses_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Portfolio and media
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS nail_designs (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    title           VARCHAR(150) NOT NULL,
    description     TEXT NULL,
    difficulty      ENUM('beginner','intermediate','advanced') NULL,
    duration_minutes INT NULL,
    price           DECIMAL(10,2) NULL,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME NULL,
    CONSTRAINT fk_nail_designs_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS nail_design_images (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    design_id       CHAR(36) NOT NULL,
    image_url       VARCHAR(500) NOT NULL,
    is_cover        TINYINT(1) NOT NULL DEFAULT 0,
    position        INT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nail_design_images_design FOREIGN KEY (design_id) REFERENCES nail_designs (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Services and scheduling
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS service_categories (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT NULL,
    position        INT NOT NULL DEFAULT 0,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_service_categories_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS services (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    category_id     CHAR(36) NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT NULL,
    duration_minutes INT NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    preparation_time_minutes INT NOT NULL DEFAULT 0,
    buffer_time_minutes INT NOT NULL DEFAULT 0,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME NULL,
    CONSTRAINT fk_services_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_services_category FOREIGN KEY (category_id) REFERENCES service_categories (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS technicians (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    user_id         CHAR(36) NULL,
    display_name    VARCHAR(150) NOT NULL,
    bio             TEXT NULL,
    specialization  VARCHAR(200) NULL,
    rating_average  DECIMAL(3,2) NULL,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_technicians_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_technicians_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS technician_services (
    technician_id   CHAR(36) NOT NULL,
    service_id      CHAR(36) NOT NULL,
    PRIMARY KEY (technician_id, service_id),
    CONSTRAINT fk_technician_services_technician FOREIGN KEY (technician_id) REFERENCES technicians (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_technician_services_service FOREIGN KEY (service_id) REFERENCES services (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS business_hours (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    location_id     CHAR(36) NULL,
    weekday         TINYINT NOT NULL,
    opens_at        TIME NOT NULL,
    closes_at       TIME NOT NULL,
    is_closed       TINYINT(1) NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_business_hours_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_business_hours_location FOREIGN KEY (location_id) REFERENCES business_locations (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS technician_availability (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    technician_id   CHAR(36) NOT NULL,
    weekday         TINYINT NOT NULL,
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_technician_availability_technician FOREIGN KEY (technician_id) REFERENCES technicians (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS appointments (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    location_id     CHAR(36) NULL,
    service_id      CHAR(36) NOT NULL,
    technician_id   CHAR(36) NOT NULL,
    client_id       CHAR(36) NOT NULL,
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL,
    status          ENUM('pending','confirmed','completed','cancelled','no_show') NOT NULL DEFAULT 'pending',
    notes           TEXT NULL,
    price           DECIMAL(10,2) NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    cancelled_at    DATETIME NULL,
    cancellation_reason VARCHAR(255) NULL,
    CONSTRAINT fk_appointments_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointments_location FOREIGN KEY (location_id) REFERENCES business_locations (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_appointments_service FOREIGN KEY (service_id) REFERENCES services (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointments_technician FOREIGN KEY (technician_id) REFERENCES technicians (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointments_client FOREIGN KEY (client_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS appointment_status_history (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    appointment_id  CHAR(36) NOT NULL,
    status          ENUM('pending','confirmed','completed','cancelled','no_show') NOT NULL,
    changed_by      CHAR(36) NULL,
    changed_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes           VARCHAR(255) NULL,
    CONSTRAINT fk_appointment_history_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointment_history_user FOREIGN KEY (changed_by) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS service_reviews (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    appointment_id  CHAR(36) NULL,
    service_id      CHAR(36) NOT NULL,
    reviewer_id     CHAR(36) NOT NULL,
    rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_service_reviews_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_service_reviews_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_service_reviews_service FOREIGN KEY (service_id) REFERENCES services (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_service_reviews_user FOREIGN KEY (reviewer_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Ecommerce tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS product_categories (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT NULL,
    parent_id       CHAR(36) NULL,
    position        INT NOT NULL DEFAULT 0,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_categories_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_categories_parent FOREIGN KEY (parent_id) REFERENCES product_categories (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS products (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    category_id     CHAR(36) NULL,
    name            VARCHAR(200) NOT NULL,
    description     TEXT NULL,
    sku             VARCHAR(100) NULL,
    price           DECIMAL(10,2) NOT NULL,
    compare_at_price DECIMAL(10,2) NULL,
    tax_rate        DECIMAL(5,2) NULL,
    unit            VARCHAR(50) NULL,
    weight_grams    DECIMAL(10,2) NULL,
    is_digital      TINYINT(1) NOT NULL DEFAULT 0,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME NULL,
    CONSTRAINT fk_products_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES product_categories (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS product_images (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    product_id      CHAR(36) NOT NULL,
    image_url       VARCHAR(500) NOT NULL,
    is_primary      TINYINT(1) NOT NULL DEFAULT 0,
    position        INT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS inventory_items (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    location_id     CHAR(36) NULL,
    product_id      CHAR(36) NOT NULL,
    quantity        INT NOT NULL DEFAULT 0,
    safety_stock    INT NOT NULL DEFAULT 0,
    restock_level   INT NOT NULL DEFAULT 0,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_items_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_inventory_items_location FOREIGN KEY (location_id) REFERENCES business_locations (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_inventory_items_product FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS carts (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    user_id         CHAR(36) NULL,
    status          ENUM('active','converted','abandoned') NOT NULL DEFAULT 'active',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_carts_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cart_items (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    cart_id         CHAR(36) NOT NULL,
    product_id      CHAR(36) NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    unit_price      DECIMAL(10,2) NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS orders (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    user_id         CHAR(36) NOT NULL,
    cart_id         CHAR(36) NULL,
    order_number    VARCHAR(50) NOT NULL,
    status          ENUM('pending','paid','fulfilled','cancelled','refunded') NOT NULL DEFAULT 'pending',
    subtotal_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax_amount      DECIMAL(10,2) NOT NULL DEFAULT 0,
    shipping_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(10,2) NOT NULL,
    placed_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fulfilled_at    DATETIME NULL,
    cancelled_at    DATETIME NULL,
    cancellation_reason VARCHAR(255) NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_orders_number (order_number),
    CONSTRAINT fk_orders_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_orders_cart FOREIGN KEY (cart_id) REFERENCES carts (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS order_items (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    order_id        CHAR(36) NOT NULL,
    product_id      CHAR(36) NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    tax_amount      DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(10,2) NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS shipping_addresses (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    order_id        CHAR(36) NOT NULL,
    recipient_name  VARCHAR(150) NOT NULL,
    address_line1   VARCHAR(200) NOT NULL,
    address_line2   VARCHAR(200) NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NULL,
    postal_code     VARCHAR(20) NULL,
    country         VARCHAR(100) NOT NULL,
    phone           VARCHAR(30) NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shipping_addresses_order FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS payments (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    order_id        CHAR(36) NULL,
    appointment_id  CHAR(36) NULL,
    user_id         CHAR(36) NOT NULL,
    provider        VARCHAR(50) NOT NULL,
    provider_payment_id VARCHAR(100) NULL,
    amount          DECIMAL(10,2) NOT NULL,
    currency        VARCHAR(3) NOT NULL DEFAULT 'USD',
    status          ENUM('pending','authorized','paid','failed','refunded') NOT NULL DEFAULT 'pending',
    paid_at         DATETIME NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_payments_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_payments_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS product_reviews (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    product_id      CHAR(36) NOT NULL,
    reviewer_id     CHAR(36) NOT NULL,
    rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_reviews_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_reviews_product FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_reviews_user FOREIGN KEY (reviewer_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Courses / academy
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS courses (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    instructor_id   CHAR(36) NOT NULL,
    title           VARCHAR(200) NOT NULL,
    slug            VARCHAR(200) NOT NULL,
    description     TEXT NULL,
    cover_image_url VARCHAR(500) NULL,
    level           ENUM('beginner','intermediate','advanced') NULL,
    price           DECIMAL(10,2) NOT NULL DEFAULT 0,
    duration_minutes INT NULL,
    is_published    TINYINT(1) NOT NULL DEFAULT 0,
    published_at    DATETIME NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_courses_slug (slug),
    CONSTRAINT fk_courses_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_courses_instructor FOREIGN KEY (instructor_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS course_sections (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    course_id       CHAR(36) NOT NULL,
    title           VARCHAR(200) NOT NULL,
    position        INT NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_sections_course FOREIGN KEY (course_id) REFERENCES courses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS lessons (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    section_id      CHAR(36) NOT NULL,
    title           VARCHAR(200) NOT NULL,
    content_url     VARCHAR(500) NULL,
    content_type    ENUM('video','article','download','quiz') NOT NULL DEFAULT 'video',
    duration_minutes INT NULL,
    position        INT NOT NULL,
    is_preview      TINYINT(1) NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_lessons_section FOREIGN KEY (section_id) REFERENCES course_sections (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS course_purchases (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    course_id       CHAR(36) NOT NULL,
    user_id         CHAR(36) NOT NULL,
    business_id     CHAR(36) NOT NULL,
    order_id        CHAR(36) NULL,
    payment_id      CHAR(36) NULL,
    purchased_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at      DATETIME NULL,
    access_type     ENUM('lifetime','subscription','rental') NOT NULL DEFAULT 'lifetime',
    CONSTRAINT fk_course_purchases_course FOREIGN KEY (course_id) REFERENCES courses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_course_purchases_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_course_purchases_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_course_purchases_order FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_course_purchases_payment FOREIGN KEY (payment_id) REFERENCES payments (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS lesson_progress (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    lesson_id       CHAR(36) NOT NULL,
    user_id         CHAR(36) NOT NULL,
    status          ENUM('not_started','in_progress','completed') NOT NULL DEFAULT 'not_started',
    last_watched_second INT NULL,
    completed_at    DATETIME NULL,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_lesson_progress (lesson_id, user_id),
    CONSTRAINT fk_lesson_progress_lesson FOREIGN KEY (lesson_id) REFERENCES lessons (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_lesson_progress_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS course_reviews (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    course_id       CHAR(36) NOT NULL,
    reviewer_id     CHAR(36) NOT NULL,
    rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_reviews_course FOREIGN KEY (course_id) REFERENCES courses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_course_reviews_user FOREIGN KEY (reviewer_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Loyalty & marketing
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS loyalty_wallets (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    user_id         CHAR(36) NOT NULL,
    balance         INT NOT NULL DEFAULT 0,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_loyalty_wallets (business_id, user_id),
    CONSTRAINT fk_loyalty_wallets_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_loyalty_wallets_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS loyalty_transactions (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    wallet_id       CHAR(36) NOT NULL,
    source_type     ENUM('appointment','order','manual','promotion') NOT NULL,
    source_id       CHAR(36) NULL,
    points          INT NOT NULL,
    description     VARCHAR(255) NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_loyalty_transactions_wallet FOREIGN KEY (wallet_id) REFERENCES loyalty_wallets (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS promotions (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT NULL,
    discount_type   ENUM('percentage','fixed') NOT NULL,
    discount_value  DECIMAL(10,2) NOT NULL,
    starts_at       DATETIME NOT NULL,
    ends_at         DATETIME NULL,
    min_purchase_amount DECIMAL(10,2) NULL,
    usage_limit     INT NULL,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_promotions_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS coupons (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NOT NULL,
    code            VARCHAR(50) NOT NULL,
    description     TEXT NULL,
    discount_type   ENUM('percentage','fixed') NOT NULL,
    discount_value  DECIMAL(10,2) NOT NULL,
    max_uses        INT NULL,
    max_uses_per_user INT NULL,
    starts_at       DATETIME NOT NULL,
    ends_at         DATETIME NULL,
    is_active       TINYINT(1) NOT NULL DEFAULT 1,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY ux_coupons_code (business_id, code),
    CONSTRAINT fk_coupons_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS promotion_applications (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    promotion_id    CHAR(36) NULL,
    coupon_id       CHAR(36) NULL,
    order_id        CHAR(36) NULL,
    appointment_id  CHAR(36) NULL,
    applied_value   DECIMAL(10,2) NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_promo_applications_promotion FOREIGN KEY (promotion_id) REFERENCES promotions (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_promo_applications_coupon FOREIGN KEY (coupon_id) REFERENCES coupons (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_promo_applications_order FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_promo_applications_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Communication & support
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS notifications (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id         CHAR(36) NOT NULL,
    business_id     CHAR(36) NULL,
    title           VARCHAR(150) NOT NULL,
    body            TEXT NOT NULL,
    type            VARCHAR(50) NOT NULL,
    read_at         DATETIME NULL,
    sent_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metadata        JSON NULL,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_notifications_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS verification_codes (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    user_id         CHAR(36) NOT NULL,
    channel         ENUM('email','sms') NOT NULL,
    code            VARCHAR(10) NOT NULL,
    expires_at      DATETIME NOT NULL,
    consumed_at     DATETIME NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_verification_codes_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS support_tickets (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    business_id     CHAR(36) NULL,
    user_id         CHAR(36) NOT NULL,
    subject         VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    status          ENUM('open','in_progress','resolved','closed') NOT NULL DEFAULT 'open',
    priority        ENUM('low','medium','high') NOT NULL DEFAULT 'medium',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_support_tickets_business FOREIGN KEY (business_id) REFERENCES businesses (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_support_tickets_user FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS support_ticket_messages (
    id              CHAR(36) NOT NULL PRIMARY KEY DEFAULT (UUID()),
    ticket_id       CHAR(36) NOT NULL,
    sender_id       CHAR(36) NOT NULL,
    message         TEXT NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_support_messages_ticket FOREIGN KEY (ticket_id) REFERENCES support_tickets (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_support_messages_sender FOREIGN KEY (sender_id) REFERENCES users (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
