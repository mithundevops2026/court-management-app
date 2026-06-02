<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LexCuria - Secure Secure Login Portal</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts & Icon CDN -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f9;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            background: #ffffff;
            overflow: hidden;
            max-width: 450px;
            width: 100%;
        }
        .card-accent {
            height: 6px;
            background: linear-gradient(90deg, #1e3a8a 0%, #3b82f6 100%);
        }
        .btn-primary {
            background-color: #1e3a8a;
            border-color: #1e3a8a;
            padding: 10px 24px;
            font-weight: 500;
        }
        .btn-primary:hover {
            background-color: #172e70;
            border-color: #172e70;
        }
        .login-header {
            color: #1e3a8a;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
    </style>
</head>
<body>

    <div class="login-card p-4">
        <div class="card-accent mb-4"></div>
        <div class="text-center mb-4">
            <h2 class="login-header mb-1">LexCuria</h2>
            <p class="text-muted small">Official Judicial Docket & Case Management Portal</p>
        </div>

        <%
            String errorMsg = (String) request.getAttribute("errorMessage");
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-exclamation-triangle-fill me-2" viewBox="0 0 16 16">
                    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                </svg>
                <div><%= errorMsg %></div>
            </div>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/login" method="POST" autocomplete="off">
            <div class="mb-3">
                <label for="username" class="form-label text-secondary small fw-medium">Judiciary Credentials ID</label>
                <input type="text" class="form-control py-2" id="username" name="username" placeholder="e.g. j_collins" required autofocus>
            </div>
            
            <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <label for="password" class="form-label text-secondary small fw-medium mb-0">Security Password</label>
                    <a href="#" class="text-decoration-none small text-muted">Forgot?</a>
                </div>
                <input type="password" class="form-control py-2" id="password" name="password" placeholder="••••••••" required>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary rounded-3 text-white">Authenticate Credentials</button>
            </div>
            
            <div class="text-center mt-4">
                <p class="small text-muted mb-0">Authorized Judicial Access Only.</p>
                <span class="text-muted d-block" style="font-size: 10px;">Subject to monitoring under Title 18 USC Sec. 1030.</span>
            </div>
        </form>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>