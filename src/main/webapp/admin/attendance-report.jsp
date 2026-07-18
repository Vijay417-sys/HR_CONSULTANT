<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.AttendanceDTO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<AttendanceDTO> records = (List<AttendanceDTO>) request.getAttribute("attendanceList");

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
        <a href="<%= request.getContextPath() %>/attendance/list" class="btn-primary no-underline">
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
                    <th>Emp ID</th>
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
                    <td class="font-medium text-gray-900">Emp #<%= r.getEmployeeId() %></td>
                    <td class="text-gray-500"><%= r.getAttendanceDate() != null ? r.getAttendanceDate() : "—" %></td>
                    <td class="text-gray-500"><%= r.getCheckIn() != null ? r.getCheckIn() : "—" %></td>
                    <td class="text-gray-500"><%= r.getCheckOut() != null ? r.getCheckOut() : "—" %></td>
                    <td class="text-gray-500"><%= r.getWorkingHours() > 0 ? String.format("%.1f h", r.getWorkingHours()) : "—" %></td>
                    <td><span class="badge <%= statusCss %>"><%= r.getAttendanceStatus() != null ? r.getAttendanceStatus() : "—" %></span></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/attendance/delete?id=<%= r.getAttendanceId() %>" class="text-xs text-red-500 hover:text-red-700 font-medium no-underline" onclick="return confirm('Delete this record?')">Delete</a>
                    </td>
                </tr>
                <% } } else { %>
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
    const rows = document.querySelectorAll('#att-table tbody tr');
    rows.forEach(r => { r.style.display = (!s || r.textContent.includes(s)) ? '' : 'none'; });
}
</script>

<%@ include file="../includes/footer.jsp" %>