document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const errorMessage = document.getElementById('errorMessage');

    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault(); // Stop page from reloading

        // 1. Gather data
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const submitBtn = loginForm.querySelector('button');

        // 2. UI Feedback (Loading state)
        submitBtn.textContent = 'Logging in...';
        submitBtn.disabled = true;
        errorMessage.style.display = 'none';

        try {
            // 3. Send to Backend (Replace with your actual API endpoint)
            // Example: fetch('https://api.yourdomain.com/login', { ... })

            // SIMULATING A SERVER REQUEST FOR DEMO:
            await new Promise(r => setTimeout(r, 1500));

            if (email === "test@anchor.com" && password === "password123") {
                // Success logic (set frontend login flags for compatibility)
                localStorage.setItem('isLoggedIn', 'true');
                localStorage.setItem('loggedIn', 'true');
                localStorage.setItem('userName', 'Demo User');
                // Redirect to dashboard
                alert("Login Successful!");
                window.location.href = "dashboard.html";
            } else {
                throw new Error("Invalid email or password.");
            }

        } catch (error) {
            // 4. Handle Errors
            errorMessage.textContent = error.message;
            errorMessage.style.display = 'block';
        } finally {
            // 5. Reset Button
            submitBtn.textContent = 'Log In';
            submitBtn.disabled = false;
        }
    });
});