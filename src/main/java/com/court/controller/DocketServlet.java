package com.court.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.court.model.CaseDocket;
import com.court.model.User;
import com.court.util.DatabaseConnection;

/**
 * Servlet handling fetching of active cases and statistics assigned specifically 
 * to the logged-in Judge's courtroom.
 */
@WebServlet("/cases")
public class DocketServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("validatedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("validatedUser");
        List<CaseDocket> docketList = new ArrayList<>();
        
        int total = 0;
        int urgent = 0;
        int reviewCount = 0;

        // DB Query parameters matching judicial courtroom index
        String query = "SELECT id, case_number, title, type, priority, status, hearing_date, courtroom, description, latest_update FROM court_cases WHERE courtroom = ? OR judge_id = ? ORDER BY CASE priority WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END, hearing_date ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, user.getCourtroom());
            stmt.setInt(2, user.getId());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CaseDocket cases = new CaseDocket();
                    cases.setId(rs.getInt("id"));
                    cases.setCaseNumber(rs.getString("case_number"));
                    cases.setTitle(rs.getString("title"));
                    cases.setType(rs.getString("type"));
                    cases.setPriority(rs.getString("priority"));
                    cases.setStatus(rs.getString("status"));
                    cases.setHearingDate(rs.getString("hearing_date"));
                    cases.setCourtroom(rs.getString("courtroom"));
                    cases.setDescription(rs.getString("description"));
                    cases.setLatestUpdate(rs.getString("latest_update"));

                    docketList.add(cases);
                    
                    total++;
                    if ("High".equalsIgnoreCase(cases.getPriority())) {
                        urgent++;
                    }
                    if ("Under Review".equalsIgnoreCase(cases.getStatus()) || "Pending".equalsIgnoreCase(cases.getStatus())) {
                        reviewCount++;
                    }
                }
            }
        } catch (Exception e) {
            getServletContext().log("Database exception fetching cases", e);
            request.setAttribute("errorMessage", "Error synchronizing secure court databases.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("docketList", docketList);
        request.setAttribute("totalCases", total);
        request.setAttribute("urgentCases", urgent);
        request.setAttribute("reviewsCases", reviewCount);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("validatedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("validatedUser");
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            String caseNumber = request.getParameter("caseNumber");
            String title = request.getParameter("title");
            String type = request.getParameter("type");
            String priority = request.getParameter("priority");
            String hearingDate = request.getParameter("hearingDate");
            String description = request.getParameter("description");

            String query = "INSERT INTO court_cases (case_number, title, type, priority, status, hearing_date, courtroom, judge_id, description, latest_update) VALUES (?, ?, ?, ?, 'Pending', ?, ?, ?, ?, 'Docket admitted into court records.')";

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                
                stmt.setString(1, caseNumber);
                stmt.setString(2, title);
                stmt.setString(3, type);
                stmt.setString(4, priority);
                stmt.setString(5, hearingDate);
                stmt.setString(6, user.getCourtroom());
                stmt.setInt(7, user.getId());
                stmt.setString(8, description);

                stmt.executeUpdate();
            } catch (Exception e) {
                getServletContext().log("Error admitting case", e);
                request.setAttribute("exception", e);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            String caseNumber = request.getParameter("caseNumber");
            String status = request.getParameter("status");
            String latestUpdate = request.getParameter("latestUpdate");

            String query = "UPDATE court_cases SET status = ?, latest_update = ? WHERE case_number = ? AND (courtroom = ? OR judge_id = ?)";

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                
                stmt.setString(1, status);
                stmt.setString(2, latestUpdate);
                stmt.setString(3, caseNumber);
                stmt.setString(4, user.getCourtroom());
                stmt.setInt(5, user.getId());

                stmt.executeUpdate();
            } catch (Exception e) {
                getServletContext().log("Error updating case proceedings", e);
                request.setAttribute("exception", e);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/cases");
    }
}