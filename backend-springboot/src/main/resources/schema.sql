-- MySQL Database DDL Schema for SmartCity 360
CREATE DATABASE IF NOT EXISTS smartcity360;
USE smartcity360;

CREATE TABLE IF NOT EXISTS departments (
    id VARCHAR(36) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    head_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    open_tickets INT DEFAULT 0,
    resolved_tickets INT DEFAULT 0,
    sla_hours INT DEFAULT 24
);

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('CITIZEN', 'STAFF', 'ADMIN') NOT NULL,
    department_id VARCHAR(36),
    points INT DEFAULT 0,
    level INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_department FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE IF NOT EXISTS complaints (
    id VARCHAR(36) PRIMARY KEY,
    ticket_number VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('ROADS', 'STREETLIGHTS', 'WASTE', 'WATER', 'POLLUTION', 'TRAFFIC', 'EMERGENCIES') NOT NULL,
    sector ENUM('DOWNTOWN', 'TECH_PARK', 'INDUSTRIAL_ZONE', 'HARBOR_DISTRICT', 'GREEN_RESIDENTIAL') NOT NULL,
    location_details VARCHAR(255) NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL,
    status ENUM('NEW', 'IN_PROGRESS', 'RESOLVED', 'REJECTED') DEFAULT 'NEW',
    citizen_id VARCHAR(36) NOT NULL,
    department_id VARCHAR(36) NOT NULL,
    assigned_staff_id VARCHAR(36),
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS complaint_events (
    id VARCHAR(36) PRIMARY KEY,
    complaint_id VARCHAR(36) NOT NULL,
    actor_id VARCHAR(36) NOT NULL,
    actor_role ENUM('CITIZEN', 'STAFF', 'ADMIN') NOT NULL,
    action VARCHAR(50) NOT NULL,
    from_status ENUM('NEW', 'IN_PROGRESS', 'RESOLVED', 'REJECTED'),
    to_status ENUM('NEW', 'IN_PROGRESS', 'RESOLVED', 'REJECTED'),
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
