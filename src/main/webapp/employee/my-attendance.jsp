<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.AttendanceDTO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<AttendanceDTO> records = (List<AttendanceDTO>) request.getAttribute("attendanceList");

    // Compute stats
    int present = 0, absent = 0, halfDay = 0;
    if (records != null) {
        for (AttendanceDTO r : records) {
            if ("PRESENT".equals(r.getAttendanceStatus()))   present++;
            else if ("ABSENT".equals(r.getAttendanceStatus()))    absent++;
            else if ("HALF_DAY".equals(r.getAttendanceStatus())) halfDay++;
        }
    }
    int total = (records != null) ? records.size() : 0;
    int pct = total > 0 ? (present * 100 / total) : 0;
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='My Attendance';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Attendance';</script>

<!-- Summary Stats -->
<div class="grid grid-cols-4 gap-5 mb-7">
    <div class="card p-5 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-2xl font-bold text-green-600"><%= present %></p>
        <p class="text-xs text-gray-400 mt-1">Present</p>
    </div>
    <div class="card p-5 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-2xl font-bold text-red-500"><%= absent %></p>
        <p class="text-xs text-gray-400 mt-1">Absent</p>
    </div>
    <div class="card p-5 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-2xl font-bold text-amber-500"><%= halfDay %></p>
        <p class="text-xs text-gray-400 mt-1">Half Day</p>
    </div>
    <div class="card p-5 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-2xl font-bold text-indigo-600"><%= pct %>%</p>
        <p class="text-xs text-gray-400 mt-1">Attendance Rate</p>
    </div>
</div>

<!-- Filter -->
<div class="flex gap-3 mb-5">
    <a href="<%= request.getContextPath() %>/attendance/my" class="btn-primary no-underline">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
        Refresh
    </a>
</div>

<!-- Table -->
<div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div class="overflow-x-auto">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Day</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Working Hours</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if (records != null && !records.isEmpty()) {
                    for (AttendanceDTO r : records) {
                        String statusCss = "PRESENT".equals(r.getAttendanceStatus()) ? "badge-green"
                                         : "ABSENT".equals(r.getAttendanceStatus()) ? "badge-red"
                                         : "HALF_DAY".equals(r.getAttendanceStatus()) ? "badge-yellow"
                                         : "badge-blue";
                        String dayName = "—";
                        if (r.getAttendanceDate() != null) {
                            java.util.Calendar cal = java.util.Calendar.getInstance();
                            cal.setTime(r.getAttendanceDate());
                            String[] dayNames = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
                            dayName = dayNames[cal.get(java.util.Calendar.DAY_OF_WEEK)-1];
                        }
                %>
                <tr>
                    <td class="font-medium text-gray-900"><%= r.getAttendanceDate() != null ? r.getAttendanceDate() : "—" %></td>
                    <td class="text-gray-500"><%= dayName %></td>
                    <td class="text-gray-500"><%= r.getCheckIn() != null ? r.getCheckIn() : "—" %></td>
                    <td class="text-gray-500"><%= r.getCheckOut() != null ? r.getCheckOut() : "—" %></td>
                    <td class="text-gray-500"><%= r.getWorkingHours() > 0 ? String.format("%.1f h", r.getWorkingHours()) : "—" %></td>
                    <td><span class="badge <%= statusCss %>"><%= r.getAttendanceStatus() != null ? r.getAttendanceStatus() : "—" %></span></td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" class="py-16 text-center">
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

<%@ include file="../includes/footer.jsp" %>