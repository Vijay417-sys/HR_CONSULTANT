<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRDesk — Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *{font-family:'Inter',sans-serif;}
        body{background:#f8fafc;}
        .input-field{background:#fff;border:1px solid #e2e8f0;border-radius:.5rem;padding:.625rem .875rem;font-size:.875rem;color:#1e293b;width:100%;transition:border-color .15s,box-shadow .15s;}
        .input-field:focus{outline:none;border-color:#6366f1;box-shadow:0 0 0 3px rgba(99,102,241,.1);}
        .input-field::placeholder{color:#94a3b8;}
        .btn-primary{background:#6366f1;color:#fff;border-radius:.5rem;padding:.75rem 1rem;font-size:.9375rem;font-weight:600;width:100%;cursor:pointer;border:none;transition:all .2s;}
        .btn-primary:hover{background:#4f46e5;box-shadow:0 6px 20px rgba(99,102,241,.35);}
        .login-card{background:#fff;border:1px solid #e2e8f0;border-radius:1rem;padding:2.5rem;box-shadow:0 4px 24px rgba(0,0,0,.06);}
        .input-label{font-size:.8125rem;font-weight:500;color:#374151;margin-bottom:.375rem;display:block;}
        @keyframes fadeUp{from{opacity:0;transform:translateY(12px);}to{opacity:1;transform:translateY(0);}}
        .animate-in{animation:fadeUp .4s ease-out;}
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-sm animate-in">
        <!-- Logo -->
        <div class="text-center mb-8">
            <a href="index.jsp" class="inline-flex items-center gap-2.5 no-underline">
                <div class="w-10 h-10 bg-indigo-600 rounded-xl flex items-center justify-center">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                </div>
                <span class="text-2xl font-bold text-gray-900">HRDesk</span>
            </a>
            <p class="text-gray-500 text-sm mt-3">Welcome back! Sign in to your account.</p>
        </div>

        <div class="login-card">
            <% if (request.getAttribute("error") != null) { %>
            <div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-5 text-sm">
                <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
            <div class="flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-5 text-sm">
                <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post" class="space-y-5">
                <div>
                    <label class="input-label" for="login-email">Email Address</label>
                    <input type="email" name="email" id="login-email" placeholder="you@company.com" class="input-field" required>
                </div>
                <div>
                    <div class="flex justify-between items-center mb-1.5">
                        <label class="input-label" style="margin-bottom:0;" for="login-password">Password</label>
                        <a href="#" class="text-xs text-indigo-600 hover:text-indigo-800 font-medium">Forgot password?</a>
                    </div>
                    <input type="password" name="password" id="login-password" placeholder="••••••••" class="input-field" required>
                </div>
                <button type="submit" id="login-btn" class="btn-primary">Sign In to HRDesk</button>
            </form>

            <p class="text-center mt-5 text-sm text-gray-500">
                Don't have an account?
                <a href="register.jsp" class="text-indigo-600 hover:text-indigo-800 font-semibold">Register here</a>
            </p>
        </div>

        <p class="text-center mt-5 text-xs text-gray-400">
            <a href="index.jsp" class="hover:text-gray-600 transition-colors">← Back to Home</a>
        </p>
    </div>
</body>
</html>