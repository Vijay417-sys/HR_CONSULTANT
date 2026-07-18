<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.LeaveDTO, java.util.List, java.util.concurrent.TimeUnit" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<LeaveDTO> leaves = (List<LeaveDTO>) request.getAttribute("leaves");

    // Compute stats
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
<script>document.getElementById('page-title').textContent='Leave Requests';document.getElementById('page-breadcrumb').textContent='HRDesk / Admin / Leave Requests';</script>

<!-- Summary Cards -->
<div class="grid grid-cols-3 gap-5 mb-6">
    <div class="card p-5 flex items-center gap-4" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-10 h-10 bg-amber-50 rounded-lg flex items-center justify-center">
            <svg class="w-5 h-5 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <div>
            <p class="text-xl font-bold text-gray-900"><%= pending %></p>
            <p class="text-xs text-gray-400">Pending</p>
        </div>
    </div>
    <div class="card p-5 flex items-center gap-4" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-10 h-10 bg-green-50 rounded-lg flex items-center justify-center">
            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <div>
            <p class="text-xl font-bold text-gray-900"><%= approved %></p>
            <p class="text-xs text-gray-400">Approved</p>
        </div>
    </div>
    <div class="card p-5 flex items-center gap-4" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <div class="w-10 h-10 bg-red-50 rounded-lg flex items-center justify-center">
            <svg class="w-5 h-5 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
        </div>
        <div>
            <p class="text-xl font-bold text-gray-900"><%= rejected %></p>
            <p class="text-xs text-gray-400">Rejected</p>
        </div>
    </div>
</div>

<!-- Table -->
<div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
        <h3 class="text-sm font-semibold text-gray-900">All Leave Requests</h3>
        <select class="input-field" style="width:140px;" onchange="filterStatus(this.value)">
            <option value="">All Status</option>
            <option value="PENDING">Pending</option>
            <option value="APPROVED">Approved</option>
            <option value="REJECTED">Rejected</option>
        </select>
    </div>
    <div class="overflow-x-auto">
        <table class="data-table" id="leave-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Emp ID</th>
                    <th>Leave Type</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Days</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (leaves != null && !leaves.isEmpty()) {
                    int sn = 1;
                    for (LeaveDTO lv : leaves) {
                        // Calculate days
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
                    <td class="text-gray-400 text-xs"><%= sn++ %></td>
                    <td class="font-medium text-gray-900">Emp #<%= lv.getEmployeeId() %></td>
                    <td><span class="badge badge-blue"><%= lv.getLeaveType() != null ? lv.getLeaveType() : "—" %></span></td>
                    <td class="text-gray-500"><%= lv.getFromDate() != null ? lv.getFromDate() : "—" %></td>
                    <td class="text-gray-500"><%= lv.getToDate() != null ? lv.getToDate() : "—" %></td>
                    <td class="text-gray-500 text-center"><%= days %></td>
                    <td class="text-gray-500" style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<%= lv.getReason() != null ? lv.getReason() : "" %>"><%= lv.getReason() != null ? lv.getReason() : "—" %></td>
                    <td>
                        <span class="badge <%= statusCss %>"><%= lv.getLeaveStatus() != null ? lv.getLeaveStatus() : "PENDING" %></span>
                    </td>
                    <td>
                        <% if ("PENDING".equals(lv.getLeaveStatus()) || lv.getLeaveStatus() == null) { %>
                        <div class="flex gap-1.5">
                            <a href="<%= request.getContextPath() %>/leave/approve?id=<%= lv.getLeaveId() %>" class="btn-success no-underline" style="padding:.25rem .625rem;font-size:.75rem;" onclick="return confirm('Approve this leave?')">Approve</a>
                            <a href="<%= request.getContextPath() %>/leave/reject?id=<%= lv.getLeaveId() %>" class="btn-danger no-underline" style="padding:.25rem .625rem;font-size:.75rem;" onclick="return confirm('Reject this leave?')">Reject</a>
                        </div>
                        <% } else { %>
                        <span class="text-xs text-gray-400">—</span>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="9" class="py-16 text-center">
                        <div class="flex flex-col items-center gap-2">
                            <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                            <p class="text-sm text-gray-400">No leave requests found.</p>
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
    const rows = document.querySelectorAll('#leave-table tbody tr');
    rows.forEach(r => { r.style.display = (!s || r.textContent.includes(s)) ? '' : 'none'; });
}
</script>

<%@ include file="../includes/footer.jsp" %>