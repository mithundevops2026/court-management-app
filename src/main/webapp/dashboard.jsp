<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.court.model.CaseDocket" %>
<%@ page import="com.court.model.User" %>

<%
    // Authenticate judicial session
    User user = (User) session.getAttribute("validatedUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Fetch cases and metrics provided by DocketServlet
    List<CaseDocket> docketList = (List<CaseDocket>) request.getAttribute("docketList");
    Integer totalCases = (Integer) request.getAttribute("totalCases");
    Integer urgentCases = (Integer) request.getAttribute("urgentCases");
    Integer reviewsCases = (Integer) request.getAttribute("reviewsCases");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Portfolio - Judicial Cases Docket</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inter Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }
        .navbar-custom {
            background-color: #0f172a;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .stats-card {
            background: #ffffff;
            border: none;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
        .docket-table {
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            border: none;
        }
        .docket-table th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        .badge-high {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .badge-medium {
            background-color: #fef3c7;
            color: #92400e;
        }
        .badge-low {
            background-color: #dcfce7;
            color: #166534;
        }
        .badge-state {
            border-radius: 6px;
            padding: 5px 10px;
            font-size: 0.75rem;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <nav class="navbar navbar-dark navbar-expand-lg navbar-custom py-3">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <span class="fs-4 fw-bold text-white me-2">LexCuria</span>
                <span class="badge bg-secondary small">TOMCAT SECURE</span>
            </a>
            
            <div class="collapse navbar-collapse justify-content-end" id="navbarContent">
                <div class="d-flex align-items-center">
                    <span class="text-white-50 me-3 small">
                        Logged in: <strong class="text-white">Hon. <%= user.getFullName() %></strong> (Chamber <%= user.getChamber() %>)
                    </span>
                    <a href="<%= request.getContextPath() %>/login?action=logout" class="btn btn-outline-danger btn-sm">Log Out</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Content Workspace -->
    <div class="container my-5">
        
        <!-- Welcome Banner -->
        <div class="row mb-5">
            <div class="col-12">
                <h1 class="h3 fw-bold mb-1 col-9">Welcome Back, Hon. <%= user.getFullName() %></h1>
                <p class="text-muted mb-0">Reviewing pending cases and active dockets assigned to Courtroom <%= user.getCourtroom() %>.</p>
            </div>
        </div>

        <!-- Metric Widgets -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="stats-card p-4 d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small uppercase fw-bold">Active Case Docket</span>
                        <h2 class="display-6 fw-bold text-dark mt-1 mb-0"><%= totalCases != null ? totalCases : 0 %></h2>
                    </div>
                    <div class="p-3 bg-primary bg-opacity-10 rounded-circle text-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" class="bi bi-briefcase-fill" viewBox="0 0 16 16">
                            <path d="M6.5 1A1.5 1.5 0 0 0 5 2.5V3H1.5A1.5 1.5 0 0 0 0 4.5v1.384l.002.004a4.978 4.978 0 0 0 4.99 4.111H11a4.978 4.978 0 0 0 4.99-4.111L16 5.884V4.5A1.5 1.5 0 0 0 14.5 3H11v-.5A1.5 1.5 0 0 0 9.5 1h-3zm0 1h3a.5.5 0 0 1 .5.5V3H6v-.5a.5.5 0 0 1 .5-.5z"/>
                            <path d="M0 12.5A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5V6.85L8 11.25l-8-4.4V12.5z"/>
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stats-card p-4 d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small uppercase fw-bold">High Priority Actions</span>
                        <h2 class="display-6 fw-bold text-danger mt-1 mb-0"><%= urgentCases != null ? urgentCases : 0 %></h2>
                    </div>
                    <div class="p-3 bg-danger bg-opacity-10 rounded-circle text-danger">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" class="bi bi-clock-fill" viewBox="0 0 16 16">
                            <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .252.434l3.5 2a.5.5 0 0 0 .496-.868L8 8.71V3.5z"/>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stats-card p-4 d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small uppercase fw-bold">Dockets Scheduled Today</span>
                        <h2 class="display-6 fw-bold text-warning mt-1 mb-0"><%= reviewsCases != null ? reviewsCases : 0 %></h2>
                    </div>
                    <div class="p-3 bg-warning bg-opacity-10 rounded-circle text-warning">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor" class="bi bi-calendar3" viewBox="0 0 16 16">
                            <path d="M14 0H2a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zM1 3.857C1 3.384 1.448 3 2 3h12c.552 0 1 .384 1 .857v10.286c0 .473-.448.857-1 .857H2c-.552 0-1-.384-1-.857V3.857z"/>
                            <path d="M6.5 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm-9 3a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm3 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cases Table Section -->
        <div class="row">
            <div class="col-12">
                <div class="card docket-table border-0">
                    <div class="card-header border-0 bg-transparent py-3 d-flex justify-content-between align-items-center">
                        <h5 class="m-0 fw-bold text-dark">Active Courtroom Dockets</h5>
                        <button class="btn btn-primary btn-sm rounded-2 d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#newCaseModal">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-lg me-1" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5a.5.5 0 0 1 .5-.5z"/>
                            </svg>
                            Admit New Docket
                        </button>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4">Case #</th>
                                    <th>Title</th>
                                    <th>Type</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Scheduled Date</th>
                                    <th class="text-end pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (docketList == null || docketList.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            No active dockets assigned to your chambers. All clean.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for (CaseDocket docket : docketList) {
                                            String badgeClass = "badge-low";
                                            if ("High".equals(docket.getPriority())) badgeClass = "badge-high";
                                            else if ("Medium".equals(docket.getPriority())) badgeClass = "badge-medium";
                                            
                                            String statusBg = "bg-secondary";
                                            if ("Pending".equals(docket.getStatus())) statusBg = "bg-warning text-dark";
                                            else if ("Hearing Scheduled".equals(docket.getStatus())) statusBg = "bg-primary";
                                            else if ("Decided".equals(docket.getStatus())) statusBg = "bg-success";
                                            else if ("Under Review".equals(docket.getStatus())) statusBg = "bg-info text-dark";
                                %>
                                    <tr>
                                        <td class="ps-4 fw-mono text-secondary small"><%= docket.getCaseNumber() %></td>
                                        <td>
                                            <div class="fw-bold text-dark"><%= docket.getTitle() %></div>
                                            <span class="text-muted small display-block" style="font-size: 11px;"><%= docket.getDescription() %></span>
                                        </td>
                                        <td class="small fw-medium text-dark"><%= docket.getType() %></td>
                                        <td>
                                            <span class="badge badge-state <%= badgeClass %>"><%= docket.getPriority() %></span>
                                        </td>
                                        <td>
                                            <span class="badge bg-state <%= statusBg %>" style="font-size: 10px; padding: 4px 8px;"><%= docket.getStatus() %></span>
                                        </td>
                                        <td class="small text-muted"><%= docket.getHearingDate() %></td>
                                        <td class="text-end pe-4">
                                            <button onclick="populateUpdateModal('<%= docket.getCaseNumber() %>', '<%= docket.getTitle() %>', '<%= docket.getStatus() %>', '<%= docket.getLatestUpdate() %>')" class="btn btn-sm btn-outline-secondary rounded-2" data-bs-toggle="modal" data-bs-target="#updateDocketModal">
                                                Update Status
                                            </button>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CREATE CASE MODAL -->
    <div class="modal fade" id="newCaseModal" tabindex="-1" aria-labelledby="newCaseModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="newCaseModalLabel">Admit Court Docket</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/cases" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-medium">Case Number</label>
                                <input type="text" name="caseNumber" class="form-control" placeholder="TX-2026-8809" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-medium">Case Type</label>
                                <select name="type" class="form-select">
                                    <option value="Criminal">Criminal</option>
                                    <option value="Civil">Civil</option>
                                    <option value="Family">Family</option>
                                    <option value="Appellate">Appellate</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-medium">Litigants Title</label>
                                <input type="text" name="title" class="form-control" placeholder="State vs. Jameson" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-medium">Priority Level</label>
                                <select name="priority" class="form-select">
                                    <option value="Low">Low</option>
                                    <option value="Medium">Medium</option>
                                    <option value="High" selected>High</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-medium">Hearing Schedule Date</label>
                                <input type="date" name="hearingDate" class="form-control" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-medium">Litigations Brief Description</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Brief summarizing points regarding complaint charges..." required></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-sm">Record Case Docket</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- UPDATE STATUS MODAL -->
    <div class="modal fade" id="updateDocketModal" tabindex="-1" aria-labelledby="updateDocketModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="updateDocketModalLabel">Update Docket Proceedings</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/cases" method="POST">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="caseNumber" id="updateCaseNumber">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small text-muted">Case Docket Title</label>
                            <input type="text" id="updateCaseTitle" class="form-control-plaintext fw-bold text-dark fs-5" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Current Status</label>
                            <select name="status" id="updateCaseStatus" class="form-select" required>
                                <option value="Pending">Pending</option>
                                <option value="Under Review">Under Review</option>
                                <option value="Hearing Scheduled">Hearing Scheduled</option>
                                <option value="Decided">Decided</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Latest Court Action / Updates Log</label>
                            <textarea name="latestUpdate" id="updateCaseLog" class="form-control" rows="3" placeholder="Enter notes from the hearing or chambers decisions..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-sm">Post Official Action</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function populateUpdateModal(caseNumber, title, status, latestLog) {
            document.getElementById('updateCaseNumber').value = caseNumber;
            document.getElementById('updateCaseTitle').value = title;
            document.getElementById('updateCaseStatus').value = status;
            document.getElementById('updateCaseLog').value = latestLog || '';
        }
    </script>
</body>
</html>