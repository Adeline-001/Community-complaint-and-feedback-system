<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Citizen Voice | Community Complaint System</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="logo">Citizen Voice</div>
        <div class="nav-links">
            <a href="landing.jsp">Home</a>
            <a href="#about">About</a>
            <a href="#contact">Contact</a>
            <a href="login.jsp" class="btn btn-primary">Sign In</a>
        </div>
    </nav>

    <header class="hero" style="display: flex; align-items: center; justify-content: space-between; text-align: left; padding: 4rem 10%; height: auto; min-height: 80vh; max-width: 1400px; margin: 0 auto;">
        <div class="hero-text" style="flex: 1; max-width: 600px; z-index: 2;">
            <div class="hero-badge" style="display: inline-block; padding: 0.5rem 1.2rem; background: rgba(99, 102, 241, 0.15); color: var(--primary); border: 1px solid rgba(99, 102, 241, 0.3); border-radius: 50px; font-weight: 600; font-size: 0.9rem; margin-bottom: 1.5rem;">
                <i class="fa-solid fa-bolt"></i> Next-Gen Civic Engagement
            </div>
            <h1 style="font-size: 4.5rem; line-height: 1.1; margin-bottom: 1.5rem; font-weight: 800;">
                Your Voice, <br>
                <span style="background: linear-gradient(135deg, var(--primary), var(--accent)); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Your Community.</span>
            </h1>
            <p style="font-size: 1.25rem; color: var(--text-gray); margin-bottom: 2.5rem; line-height: 1.6;">
                Report issues, track solutions, and help us build a better society together. Transparent, efficient, and direct.
            </p>
            <div class="hero-btns" style="display: flex; align-items: center; gap: 1.5rem;">
                <a href="register.jsp" class="btn btn-primary" style="padding: 1rem 2rem; font-size: 1.1rem; box-shadow: 0 10px 25px rgba(99, 102, 241, 0.4);">Get Started</a>
                <a href="login.jsp" style="color: white; text-decoration: none; font-weight: 600; font-size: 1.1rem; transition: color 0.3s;"><i class="fa-solid fa-right-to-bracket"></i> Sign In</a>
            </div>
        </div>
        <div class="hero-image-container" style="flex: 1.3; display: flex; justify-content: flex-end; position: relative; margin-left: 2rem;">
            <div style="position: absolute; width: 120%; height: 120%; background: radial-gradient(circle, var(--primary) 0%, transparent 60%); opacity: 0.3; filter: blur(60px); z-index: 0; left: -10%; top: -10%;"></div>
            <img src="img/landing_hero.png" alt="Community App Illustration" style="width: 100%; max-width: 800px; height: auto; border-radius: 20px; box-shadow: 0 30px 60px rgba(0,0,0,0.6); z-index: 1; border: 1px solid var(--glass-border); transform: scale(1.15) perspective(1000px) rotateY(-5deg); transition: transform 0.5s ease;">
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
    <section id="about" style="padding: 8rem 10%; background: rgba(15, 23, 42, 0.3); position: relative; overflow: hidden;">
        <div style="max-width: 1000px; margin: 0 auto; display: flex; align-items: center; gap: 4rem;">
            <div style="flex: 1;">
                <h2 style="font-size: 2.5rem; margin-bottom: 2rem;">Built for the <span style="color: var(--primary);">Community.</span></h2>
                <p style="color: var(--text-gray); line-height: 1.8; font-size: 1.1rem; margin-bottom: 1.5rem;">
                    Citizen Voice was created with one goal in mind: to empower every resident to have a direct say in the improvement of their neighborhood. No more long queues or ignored letters.
                </p>
                <p style="color: var(--text-gray); line-height: 1.8; font-size: 1.1rem;">
                    By leveraging modern technology, we ensure that every complaint is registered, tracked, and addressed by the right authorities, bringing transparency and accountability to local governance.
                </p>
            </div>
            <div class="glass-container" style="flex: 0.8; padding: 3rem; text-align: center;">
                <i class="fa-solid fa-users-viewfinder fa-4x" style="color: var(--primary); margin-bottom: 1.5rem;"></i>
                <h3 style="margin-bottom: 1rem;">100% Transparent</h3>
                <p style="color: var(--text-gray);">Every report is publicly trackable by the citizen who filed it.</p>
            </div>
        </div>
    </section>

    <section id="contact" style="padding: 8rem 10%;">
        <div style="text-align: center; margin-bottom: 5rem;">
            <h2 style="font-size: 2.5rem; margin-bottom: 1rem;">Get in <span style="color: var(--accent);">Touch</span></h2>
            <p style="color: var(--text-gray);">Have questions or need assistance? Our support team is here for you.</p>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1.5fr; gap: 4rem;">
            <div style="display: flex; flex-direction: column; gap: 2rem;">
                <div class="glass-container" style="display: flex; align-items: center; gap: 1.5rem; padding: 1.5rem;">
                    <div style="width: 50px; height: 50px; border-radius: 50%; background: rgba(99, 102, 241, 0.15); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                        <i class="fa-solid fa-envelope"></i>
                    </div>
                    <div>
                        <h4 style="margin-bottom: 0.2rem;">Email Us</h4>
                        <p style="color: var(--text-gray); font-size: 0.9rem;">support@citizenvoice.com</p>
                    </div>
                </div>
                <div class="glass-container" style="display: flex; align-items: center; gap: 1.5rem; padding: 1.5rem;">
                    <div style="width: 50px; height: 50px; border-radius: 50%; background: rgba(16, 185, 129, 0.15); display: flex; align-items: center; justify-content: center; color: var(--accent);">
                        <i class="fa-solid fa-phone"></i>
                    </div>
                    <div>
                        <h4 style="margin-bottom: 0.2rem;">Call Us</h4>
                        <p style="color: var(--text-gray); font-size: 0.9rem;">+251 912 345 678</p>
                    </div>
                </div>
                <div class="glass-container" style="display: flex; align-items: center; gap: 1.5rem; padding: 1.5rem;">
                    <div style="width: 50px; height: 50px; border-radius: 50%; background: rgba(239, 68, 68, 0.15); display: flex; align-items: center; justify-content: center; color: var(--danger);">
                        <i class="fa-solid fa-location-dot"></i>
                    </div>
                    <div>
                        <h4 style="margin-bottom: 0.2rem;">Office Location</h4>
                        <p style="color: var(--text-gray); font-size: 0.9rem;">Admin Tower, 4th Floor, City Square</p>
                    </div>
                </div>
            </div>
            <div class="glass-container">
                <form onsubmit="event.preventDefault(); alert('Message sent successfully!')">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.5rem;">
                        <div class="form-group">
                            <label>Name</label>
                            <input type="text" placeholder="John Doe">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" placeholder="john@example.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Message</label>
                        <textarea rows="5" placeholder="How can we help you?"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Send Message</button>
                </form>
            </div>
        </div>
    </section>

    <footer class="footer">
        <p>&copy; 2024 Citizen Voice. Empowering communities through transparency.</p>
        <div class="footer-links">
            <a href="#"><i class="fa-brands fa-facebook"></i></a>
            <a href="#"><i class="fa-brands fa-twitter"></i></a>
            <a href="#"><i class="fa-brands fa-linkedin"></i></a>
            <a href="#"><i class="fa-brands fa-github"></i></a>
        </div>
        <div style="margin-top: 2rem; opacity: 0.6; font-size: 0.8rem;">
            Designed for Citizen Voice Practical Project
        </div>
    </footer>
</body>
</html>
