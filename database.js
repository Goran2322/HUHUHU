const mysql = require('mysql2/promise');
require('dotenv').config();

// Database configuration
const dbConfig = {
    host: "localhost",
    user: "root",
    password: "Bawan2006@",
    database: "dev",
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
};

// Create a connection pool
const pool = mysql.createPool(dbConfig);

// Test database connection
async function testConnection() {
    try {
        const connection = await pool.getConnection();
        console.log('Database connected successfully!');
        connection.release();
        return true;
    } catch (error) {
        console.error('Database connection failed:', error);
        return false;
    }
}

// Query helper function
async function query(sql, params) {
    try {
        const [results] = await pool.execute(sql, params);
        return results;
    } catch (error) {
        console.error('Error executing query:', error);
        throw error;
    }
}

// Initialize database tables
async function initDatabase() {
    try {
        // Create players table if it doesn't exist
        await query(`
            CREATE TABLE IF NOT EXISTS players (
                id INT AUTO_INCREMENT PRIMARY KEY,
                socialClub VARCHAR(255) NOT NULL,
                name VARCHAR(255) NOT NULL,
                password VARCHAR(255) NOT NULL,
                money INT DEFAULT 5000,
                bank INT DEFAULT 10000,
                lastPosition JSON,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                UNIQUE KEY unique_socialclub (socialClub)
            )
        `);
        
        // Create vehicles table if it doesn't exist
        await query(`
            CREATE TABLE IF NOT EXISTS vehicles (
                id INT AUTO_INCREMENT PRIMARY KEY,
                owner_id INT,
                model VARCHAR(255) NOT NULL,
                position JSON,
                rotation JSON,
                color1 INT,
                color2 INT,
                fuel FLOAT DEFAULT 100,
                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (owner_id) REFERENCES players(id) ON DELETE CASCADE
            )
        `);
        
        console.log('Database tables initialized successfully!');
    } catch (error) {
        console.error('Error initializing database:', error);
    }
}

module.exports = {
    pool,
    query,
    testConnection,
    initDatabase
};