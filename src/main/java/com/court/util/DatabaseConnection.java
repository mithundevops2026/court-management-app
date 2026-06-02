package com.court.util;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * Manages SQL Connections. Supports Tomcat JNDI Data Sources 
 * with a high-performance local H2 databases in-memory fallback.
 */
public class DatabaseConnection {

    private static DataSource dataSource = null;
    private static final String DEFAULT_DB_URL = "jdbc:h2:mem:court_db;DB_CLOSE_DELAY=-1;INIT=runscript from 'classpath:schema.sql'";

    static {
        try {
            // Attempt looking up Apache Tomcat Server-managed JNDI Resource DataSource
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            dataSource = (DataSource) envCtx.lookup("jdbc/CourtDB");
        } catch (Exception ex) {
            // Fallback for standalone/local Tomcat or dev builds lacking system JNDI properties
            System.err.println("JNDI DataSource 'jdbc/CourtDB' lookup failed. Fallback to Local JDBC Driver.");
        }
    }

    /**
     * Retrieve database connection.
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        if (dataSource != null) {
            return dataSource.getConnection();
        }
        
        // Manual standard JDBC connection pool setup for Local testing
        Class.forName("org.h2.Driver");
        return DriverManager.getConnection(DEFAULT_DB_URL, "sa", "");
    }

    /**
     * Standard SHA-256 Hash implementation for authenticating judges logins safely.
     */
    public static String hashPassword(String originalPassword) {
        if (originalPassword == null) return "";
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(originalPassword.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception ex) {
            throw new RuntimeException("SHA-256 cryptographic algorithm unavailable.", ex);
        }
    }
}