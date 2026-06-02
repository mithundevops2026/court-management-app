<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LexCuria - Judicial System Error</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #fef2f2;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-card {
            max-width: 500px;
            width: 100%;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(153, 27, 27, 0.05);
            border-top: 6px solid #dc2626;
        }
        .error-title {
            color: #991b1b;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="error-card p-5 text-center">
        <svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" fill="currentColor" class="bi bi-shield-slash-fill text-danger mb-4" viewBox="0 0 16 16">
            <path fill-rule="evenodd" d="M1.093 3.093c-.496.146-.697.74-.325 1.112l10.957 10.957c.372.372.966.171 1.112-.325A8.004 8.004 0 0 0 16 8c0-4.42-3.58-8-8-8a8.004 8.004 0 0 0-6.907 3.093zM1.464 1.464a.5.5 0 0 0-.707.707l1.414 1.414 11.314 11.314 1.414-1.414L1.464 1.464zM2.89 5.717 11.283 14.11A7.002 7.002 0 0 1 1 8c0-1.074.241-2.09.673-3H2.89z"/>
        </svg>
        <h2 class="error-title mb-2">Security or Runtime Exception</h2>
        <p class="text-secondary mb-4">The server encountered a security constraint or runtime processing error handling your judicial request.</p>
        
        <div class="alert alert-danger text-start small mb-4">
            <strong>Exception Detail:</strong><br>
            <span class="font-monospace text-break">
                <%= exception != null ? exception.toString() : "Nullpointer or CSRF token security mismatch." %>
            </span>
        </div>

        <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-danger btn-sm">Return to Login Portal</a>
    </div>
</body>
</html>