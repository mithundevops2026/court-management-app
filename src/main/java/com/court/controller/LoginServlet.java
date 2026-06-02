package com.court.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.court.model.User;
import com.court.util.DatabaseConnection;

/**
 * Servlet handling secure judicial authentication.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String pinSecret = request.getParameter("password");
        
        // Secure sanitization against injection in standard logins
        if (username == null || username.trim().isEmpty() || pinSecret == null || pinSecret.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid Username or Password criteria.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User authenticatedUser = null;
        
        // SQL Prepared Statement context
        String query = "SELECT id, username, full_name, role, chamber, courtroom, active FROM court_judges WHERE username = ? AND password_hash = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, username.trim().toLowerCase());
            // Standard JCA SHA-256 password checksum / verification simulation
            stmt.setString(2, DatabaseConnection.hashPassword(pinSecret));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    boolean isActive = rs.getBoolean("active");
                    if (isActive) {
                        authenticatedUser = new User();
                        authenticatedUser.setId(rs.getInt("id"));
                        authenticatedUser.setUsername(rs.getString("username"));
                        authenticatedUser.setFullName(rs.getString("full_name"));
                        authenticatedUser.setRole(rs.getString("role"));
                        authenticatedUser.setChamber(rs.getString("chamber"));
                        authenticatedUser.setCourtroom(rs.getString("courtroom"));
                    }
                }
            }
        } catch (Exception e) {
            getServletContext().log("Judicial Auth Database Exception", e);
            // Graceful error fallback
            request.setAttribute("errorMessage", "Credential verification database offline.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (authenticatedUser != null) {
            // Establish Secure Http Session state
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(1800); // 30 mins session absolute timeout
            session.setAttribute("validatedUser", authenticatedUser);
            
            // Redirect safely to Judge Docket Index (DocketServlet resolves listing)
            response.sendRedirect(request.getContextPath() + "/cases");
        } else {
            request.setAttribute("errorMessage", "Judicial clearance failed. Incorrect security ID or PIN password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}