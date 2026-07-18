<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Apply Leave';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Apply Leave';</script>

<div class="max-w-xl">
    <!-- Balance Summary (static — can be made dynamic later) -->
    <div class="grid grid-cols-3 gap-4 mb-7">
        <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <p class="text-xl font-bold text-green-600">12</p>
            <p class="text-xs text-gray-400 mt-0.5">Casual Leaves</p>
        </div>
        <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <p class="text-xl font-bold text-indigo-600">5</p>
            <p class="text-xs text-gray-400 mt-0.5">Sick Leaves</p>
        </div>
        <div class="card p-4 text-center" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <p class="text-xl font-bold text-amber-500">2</p>
            <p class="text-xs text-gray-400 mt-0.5">Earned Leaves</p>
        </div>
    </div>

    <div class="card p-6" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <h3 class="text-sm font-semibold text-gray-900 mb-5">Leave Application Form</h3>
        <% if (successMsg != null) { %>
        <div class="flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-5 text-sm">
            <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <%= successMsg %>
        </div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-5 text-sm">
            <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <%= errorMsg %>
        </div>
        <% } %>
        <form action="<%= request.getContextPath() %>/leave/apply" method="post" class="space-y-5">
            <div>
                <label class="input-label" for="leaveType">Leave Type *</label>
                <select id="leaveType" name="leaveType" class="input-field" required>
                    <option value="">Select leave type</option>
                    <option value="CASUAL">Casual Leave</option>
                    <option value="SICK">Sick Leave</option>
                    <option value="EARNED">Earned Leave</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>
            <div class="form-grid">
                <div>
                    <label class="input-label" for="fromDate">From Date *</label>
                    <input type="date" id="fromDate" name="fromDate" class="input-field" required onchange="calcDays()">
                </div>
                <div>
                    <label class="input-label" for="toDate">To Date *</label>
                    <input type="date" id="toDate" name="toDate" class="input-field" required onchange="calcDays()">
                </div>
            </div>
            <div class="bg-indigo-50 border border-indigo-100 rounded-lg px-4 py-3 flex items-center justify-between">
                <span class="text-sm text-gray-600 font-medium">Total Days</span>
                <span class="text-lg font-bold text-indigo-600" id="total-days">0 days</span>
            </div>
            <div>
                <label class="input-label" for="reason">Reason *</label>
                <textarea id="reason" name="reason" rows="3" class="input-field" placeholder="Briefly explain the reason for your leave..." required style="resize:vertical;"></textarea>
            </div>
            <div class="flex gap-3 pt-1">
                <button type="submit" class="btn-primary">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/></svg>
                    Submit Application
                </button>
                <a href="<%= request.getContextPath() %>/leave/my" class="btn-secondary no-underline">View History</a>
            </div>
        </form>
    </div>
</div>

<script>
function calcDays() {
    const s = document.getElementById('fromDate').value;
    const e = document.getElementById('toDate').value;
    if (s && e) {
        const diff = (new Date(e) - new Date(s)) / (1000*60*60*24) + 1;
        document.getElementById('total-days').textContent = Math.max(0, diff) + ' day' + (diff !== 1 ? 's' : '');
    }
}
</script>

<%@ include file="../includes/footer.jsp" %>