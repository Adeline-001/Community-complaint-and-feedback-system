<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Citizen Voice | Community Complaint System</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="logo">Citizen Voice</div>
        <div class="nav-links">
            <a href="landing.jsp">Home</a>
            <a href="login.jsp" class="btn btn-primary">Sign In</a>
        </div>
    </nav>

    <header class="hero">
        <h1>Your Voice, <span style="color: var(--primary)">Your Community.</span></h1>
        <p>Report issues, track solutions, and help us build a better society together. Transparent, efficient, and direct.</p>
        <div class="hero-btns">
            <a href="register.jsp" class="btn btn-primary">Get Started</a>
            <a href="login.jsp" style="margin-left: 1rem; color: white;">I'm an Admin</a>
        </div>
    </header>

    <section class="features" style="padding: 5rem 10%; display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem;">
        <div class="glass-container">
            <h3>Easy Reporting</h3>
            <p style="color: var(--text-gray); margin-top: 1rem;">Quickly submit complaints about water, electricity, roads, and more.</p>
        </div>
        <div class="glass-container">
            <h3>Real-time Tracking</h3>
            <p style="color: var(--text-gray); margin-top: 1rem;">Stay updated on the status of your reported issues every step of the way.</p>
        </div>
        <div class="glass-container">
            <h3>Transparent Governance</h3>
            <p style="color: var(--text-gray); margin-top: 1rem;">Direct communication between citizens and local authorities.</p>
        </div>
    </section>
</body>
</html>
