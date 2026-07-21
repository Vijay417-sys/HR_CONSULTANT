<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.EmployeeDTO, com.hrdesk.dto.AttendanceDTO, java.util.List, java.util.Map, java.util.HashMap" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<AttendanceDTO> records = (List<AttendanceDTO>) request.getAttribute("attendanceList");
    List<EmployeeDTO> employees = (List<EmployeeDTO>) request.getAttribute("employeeList");

    // Build employee name map
    Map<Integer, String> empNameMap = new HashMap<>();
    if (employees != null) {
        for (EmployeeDTO emp : employees) {
            String name = (emp.getFirstName() != null ? emp.getFirstName() : "") + " " + (emp.getLastName() != null ? emp.getLastName() : "");
            name = name.trim();
            empNameMap.put(emp.getEmployeeId(), name.isEmpty() ? "Unknown" : name);
        }
    }

    // Flash messages
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");

    // Compute stats
    int present = 0, absent = 0, halfDay = 0, leave = 0;
    if (records != null) {
        for (AttendanceDTO r : records) {
            String s = r.getAttendanceStatus();
            if ("PRESENT".equals(s))   present++;
            else if ("ABSENT".equals(s))    absent++;
            else if ("HALF_DAY".equals(s))  halfDay++;
            else if ("LEAVE".equals(s))     leave++;
        }
    }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Attendance Report';document.getElementById('page-breadcrumb').textContent='HRDesk / Admin / Attendance';</script>

<!-- Flash Messages -->
<% if (successMsg != null) { %>
<div class="flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-6 text-sm">
    <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <%= successMsg %>
</div>
<% } %>
<% if (errorMsg != null) { %>
<div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-6 text-sm">
    <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <%= errorMsg %>
</div>
<% } %>

<!-- Mark Attendance Form -->
<div class="card p-5 mb-6" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <h3 class="text-sm font-semibold text-gray-900 mb-4">Mark Attendance</h3>
    <form action="<%= request.getContextPath() %>/attendance?action=mark" method="post" class="flex flex-wrap items-end gap-4">
        <div>
            <label class="input-label" for="empId">Employee *</label>
            <select id="empId" name="empId" class="input-field" style="width:200px;" required>
                <option value="">Select Employee</option>
                <% if (employees != null) {
                    for (EmployeeDTO emp : employees) {
                        String name = (emp.getFirstName() != null ? emp.getFirstName() : "") + " " + (emp.getLastName() != null ? emp.getLastName() : "");
                        name = name.trim(); if (name.isEmpty()) name = "Unknown";
                %>
                <option value="<%= emp.getEmployeeId() %>"><%= name %> (ID: <%= emp.getEmployeeId() %>)</option>
                <% } } %>
            </select>
        </div>
        <div>
            <label class="input-label" for="date">Date *</label>
            <input type="date" id="date" name="date" class="input-field" style="width:160px;"
                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
        </div>
        <div>
            <label class="input-label" for="status">Status *</label>
            <select id="status" name="status" class="input-field" style="width:130px;" required>
                <option value="PRESENT">Present</option>
                <option value="ABSENT">Absent</option>
                <option value="HALF_DAY">Half Day</option>
                <option value="LEAVE">Leave</option>
            </select>
        </div>
        <div>
            <label class="input-label" for="checkIn">Check In</label>
            <input type="time" id="checkIn" name="checkIn" class="input-field" style="width:140px;">
        </div>
        <div>
            <label class="input-label" for="checkOut">Check Out</label>
            <input type="time" id="checkOut" name="checkOut" class="input-field" style="width:140px;">
        </div>
        <div>
            <button type="submit" class="btn-primary">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
                Mark Attendance
            </button>
        </div>
    </form>
</div>

<!-- Filters -->
<div class="card p-4 mb-6 flex flex-wrap gap-3 items-end" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div>
        <label class="input-label" for="filter-date">Date</label>
        <input type="date" id="filter-date" class="input-field" style="width:160px;" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
    </div>
    <div>
        <label class="input-label" for="filter-status">Status</label>
        <select id="filter-status" class="input-field" style="width:140px;" onchange="filterStatus(this.value)">
            <option value="">All Status</option>
            <option value="PRESENT">Present</option>
            <option value="ABSENT">Absent</option>
            <option value="HALF_DAY">Half Day</option>
            <option value="LEAVE">Leave</option>
        </select>
    </div>
    <div class="flex gap-2">
        <a href="<%= request.getContextPath() %>/attendance?action=list" class="btn-primary no-underline">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
            Refresh
        </a>
    </div>
</div>

<!-- Summary Counts -->
<div class="grid grid-cols-4 gap-4 mb-6">
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-green-600"><%= present %></p>
        <p class="text-xs text-gray-400 mt-1">Present</p>
    </div>
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-red-500"><%= absent %></p>
        <p class="text-xs text-gray-400 mt-1">Absent</p>
    </div>
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-amber-500"><%= halfDay %></p>
        <p class="text-xs text-gray-400 mt-1">Half Day</p>
    </div>
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-indigo-600"><%= leave %></p>
        <p class="text-xs text-gray-400 mt-1">On Leave</p>
    </div>
</div>

<!-- Table -->
<div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div class="overflow-x-auto">
        <table class="data-table" id="att-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Employee</th>
                    <th>Date</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Hours</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (records != null && !records.isEmpty()) {
                    int sn = 1;
                    for (AttendanceDTO r : records) {
                        String statusCss = "PRESENT".equals(r.getAttendanceStatus()) ? "badge-green"
                                         : "ABSENT".equals(r.getAttendanceStatus()) ? "badge-red"
                                         : "HALF_DAY".equals(r.getAttendanceStatus()) ? "badge-yellow"
                                         : "badge-gray";
                %>
                <tr>
                    <td class="text-gray-400 text-xs"><%= sn++ %></td>
                    <td class="font-medium text-gray-900"><%= empNameMap.getOrDefault(r.getEmployeeId(), "Emp #" + r.getEmployeeId()) %></td>
                    <td class="text-gray-500"><%= r.getAttendanceDate() != null ? r.getAttendanceDate() : "—" %></td>
                    <td class="text-gray-500"><%= r.getCheckIn() != null ? r.getCheckIn() : "—" %></td>
                    <td class="text-gray-500"><%= r.getCheckOut() != null ? r.getCheckOut() : "—" %></td>
                    <td class="text-gray-500"><%= r.getWorkingHours() > 0 ? String.format("%.1f h", r.getWorkingHours()) : "—" %></td>
                    <td><span class="badge <%= statusCss %>"><%= r.getAttendanceStatus() != null ? r.getAttendanceStatus() : "—" %></span></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/attendance?action=delete&id=<%= r.getAttendanceId() %>" class="text-xs text-red-500 hover:text-red-700 font-medium no-underline" onclick="return confirm('Delete this record?')">Delete</a>
                    </td>
                </tr>
                <% }
                    // Always add a hidden "no match" row for filter
                %>
                <tr id="no-match-msg" style="display:none;">
                    <td colspan="8" class="py-16 text-center">
                        <div class="flex flex-col items-center gap-2">
                            <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                            <p class="text-sm text-gray-400">No attendance records match the selected filter.</p>
                        </div>
                    </td>
                </tr>
                <% } else { %>
                <tr>
                    <td colspan="8" class="py-16 text-center">
                        <div class="flex flex-col items-center gap-2">
                            <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                            <p class="text-sm text-gray-400">No attendance records found.</p>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
function filterStatus(s) {
    var rows = document.querySelectorAll('#att-table tbody tr:not(#no-match-msg)');
    var visible = 0;
    rows.forEach(function(r) {
        var match = !s || r.textContent.toUpperCase().includes(s);
        r.style.display = match ? '' : 'none';
        if (match) visible++;
    });
    var msg = document.getElementById('no-match-msg');
    if (msg) {
        msg.style.display = (visible === 0 && rows.length > 0) ? '' : 'none';
    }
}
</script>

<%@ include file="../includes/footer.jsp" %>