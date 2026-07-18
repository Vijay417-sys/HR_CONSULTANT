<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='My Dashboard';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Dashboard';</script>

<!-- Welcome Banner -->
<div class="rounded-xl p-6 mb-7 flex items-center justify-between" style="background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;">
    <div>
        <p class="text-indigo-200 text-sm mb-1">Welcome back 👋</p>
        <h2 class="text-2xl font-bold"><%= user.getUsername() %></h2>
        <p class="text-indigo-200 text-sm mt-1">Employee Portal</p>
    </div>
    <div class="w-14 h-14 bg-white/20 rounded-2xl flex items-center justify-center text-white text-2xl font-black">
        <%= user.getUsername().charAt(0) %>
    </div>
</div>

<!-- Stats -->
<div class="grid grid-cols-2 lg:grid-cols-4 gap-5 mb-7">
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-9 h-9 bg-green-50 rounded-lg flex items-center justify-center mb-3">
            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("presentDays") != null ? request.getAttribute("presentDays") : "—" %></p>
        <p class="text-xs text-gray-400 mt-0.5">Days Present</p>
    </div>
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-9 h-9 bg-amber-50 rounded-lg flex items-center justify-center mb-3">
            <svg class="w-5 h-5 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("leaveBalance") != null ? request.getAttribute("leaveBalance") : "—" %></p>
        <p class="text-xs text-gray-400 mt-0.5">Leave Balance</p>
    </div>
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-9 h-9 bg-indigo-50 rounded-lg flex items-center justify-center mb-3">
            <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900">—</p>
        <p class="text-xs text-gray-400 mt-0.5">Monthly Salary</p>
    </div>
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-9 h-9 bg-sky-50 rounded-lg flex items-center justify-center mb-3">
            <svg class="w-5 h-5 text-sky-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("attendancePct") != null ? request.getAttribute("attendancePct") + "%" : "—" %></p>
        <p class="text-xs text-gray-400 mt-0.5">Attendance %</p>
    </div>
</div>

<!-- Quick Actions -->
<h3 class="text-sm font-semibold text-gray-900 mb-4">Quick Actions</h3>
<div class="grid grid-cols-1 md:grid-cols-3 gap-5">
    <a href="<%= request.getContextPath() %>/attendance/my" class="card p-6 flex flex-col items-center gap-3 text-center hover:border-green-300 transition-all group no-underline" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-12 h-12 bg-green-50 group-hover:bg-green-100 rounded-xl flex items-center justify-center transition-colors">
            <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/></svg>
        </div>
        <div>
            <h4 class="text-sm font-semibold text-gray-900">My Attendance</h4>
            <p class="text-xs text-gray-400 mt-0.5">View your attendance record</p>
        </div>
    </a>
    <a href="<%= request.getContextPath() %>/leave/apply" class="card p-6 flex flex-col items-center gap-3 text-center hover:border-amber-300 transition-all group no-underline" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-12 h-12 bg-amber-50 group-hover:bg-amber-100 rounded-xl flex items-center justify-center transition-colors">
            <svg class="w-6 h-6 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
        </div>
        <div>
            <h4 class="text-sm font-semibold text-gray-900">Apply Leave</h4>
            <p class="text-xs text-gray-400 mt-0.5">Request time off</p>
        </div>
    </a>
    <a href="<%= request.getContextPath() %>/payroll/my" class="card p-6 flex flex-col items-center gap-3 text-center hover:border-indigo-300 transition-all group no-underline" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-12 h-12 bg-indigo-50 group-hover:bg-indigo-100 rounded-xl flex items-center justify-center transition-colors">
            <svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
        </div>
        <div>
            <h4 class="text-sm font-semibold text-gray-900">View Payslip</h4>
            <p class="text-xs text-gray-400 mt-0.5">Download salary slip</p>
        </div>
    </a>
</div>

<%@ include file="../includes/footer.jsp" %>