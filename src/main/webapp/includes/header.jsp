<%@ page import="com.hrdesk.dto.User" %>
<%
    User _hUser = (User) session.getAttribute("user");
    String userName = (_hUser != null) ? _hUser.getUsername() : "Guest";
    String userRole = (_hUser != null) ? _hUser.getRole() : "";
    String currentPage = request.getServletPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRDesk — Smart HR Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *{font-family:'Inter',sans-serif;}
        body{background:#f8fafc;}
        ::-webkit-scrollbar{width:5px;}::-webkit-scrollbar-track{background:#f1f5f9;}::-webkit-scrollbar-thumb{background:#6366f1;border-radius:10px;}
        .sidebar{background:#fff;border-right:1px solid #e2e8f0;}
        .nav-link{display:flex;align-items:center;gap:.625rem;padding:.5rem .75rem;border-radius:.5rem;color:#64748b;font-size:.875rem;font-weight:500;transition:all .15s;text-decoration:none;}
        .nav-link:hover{background:#f1f5f9;color:#1e293b;}
        .nav-link.active{background:#eef2ff;color:#6366f1;}
        .card{background:#fff;border:1px solid #e2e8f0;border-radius:.75rem;}
        .btn-primary{background:#6366f1;color:#fff;border-radius:.5rem;padding:.5rem 1.25rem;font-size:.875rem;font-weight:500;transition:all .15s;display:inline-flex;align-items:center;gap:.375rem;cursor:pointer;border:none;}
        .btn-primary:hover{background:#4f46e5;box-shadow:0 4px 12px rgba(99,102,241,.35);}
        .btn-secondary{background:#f1f5f9;color:#475569;border-radius:.5rem;padding:.5rem 1.25rem;font-size:.875rem;font-weight:500;transition:all .15s;display:inline-flex;align-items:center;gap:.375rem;cursor:pointer;border:none;}
        .btn-secondary:hover{background:#e2e8f0;}
        .btn-danger{background:#fef2f2;color:#ef4444;border:1px solid #fecaca;border-radius:.5rem;padding:.375rem .75rem;font-size:.8125rem;font-weight:500;transition:all .15s;cursor:pointer;}
        .btn-danger:hover{background:#fee2e2;}
        .btn-success{background:#f0fdf4;color:#16a34a;border:1px solid #bbf7d0;border-radius:.5rem;padding:.375rem .75rem;font-size:.8125rem;font-weight:500;transition:all .15s;cursor:pointer;}
        .btn-success:hover{background:#dcfce7;}
        .input-field{background:#fff;border:1px solid #e2e8f0;border-radius:.5rem;padding:.625rem .875rem;font-size:.875rem;color:#1e293b;width:100%;transition:border-color .15s,box-shadow .15s;}
        .input-field:focus{outline:none;border-color:#6366f1;box-shadow:0 0 0 3px rgba(99,102,241,.1);}
        select.input-field option{background:#fff;color:#1e293b;}
        .input-label{font-size:.8125rem;font-weight:500;color:#374151;margin-bottom:.375rem;display:block;}
        .data-table{width:100%;border-collapse:collapse;}
        .data-table th{background:#f8fafc;font-size:.75rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.05em;padding:.75rem 1rem;text-align:left;border-bottom:1px solid #e2e8f0;}
        .data-table td{padding:.875rem 1rem;border-bottom:1px solid #f1f5f9;font-size:.875rem;color:#374151;}
        .data-table tbody tr:hover td{background:#fafbff;}
        .badge{display:inline-flex;align-items:center;padding:.2rem .625rem;border-radius:9999px;font-size:.75rem;font-weight:500;}
        .badge-green{background:#f0fdf4;color:#16a34a;border:1px solid #bbf7d0;}
        .badge-red{background:#fef2f2;color:#dc2626;border:1px solid #fecaca;}
        .badge-yellow{background:#fefce8;color:#d97706;border:1px solid #fde68a;}
        .badge-blue{background:#eef2ff;color:#6366f1;border:1px solid #c7d2fe;}
        .badge-gray{background:#f8fafc;color:#64748b;border:1px solid #e2e8f0;}
        @keyframes fadeUp{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
        .animate-fade{animation:fadeUp .3s ease-out;}
        .page-section{margin-bottom:1.5rem;}
        .section-title{font-size:1rem;font-weight:600;color:#1e293b;margin-bottom:1rem;}
        .form-group{margin-bottom:1.25rem;}
        .form-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:1.25rem;}
        @media(max-width:640px){.form-grid{grid-template-columns:1fr;}}
    </style>
</head>
<body class="text-gray-900">

<% if (_hUser != null) { %>
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="sidebar w-60 min-h-screen flex flex-col fixed left-0 top-0 z-40" style="box-shadow:1px 0 0 #e2e8f0;">
        <!-- Logo -->
        <div class="px-5 py-4 border-b border-gray-100">
            <a href="<%= request.getContextPath() %>/dashboard" class="flex items-center gap-2.5 no-underline">
                <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center">
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                </div>
                <div>
                    <p class="text-sm font-bold text-gray-900 leading-none">HRDesk</p>
                    <p class="text-xs text-gray-400 leading-none mt-0.5">HR System</p>
                </div>
            </a>
        </div>

        <!-- User card -->
        <div class="px-3 pt-3 pb-2">
            <div class="flex items-center gap-2.5 px-3 py-2.5 bg-gray-50 rounded-lg border border-gray-100">
                <div class="w-8 h-8 bg-indigo-600 rounded-full flex items-center justify-center text-white font-semibold text-xs flex-shrink-0">
                    <%= userName.length() > 0 ? String.valueOf(userName.charAt(0)).toUpperCase() : "U" %>
                </div>
                <div class="min-w-0">
                    <p class="text-xs font-semibold text-gray-900 truncate"><%= userName %></p>
                    <span class="text-xs px-1.5 py-0.5 rounded <%= userRole.equals("ADMIN") ? "bg-indigo-100 text-indigo-700" : "bg-green-100 text-green-700" %>"><%= userRole %></span>
                </div>
            </div>
        </div>

        <!-- Nav -->
        <nav class="flex-1 px-2 py-2 space-y-0.5 overflow-y-auto">
            <% if (userRole.equals("ADMIN")) { %>
            <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider px-2 pt-2 pb-1">Admin</p>
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>Dashboard</a>
            <a href="<%= request.getContextPath() %>/employee?action=add" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>Add Employee</a>
            <a href="<%= request.getContextPath() %>/employee?action=list" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>Employees</a>
            <a href="<%= request.getContextPath() %>/dept?action=list" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>Departments</a>
            <a href="<%= request.getContextPath() %>/attendance?action=list" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>Attendance</a>
            <a href="<%= request.getContextPath() %>/leave?action=list" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>Leave Requests</a>
            <a href="<%= request.getContextPath() %>/payroll?action=list" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>Payroll</a>
            <a href="<%= request.getContextPath() %>/support?action=list" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>Support Tickets</a>
            <% } else { %>
            <p class="text-xs font-semibold text-gray-400 uppercase tracking-wider px-2 pt-2 pb-1">My Portal</p>
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>Dashboard</a>
            <a href="<%= request.getContextPath() %>/employee/my-profile.jsp" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>My Profile</a>
            <a href="<%= request.getContextPath() %>/attendance?action=my" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>Attendance</a>
            <a href="<%= request.getContextPath() %>/leave?action=apply" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>Apply Leave</a>
            <a href="<%= request.getContextPath() %>/leave?action=my" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>My Leaves</a>
            <a href="<%= request.getContextPath() %>/payroll?action=my" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>My Payslip</a>
            <a href="<%= request.getContextPath() %>/support?action=raise" class="nav-link"><svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>Support</a>
            <% } %>
        </nav>

        <!-- Logout -->
        <div class="px-2 py-3 border-t border-gray-100">
            <a href="<%= request.getContextPath() %>/logout" class="nav-link text-red-500 hover:bg-red-50">
                <svg style="width:16px;height:16px;flex-shrink:0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                Logout
            </a>
        </div>
    </aside>

    <!-- Main -->
    <main class="flex-1 min-h-screen" style="margin-left:240px;">
        <header class="bg-white border-b border-gray-200 px-8 py-4 flex items-center justify-between sticky top-0 z-30" style="box-shadow:0 1px 3px rgba(0,0,0,.05);">
            <div>
                <h2 class="text-sm font-semibold text-gray-900" id="page-title">Dashboard</h2>
                <p class="text-xs text-gray-400 mt-0.5" id="page-breadcrumb">HRDesk / Overview</p>
            </div>
            <div class="flex items-center gap-3">
                <div class="text-right hidden sm:block">
                    <p class="text-sm font-semibold text-gray-900"><%= userName %></p>
                    <p class="text-xs text-gray-400"><%= userRole %></p>
                </div>
                <div class="w-8 h-8 bg-indigo-600 rounded-full flex items-center justify-center text-white font-semibold text-xs">
                    <%= userName.length() > 0 ? String.valueOf(userName.charAt(0)).toUpperCase() : "U" %>
                </div>
            </div>
        </header>
        <div class="p-7 animate-fade">
<% } else { %>
<!-- PUBLIC PAGES — no sidebar -->
<% } %>