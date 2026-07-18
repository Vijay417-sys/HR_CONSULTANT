<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.EmployeeDTO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Admin Dashboard';document.getElementById('page-breadcrumb').textContent='HRDesk / Admin / Dashboard';</script>

<!-- Stats Row -->
<div class="grid grid-cols-2 lg:grid-cols-4 gap-5 mb-7">
    <!-- Stat Card -->
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 rounded-lg bg-indigo-50 flex items-center justify-center">
                <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
            </div>
            <span class="badge badge-blue">+5%</span>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("totalEmployees") != null ? request.getAttribute("totalEmployees") : "—" %></p>
        <p class="text-sm text-gray-400 mt-0.5">Total Employees</p>
    </div>
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 rounded-lg bg-green-50 flex items-center justify-center">
                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            </div>
            <span class="badge badge-green">Today</span>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("presentToday") != null ? request.getAttribute("presentToday") : "—" %></p>
        <p class="text-sm text-gray-400 mt-0.5">Present Today</p>
    </div>
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 rounded-lg bg-amber-50 flex items-center justify-center">
                <svg class="w-5 h-5 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            </div>
            <span class="badge badge-yellow">Pending</span>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("pendingLeaves") != null ? request.getAttribute("pendingLeaves") : "—" %></p>
        <p class="text-sm text-gray-400 mt-0.5">Leave Requests</p>
    </div>
    <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="flex items-center justify-between mb-3">
            <div class="w-10 h-10 rounded-lg bg-purple-50 flex items-center justify-center">
                <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
            </div>
            <span class="badge badge-blue">Active</span>
        </div>
        <p class="text-2xl font-bold text-gray-900"><%= request.getAttribute("totalDepts") != null ? request.getAttribute("totalDepts") : "—" %></p>
        <p class="text-sm text-gray-400 mt-0.5">Departments</p>
    </div>
</div>

<!-- Quick Actions -->
<div class="card p-6 mb-7" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <h3 class="text-sm font-semibold text-gray-900 mb-4">Quick Actions</h3>
    <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
        <a href="<%= request.getContextPath() %>/employees/add" class="flex flex-col items-center gap-2.5 p-4 rounded-xl border border-indigo-100 bg-indigo-50 hover:bg-indigo-100 transition-all text-center group no-underline">
            <div class="w-9 h-9 bg-indigo-600 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
            </div>
            <span class="text-xs font-semibold text-indigo-700">Add Employee</span>
        </a>
        <a href="<%= request.getContextPath() %>/payroll/list" class="flex flex-col items-center gap-2.5 p-4 rounded-xl border border-green-100 bg-green-50 hover:bg-green-100 transition-all text-center no-underline">
            <div class="w-9 h-9 bg-green-600 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            </div>
            <span class="text-xs font-semibold text-green-700">Run Payroll</span>
        </a>
        <a href="<%= request.getContextPath() %>/leave/list" class="flex flex-col items-center gap-2.5 p-4 rounded-xl border border-amber-100 bg-amber-50 hover:bg-amber-100 transition-all text-center no-underline">
            <div class="w-9 h-9 bg-amber-500 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            </div>
            <span class="text-xs font-semibold text-amber-700">Leave Requests</span>
        </a>
        <a href="<%= request.getContextPath() %>/attendance/list" class="flex flex-col items-center gap-2.5 p-4 rounded-xl border border-sky-100 bg-sky-50 hover:bg-sky-100 transition-all text-center no-underline">
            <div class="w-9 h-9 bg-sky-500 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
            </div>
            <span class="text-xs font-semibold text-sky-700">Attendance</span>
        </a>
    </div>
</div>

<!-- Recent Employees -->
<div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
        <h3 class="text-sm font-semibold text-gray-900">Recent Employees</h3>
        <a href="<%= request.getContextPath() %>/employees/list" class="text-xs font-medium text-indigo-600 hover:text-indigo-800 no-underline">View All →</a>
    </div>
    <div class="overflow-x-auto">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Employee</th>
                    <th>Department</th>
                    <th>Hire Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<EmployeeDTO> employees = (List<EmployeeDTO>) request.getAttribute("recentEmployees");
                    if (employees != null && !employees.isEmpty()) {
                        for (EmployeeDTO emp : employees) {
                            String name = (emp.getFirstName() != null ? emp.getFirstName() : "") + " " + (emp.getLastName() != null ? emp.getLastName() : "");
                            name = name.trim(); if (name.isEmpty()) name = "Unknown";
                %>
                <tr>
                    <td>
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 bg-indigo-100 rounded-full flex items-center justify-center text-indigo-700 text-xs font-bold flex-shrink-0">
                                <%= name.charAt(0) %>
                            </div>
                            <div>
                                <p class="text-sm font-medium text-gray-900"><%= name %></p>
                                <p class="text-xs text-gray-400"><%= emp.getEmail() != null ? emp.getEmail() : "" %></p>
                            </div>
                        </div>
                    </td>
                    <td class="text-gray-500"><%= emp.getDepartmentId() %></td>
                    <td class="text-gray-500"><%= emp.getHireDate() != null ? emp.getHireDate() : "N/A" %></td>
                    <td><span class="badge badge-green">Active</span></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/employees/edit?id=<%= emp.getEmployeeId() %>" class="text-xs text-indigo-600 hover:underline font-medium no-underline">Edit</a>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="5" class="py-12 text-center">
                        <div class="flex flex-col items-center gap-2">
                            <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                            <p class="text-sm text-gray-400">No employees added yet.</p>
                            <a href="<%= request.getContextPath() %>/employees/add" class="text-sm text-indigo-600 font-medium hover:underline">Add first employee →</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>