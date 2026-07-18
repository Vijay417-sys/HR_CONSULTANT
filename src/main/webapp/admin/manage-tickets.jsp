<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.SupportTokenDTO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<SupportTokenDTO> tokens = (List<SupportTokenDTO>) request.getAttribute("tokens");

    // Stats
    int open = 0, inProgress = 0, resolved = 0, closed = 0;
    if (tokens != null) {
        for (SupportTokenDTO t : tokens) {
            if ("OPEN".equals(t.getStatus()))        open++;
            else if ("IN_PROGRESS".equals(t.getStatus())) inProgress++;
            else if ("RESOLVED".equals(t.getStatus()))    resolved++;
            else if ("CLOSED".equals(t.getStatus()))      closed++;
        }
    }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Support Tickets';document.getElementById('page-breadcrumb').textContent='HRDesk / Admin / Tickets';</script>

<!-- Summary -->
<div class="grid grid-cols-4 gap-4 mb-6">
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-amber-500"><%= open %></p>
        <p class="text-xs text-gray-400 mt-1">Open</p>
    </div>
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-indigo-600"><%= inProgress %></p>
        <p class="text-xs text-gray-400 mt-1">In Progress</p>
    </div>
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-green-600"><%= resolved %></p>
        <p class="text-xs text-gray-400 mt-1">Resolved</p>
    </div>
    <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <p class="text-xl font-bold text-gray-500"><%= closed %></p>
        <p class="text-xs text-gray-400 mt-1">Closed</p>
    </div>
</div>

<!-- Table -->
<div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
    <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
        <h3 class="text-sm font-semibold text-gray-900">All Support Tickets</h3>
        <select class="input-field" style="width:140px;" onchange="filterStatus(this.value)">
            <option value="">All Status</option>
            <option value="OPEN">Open</option>
            <option value="IN_PROGRESS">In Progress</option>
            <option value="RESOLVED">Resolved</option>
            <option value="CLOSED">Closed</option>
        </select>
    </div>
    <div class="overflow-x-auto">
        <table class="data-table" id="ticket-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Emp ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (tokens != null && !tokens.isEmpty()) {
                    int sn = 1;
                    for (SupportTokenDTO t : tokens) {
                        String statusCss = "OPEN".equals(t.getStatus()) ? "badge-yellow"
                                         : "IN_PROGRESS".equals(t.getStatus()) ? "badge-blue"
                                         : "RESOLVED".equals(t.getStatus()) ? "badge-green"
                                         : "badge-gray";
                        String priorityCss = "URGENT".equals(t.getPriority()) ? "badge-red"
                                           : "HIGH".equals(t.getPriority()) ? "badge-yellow"
                                           : "MEDIUM".equals(t.getPriority()) ? "badge-blue"
                                           : "badge-gray";
                %>
                <tr>
                    <td class="text-gray-400 text-xs"><%= sn++ %></td>
                    <td class="font-medium text-gray-900">Emp #<%= t.getEmpId() %></td>
                    <td class="text-gray-900 text-sm" style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<%= t.getTitle() != null ? t.getTitle() : "" %>"><%= t.getTitle() != null ? t.getTitle() : "—" %></td>
                    <td><span class="badge badge-gray"><%= t.getCategory() != null ? t.getCategory() : "—" %></span></td>
                    <td><span class="badge <%= priorityCss %>"><%= t.getPriority() != null ? t.getPriority() : "MEDIUM" %></span></td>
                    <td><span class="badge <%= statusCss %>"><%= t.getStatus() != null ? t.getStatus() : "OPEN" %></span></td>
                    <td class="text-gray-400 text-xs"><%= t.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd-MMM-yy").format(t.getCreatedAt()) : "—" %></td>
                    <td>
                        <div class="flex gap-1.5 flex-wrap">
                            <% if ("OPEN".equals(t.getStatus())) { %>
                            <a href="<%= request.getContextPath() %>/support/inprogress?id=<%= t.getTokenId() %>" class="btn-secondary no-underline" style="padding:.2rem .5rem;font-size:.7rem;">Start</a>
                            <% } %>
                            <% if (!"RESOLVED".equals(t.getStatus()) && !"CLOSED".equals(t.getStatus())) { %>
                            <a href="<%= request.getContextPath() %>/support/resolve?id=<%= t.getTokenId() %>" class="btn-success no-underline" style="padding:.2rem .5rem;font-size:.7rem;" onclick="return confirm('Mark as resolved?')">Resolve</a>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/support/delete?id=<%= t.getTokenId() %>" class="btn-danger no-underline" style="padding:.2rem .5rem;font-size:.7rem;" onclick="return confirm('Delete this ticket?')">Del</a>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="8" class="py-16 text-center">
                        <div class="flex flex-col items-center gap-2">
                            <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>
                            <p class="text-sm text-gray-400">No support tickets found.</p>
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
    const rows = document.querySelectorAll('#ticket-table tbody tr');
    rows.forEach(r => { r.style.display = (!s || r.textContent.includes(s)) ? '' : 'none'; });
}
</script>

<%@ include file="../includes/footer.jsp" %>