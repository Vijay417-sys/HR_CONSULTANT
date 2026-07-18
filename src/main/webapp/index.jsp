<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect(request.getContextPath() + ("ADMIN".equals(user.getRole()) ? "/admin/dashboard.jsp" : "/employee/dashboard.jsp"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRDesk — Smart Employee Management System</title>
    <meta name="description" content="HRDesk - Modern HR platform with QR Attendance, Auto Payroll & Leave Management.">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        html { scroll-behavior: smooth; }

        /* Background video */
        #bgVideo {
            position: absolute; inset: 0;
            width: 100%; height: 100%;
            object-fit: cover;
            z-index: 0;
        }
        .hero-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to bottom, rgba(15,23,42,.75), rgba(30,27,75,.8));
            z-index: 1;
        }

        .btn-primary {
            background: #6366f1; color: #fff;
            padding: .75rem 2rem; border-radius: .625rem;
            font-weight: 600; transition: all .2s;
            display: inline-flex; align-items: center; gap: .5rem; text-decoration: none;
        }
        .btn-primary:hover { background: #4f46e5; box-shadow: 0 8px 24px rgba(99,102,241,.5); transform: translateY(-2px); }
        .btn-outline {
            background: rgba(255,255,255,.1); color: #fff;
            border: 1.5px solid rgba(255,255,255,.5); backdrop-filter: blur(4px);
            padding: .75rem 2rem; border-radius: .625rem;
            font-weight: 600; transition: all .2s;
            display: inline-flex; align-items: center; gap: .5rem; text-decoration: none;
        }
        .btn-outline:hover { background: rgba(255,255,255,.25); transform: translateY(-2px); }

        .feature-card {
            background: #fff; border: 1px solid #e2e8f0; border-radius: 1rem;
            padding: 1.75rem; transition: all .25s; cursor: default;
        }
        .feature-card:hover { box-shadow: 0 12px 32px rgba(99,102,241,.15); transform: translateY(-6px) scale(1.02); border-color: #c7d2fe; }
        .feature-icon { width: 3rem; height: 3rem; border-radius: .75rem; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem; transition: transform .25s; }
        .feature-card:hover .feature-icon { transform: scale(1.15) rotate(-5deg); }

        /* Scroll reveal */
        .reveal { opacity: 0; transform: translateY(30px); transition: opacity .7s ease, transform .7s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }

        /* Video control buttons */
        .video-ctrl {
            width: 2.75rem; height: 2.75rem; border-radius: 9999px;
            background: rgba(255,255,255,.15); border: 1px solid rgba(255,255,255,.35);
            backdrop-filter: blur(6px); color: #fff;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; transition: all .2s;
        }
        .video-ctrl:hover { background: rgba(255,255,255,.3); transform: scale(1.1); }
    </style>
</head>
<body class="text-gray-900 bg-white">

<!-- Hero with background video -->
<section class="relative min-h-screen flex flex-col overflow-hidden">
    <video id="bgVideo" autoplay muted loop playsinline>
        <source src="<%= request.getContextPath() %>/assets/background.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay"></div>

    <!-- Navbar -->
    <nav class="relative z-10">
        <div class="max-w-7xl mx-auto px-6 py-5 flex items-center justify-between">
            <div class="flex items-center gap-2.5">
                <div class="w-9 h-9 bg-indigo-600 rounded-lg flex items-center justify-center">
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                </div>
                <span class="text-xl font-bold text-white">HRDesk</span>
            </div>
            <div class="flex items-center gap-4">
                <a href="login.jsp" class="text-sm font-medium text-white/80 hover:text-white transition-colors">Login</a>
                <a href="register.jsp" class="btn-primary" style="padding:.5rem 1.25rem;font-size:.875rem;">Get Started</a>
            </div>
        </div>
    </nav>

    <!-- Hero content -->
    <div class="relative z-10 flex-1 flex items-center justify-center px-6 py-16">
        <div class="max-w-4xl mx-auto text-center reveal visible">
            <span class="inline-flex items-center gap-2 bg-white/10 text-white text-sm font-medium px-4 py-1.5 rounded-full border border-white/25 backdrop-blur mb-8">
                <span class="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-pulse"></span>
                Modern HR Platform
            </span>
            <h1 class="text-5xl md:text-6xl font-black text-white mb-6 leading-tight tracking-tight">
                Manage Your Team<br>
                <span class="text-indigo-400">Smarter &amp; Faster</span>
            </h1>
            <p class="text-xl text-slate-200 max-w-2xl mx-auto mb-10 leading-relaxed">
                HRDesk brings QR attendance, automated payroll, and seamless leave management — all in one platform built for modern teams.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="login.jsp" class="btn-primary">
                    Get Started Free
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 7l5 5m0 0l-5 5m5-5H6"/></svg>
                </a>
                <a href="register.jsp" class="btn-outline">Create Account</a>
            </div>

            <!-- Animated stats -->
            <div class="grid grid-cols-3 gap-8 max-w-md mx-auto mt-16 pt-10 border-t border-white/20">
                <div class="text-center">
                    <p class="text-4xl font-extrabold text-white"><span class="counter" data-target="500">0</span>+</p>
                    <p class="text-slate-300 text-sm mt-1">Companies</p>
                </div>
                <div class="text-center border-x border-white/20">
                    <p class="text-4xl font-extrabold text-white"><span class="counter" data-target="10">0</span>K+</p>
                    <p class="text-slate-300 text-sm mt-1">Employees</p>
                </div>
                <div class="text-center">
                    <p class="text-4xl font-extrabold text-white"><span class="counter" data-target="99">0</span>%</p>
                    <p class="text-slate-300 text-sm mt-1">Uptime</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Video controls -->
    <div class="absolute bottom-6 right-6 z-10 flex gap-3">
        <button id="soundBtn" class="video-ctrl" title="Toggle sound">
            <svg id="soundOffIcon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15zM17 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2"/></svg>
            <svg id="soundOnIcon" class="w-5 h-5 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072M18.364 5.636a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z"/></svg>
        </button>
        <button id="playBtn" class="video-ctrl" title="Play / Pause video">
            <svg id="pauseIcon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 9v6m4-6v6"/></svg>
            <svg id="playIcon" class="w-5 h-5 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/></svg>
        </button>
    </div>

    <!-- Scroll down hint -->
    <a href="#features" class="absolute bottom-6 left-1/2 -translate-x-1/2 z-10 text-white/70 hover:text-white transition-colors animate-bounce" title="Scroll down">
        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"/></svg>
    </a>
</section>

<!-- Features -->
<section id="features" class="py-24 px-6 bg-gray-50">
    <div class="max-w-7xl mx-auto">
        <div class="text-center mb-16 reveal">
            <h2 class="text-3xl font-bold text-gray-900 mb-3">Everything You Need</h2>
            <p class="text-gray-500 text-lg">Powerful tools to streamline your HR operations</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="feature-card reveal">
                <div class="feature-icon bg-indigo-50"><svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"/></svg></div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Dynamic QR Attendance</h3>
                <p class="text-gray-500 text-sm leading-relaxed">QR codes refresh every 25 seconds. Employees scan to mark attendance instantly — no manual entries.</p>
            </div>
            <div class="feature-card reveal">
                <div class="feature-icon bg-emerald-50"><svg class="w-6 h-6 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg></div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Auto Payroll Generation</h3>
                <p class="text-gray-500 text-sm leading-relaxed">Auto salary calculations with leave deductions, bonuses, and tax. One-click payslip generation.</p>
            </div>
            <div class="feature-card reveal">
                <div class="feature-icon bg-amber-50"><svg class="w-6 h-6 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg></div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Smart Leave Management</h3>
                <p class="text-gray-500 text-sm leading-relaxed">Apply, track, and approve leaves online with real-time balance updates and approval workflows.</p>
            </div>
            <div class="feature-card reveal">
                <div class="feature-icon bg-sky-50"><svg class="w-6 h-6 text-sky-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg></div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Department Management</h3>
                <p class="text-gray-500 text-sm leading-relaxed">Organize employees by departments, manage hierarchies and headcount with ease.</p>
            </div>
            <div class="feature-card reveal">
                <div class="feature-icon bg-rose-50"><svg class="w-6 h-6 text-rose-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg></div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Analytics &amp; Reports</h3>
                <p class="text-gray-500 text-sm leading-relaxed">Comprehensive attendance, payroll, and leave reports with real-time data visualization.</p>
            </div>
            <div class="feature-card reveal">
                <div class="feature-icon bg-purple-50"><svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg></div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Support Tickets</h3>
                <p class="text-gray-500 text-sm leading-relaxed">Employees raise HR tickets; admins resolve them with full status tracking and history.</p>
            </div>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="py-20 px-6 bg-indigo-600">
    <div class="max-w-3xl mx-auto text-center reveal">
        <h2 class="text-3xl font-bold text-white mb-4">Ready to Transform Your HR?</h2>
        <p class="text-indigo-200 text-lg mb-8">Join thousands of companies using HRDesk to manage their workforce efficiently.</p>
        <a href="register.jsp" class="inline-flex items-center gap-2 bg-white text-indigo-600 font-bold px-8 py-4 rounded-xl hover:bg-indigo-50 hover:scale-105 transition-all">
            Start for Free Today
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 7l5 5m0 0l-5 5m5-5H6"/></svg>
        </a>
    </div>
</section>

<footer class="bg-white border-t border-gray-100 py-8 text-center">
    <p class="text-gray-400 text-sm">© 2025 <span class="text-indigo-600 font-semibold">HRDesk</span> — Smart Employee Management System</p>
</footer>

<script>
    // --- Background video controls ---
    const video = document.getElementById('bgVideo');

    document.getElementById('soundBtn').addEventListener('click', () => {
        video.muted = !video.muted;
        document.getElementById('soundOnIcon').classList.toggle('hidden', video.muted);
        document.getElementById('soundOffIcon').classList.toggle('hidden', !video.muted);
    });

    document.getElementById('playBtn').addEventListener('click', () => {
        if (video.paused) { video.play(); } else { video.pause(); }
        document.getElementById('playIcon').classList.toggle('hidden', !video.paused);
        document.getElementById('pauseIcon').classList.toggle('hidden', video.paused);
    });

    // --- Scroll reveal animations ---
    const revealObserver = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                revealObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.15 });
    document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));

    // --- Animated stat counters ---
    const counterObserver = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            const el = entry.target;
            const target = +el.dataset.target;
            const duration = 1500;
            const start = performance.now();
            (function tick(now) {
                const progress = Math.min((now - start) / duration, 1);
                el.textContent = Math.floor(progress * target);
                if (progress < 1) requestAnimationFrame(tick);
            })(start);
            counterObserver.unobserve(el);
        });
    }, { threshold: 0.5 });
    document.querySelectorAll('.counter').forEach(el => counterObserver.observe(el));
</script>
</body>
</html>
