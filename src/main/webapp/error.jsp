<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Oops! Something went wrong | Citizen Voice</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body style="display: flex; align-items: center; justify-content: center; height: 100vh; overflow: hidden;">
    <div class="bg-animation">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <div class="glass-container animate-up" style="text-align: center; max-width: 500px;">
        <i class="fa-solid fa-triangle-exclamation fa-5x" style="color: var(--danger); margin-bottom: 2rem;"></i>
        <h1 style="font-size: 3rem; margin-bottom: 1rem;">Oops!</h1>
        <p style="font-size: 1.2rem; color: var(--text-gray); margin-bottom: 2rem;">
            We couldn't find what you were looking for, or an unexpected error occurred.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center;">
            <a href="landing.jsp" class="btn btn-primary">
                <i class="fa-solid fa-house"></i> Go Home
            </a>
            <button onclick="history.back()" class="btn" style="background: rgba(255,255,255,0.1); color: white;">
                <i class="fa-solid fa-arrow-left"></i> Go Back
            </button>
        </div>
    </div>
</body>
</html>
