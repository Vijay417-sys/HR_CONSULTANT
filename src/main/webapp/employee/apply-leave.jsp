<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    request.setAttribute("navPage", "leave");

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Apply Leave';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Apply Leave';</script>

<div class="max-w-xl">
    <!-- Balance Summary -->
    <div class="grid grid-cols-3 gap-4 mb-7">
        <div class="card p-4 text-center hover:border-green-200 transition-all">
            <p class="text-xl font-bold text-green-600">12</p>
            <p class="text-xs text-gray-400 mt-0.5 font-medium">Casual Leaves</p>
        </div>
        <div class="card p-4 text-center hover:border-indigo-200 transition-all">
            <p class="text-xl font-bold text-indigo-600">5</p>
            <p class="text-xs text-gray-400 mt-0.5 font-medium">Sick Leaves</p>
        </div>
        <div class="card p-4 text-center hover:border-amber-200 transition-all">
            <p class="text-xl font-bold text-amber-500">2</p>
            <p class="text-xs text-gray-400 mt-0.5 font-medium">Earned Leaves</p>
        </div>
    </div>

    <div class="card p-6">
        <div class="flex items-center gap-3 mb-5">
            <div class="w-9 h-9 bg-indigo-50 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            </div>
            <div>
                <h3 class="text-sm font-semibold text-gray-900">Leave Application Form</h3>
                <p class="text-xs text-gray-400">Submit a leave request</p>
            </div>
        </div>

        <%
    // Calculate today's date for HTML min attribute
    java.text.SimpleDateFormat ymd = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String todayStr = ymd.format(new java.util.Date());
%>
    <% if (successMsg != null) { %>
        <div class="alert alert-success mb-5"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-danger mb-5"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= errorMsg %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/leave?action=apply" method="post" class="space-y-5">
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
                    <input type="date" id="fromDate" name="fromDate" class="input-field" required
                           min="<%= todayStr %>" onchange="validateWeekend(this); calcDays();">
                </div>
                <div>
                    <label class="input-label" for="toDate">To Date *</label>
                    <input type="date" id="toDate" name="toDate" class="input-field" required
                           min="<%= todayStr %>" onchange="validateWeekend(this); calcDays();">
                </div>
            </div>
            <div class="bg-indigo-50 border border-indigo-100 rounded-lg px-4 py-3 flex items-center justify-between">
                <span class="text-sm text-gray-600 font-medium">Total Working Days</span>
                <span class="text-lg font-bold text-indigo-600" id="total-days">0 days</span>
            </div>
            <div>
                <label class="input-label" for="reason">Reason *</label>
                <textarea id="reason" name="reason" rows="3" class="input-field" placeholder="Briefly explain the reason for your leave..." required></textarea>
            </div>
            <div class="flex gap-3 pt-1">
                <button type="submit" class="btn-primary">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/></svg>
                    Submit Application
                </button>
                <a href="<%= request.getContextPath() %>/leave?action=my" class="btn-secondary no-underline">View History</a>
            </div>
        </form>
    </div>
</div>

<script>
function validateWeekend(input) {
    if (!input.value) return;
    var d = new Date(input.value + 'T00:00:00');
    if (d.getDay() === 0 || d.getDay() === 6) {
        alert('Weekends (Saturday & Sunday) are not counted as working days. Please select a weekday.');
        input.value = '';
        calcDays();
    }
}

function calcDays() {
    var s = document.getElementById('fromDate').value;
    var e = document.getElementById('toDate').value;
    if (s && e) {
        var start = new Date(s + 'T00:00:00');
        var end = new Date(e + 'T00:00:00');
        if (start > end) {
            document.getElementById('total-days').textContent = '0 days';
            return;
        }
        var count = 0;
        var cur = new Date(start);
        while (cur <= end) {
            var d = cur.getDay();
            if (d !== 0 && d !== 6) count++; // skip Sunday(0) and Saturday(6)
            cur.setDate(cur.getDate() + 1);
        }
        document.getElementById('total-days').textContent = count + ' day' + (count !== 1 ? 's' : '');
    }
}
</script>

<%@ include file="../includes/footer.jsp" %>