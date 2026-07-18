<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.LeaveDTO, java.util.List, java.util.concurrent.TimeUnit" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<LeaveDTO> leaves = (List<LeaveDTO>) request.getAttribute("leaves");

    int pending = 0, approved = 0, rejected = 0;
    if (leaves != null) {
        for (LeaveDTO lv : leaves) {
            if ("PENDING".equals(lv.getLeaveStatus()))  pending++;
            else if ("APPROVED".equals(lv.getLeaveStatus())) approved++;
            else if ("REJECTED".equals(lv.getLeaveStatus())) rejected++;
        }
    }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='My Leaves';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / My Leaves';</script>

<div class="flex items-center justify-between mb-6">
    <div class="grid grid-cols-3 gap-4">
        <div class="card px-5 py-3 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <p class="text-lg font-bold text-amber-500"><%= pending %></p>
            <p class="text-xs text-gray-400">Pending</p>
        </div>
        <div class="card px-5 py-3 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <p class="text-lg font-bold text-green-600"><%= approved %></p>
            <p class="text-xs text-gray-400">Approved</p>
        </div>
        <div class="card px-5 py-3 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <p class="text-lg font-bold text-red-500"><%= rejected %></p>
            <p class="text-xs text-gray-400">Rejected</p>
        </div>
    </div>
    <a href="<%= request.getContextPath() %>/leave/apply" class="btn-primary no-underline">+ Apply Leave</a>
</div>

<div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div class="overflow-x-auto">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Type</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Days</th>
                    <th>Reason</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if (leaves != null && !leaves.isEmpty()) {
                    for (LeaveDTO lv : leaves) {
                        long days = 1;
                        if (lv.getFromDate() != null && lv.getToDate() != null) {
                            long diffMs = lv.getToDate().getTime() - lv.getFromDate().getTime();
                            days = TimeUnit.DAYS.convert(diffMs, TimeUnit.MILLISECONDS) + 1;
                        }
                        String statusCss = "APPROVED".equals(lv.getLeaveStatus()) ? "badge-green"
                                         : "REJECTED".equals(lv.getLeaveStatus()) ? "badge-red"
                                         : "badge-yellow";
                %>
                <tr>
                    <td><span class="badge badge-blue"><%= lv.getLeaveType() != null ? lv.getLeaveType() : "—" %></span></td>
                    <td class="text-gray-500"><%= lv.getFromDate() != null ? lv.getFromDate() : "—" %></td>
                    <td class="text-gray-500"><%= lv.getToDate() != null ? lv.getToDate() : "—" %></td>
                    <td class="text-center text-gray-500"><%= days %></td>
                    <td class="text-gray-500" style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%= lv.getReason() != null ? lv.getReason() : "—" %></td>
                    <td><span class="badge <%= statusCss %>"><%= lv.getLeaveStatus() != null ? lv.getLeaveStatus() : "PENDING" %></span></td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" class="py-16 text-center">
                        <div class="flex flex-col items-center gap-2">
                            <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                            <p class="text-sm text-gray-400">You haven't applied for any leaves yet.</p>
                            <a href="<%= request.getContextPath() %>/leave/apply" class="text-sm text-indigo-600 font-medium hover:underline">Apply for leave →</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>