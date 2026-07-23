<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    request.setAttribute("navPage", "dashboard");
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='My Dashboard';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Dashboard';</script>

<!-- ─── Welcome Banner ─── -->
<div class="rounded-xl p-6 mb-7 flex items-center justify-between bg-gradient-to-r from-indigo-600 via-indigo-500 to-purple-600 text-white shadow-lg">
    <div>
        <p class="text-indigo-200 text-sm mb-1 font-medium">Welcome back 👋</p>
        <h2 class="text-2xl font-bold tracking-tight"><%= user.getUsername() %></h2>
        <p class="text-indigo-200 text-sm mt-1">Employee Portal</p>
    </div>
    <div class="w-14 h-14 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center text-white text-2xl font-black shadow-inner">
        <%= user.getUsername().charAt(0) %>
    </div>
</div>

<!-- ─── Stats Grid ─── -->
<div class="grid grid-cols-2 lg:grid-cols-4 gap-5 mb-7">
    <div class="card p-5 hover:border-green-200 transition-all">
        <div class="w-9 h-9 bg-gradient-to-br from-green-400 to-green-600 rounded-lg flex items-center justify-center mb-3 shadow-sm">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("presentDays") != null ? request.getAttribute("presentDays") : "0" %></p>
        <p class="text-xs text-gray-400 mt-0.5 font-medium">Days Present</p>
    </div>
    <div class="card p-5 hover:border-amber-200 transition-all">
        <div class="w-9 h-9 bg-gradient-to-br from-amber-400 to-orange-500 rounded-lg flex items-center justify-center mb-3 shadow-sm">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("leaveBalance") != null ? request.getAttribute("leaveBalance") : "0" %></p>
        <p class="text-xs text-gray-400 mt-0.5 font-medium">Leave Balance</p>
    </div>
    <div class="card p-5 hover:border-indigo-200 transition-all">
        <div class="w-9 h-9 bg-gradient-to-br from-indigo-400 to-indigo-600 rounded-lg flex items-center justify-center mb-3 shadow-sm">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("monthlySalary") != null ? "₹" + request.getAttribute("monthlySalary") : "—" %></p>
        <p class="text-xs text-gray-400 mt-0.5 font-medium">Monthly Salary</p>
    </div>
    <div class="card p-5 hover:border-sky-200 transition-all">
        <div class="w-9 h-9 bg-gradient-to-br from-sky-400 to-cyan-600 rounded-lg flex items-center justify-center mb-3 shadow-sm">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("attendancePct") != null ? request.getAttribute("attendancePct") + "%" : "—" %></p>
        <p class="text-xs text-gray-400 mt-0.5 font-medium">Attendance %</p>
    </div>
</div>

<!-- ─── Quick Actions ─── -->
<div class="mb-7">
    <div class="section-header">
        <h3 class="section-title">Quick Actions</h3>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
        <a href="<%= request.getContextPath() %>/attendance?action=my" class="card p-6 flex flex-col items-center gap-3 text-center hover:border-green-300 hover:shadow-md transition-all group no-underline">
            <div class="w-12 h-12 bg-gradient-to-br from-green-400 to-green-600 rounded-xl flex items-center justify-center shadow-sm group-hover:shadow-md transition-shadow">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-gray-900">My Attendance</h4>
                <p class="text-xs text-gray-400 mt-1">View your attendance record</p>
            </div>
        </a>
        <a href="<%= request.getContextPath() %>/leave?action=apply" class="card p-6 flex flex-col items-center gap-3 text-center hover:border-amber-300 hover:shadow-md transition-all group no-underline">
            <div class="w-12 h-12 bg-gradient-to-br from-amber-400 to-orange-500 rounded-xl flex items-center justify-center shadow-sm group-hover:shadow-md transition-shadow">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-gray-900">Apply Leave</h4>
                <p class="text-xs text-gray-400 mt-1">Request time off</p>
            </div>
        </a>
        <a href="<%= request.getContextPath() %>/payroll?action=my" class="card p-6 flex flex-col items-center gap-3 text-center hover:border-indigo-300 hover:shadow-md transition-all group no-underline">
            <div class="w-12 h-12 bg-gradient-to-br from-indigo-400 to-purple-600 rounded-xl flex items-center justify-center shadow-sm group-hover:shadow-md transition-shadow">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
            </div>
            <div>
                <h4 class="text-sm font-semibold text-gray-900">View Payslip</h4>
                <p class="text-xs text-gray-400 mt-1">Download salary slip</p>
            </div>
        </a>
    </div>
</div>

<!-- ─── Recent Section ─── -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Recent Leaves -->
    <div class="card">
        <div class="section-header px-5 pt-4 pb-0">
            <h3 class="section-title">Recent Leaves</h3>
            <a href="<%= request.getContextPath() %>/leave?action=my" class="text-xs font-medium text-indigo-600 hover:text-indigo-800 no-underline">View All →</a>
        </div>
        <div class="p-5">
            <div class="flex flex-col items-center gap-2 py-8 text-center">
                <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                <p class="text-sm text-gray-400">No recent leaves</p>
                <a href="<%= request.getContextPath() %>/leave?action=apply" class="text-xs text-indigo-600 font-medium hover:underline">Apply for leave →</a>
            </div>
        </div>
    </div>

    <!-- Recent Tickets -->
    <div class="card">
        <div class="section-header px-5 pt-4 pb-0">
            <h3 class="section-title">Support Tickets</h3>
            <a href="<%= request.getContextPath() %>/support?action=my" class="text-xs font-medium text-indigo-600 hover:text-indigo-800 no-underline">View All →</a>
        </div>
        <div class="p-5">
            <div class="flex flex-col items-center gap-2 py-8 text-center">
                <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>
                <p class="text-sm text-gray-400">No open tickets</p>
                <a href="<%= request.getContextPath() %>/support?action=raise" class="text-xs text-indigo-600 font-medium hover:underline">Raise a ticket →</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>