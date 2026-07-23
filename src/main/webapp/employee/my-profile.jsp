<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    request.setAttribute("navPage", "profile");

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='My Profile';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Profile';</script>

<!-- Flash Messages -->
<% if (successMsg != null) { %>
<div class="alert alert-success mb-6"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= successMsg %></div>
<% } %>
<% if (errorMsg != null) { %>
<div class="alert alert-danger mb-6"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= errorMsg %></div>
<% } %>

<div class="max-w-3xl">
    <!-- ═══ Profile Card ═══ -->
    <div class="card overflow-hidden mb-6">
        <!-- Profile Header Gradient -->
        <div class="h-28 bg-gradient-to-r from-indigo-600 via-indigo-500 to-purple-600 relative">
            <div class="absolute -bottom-10 left-8">
                <div class="w-20 h-20 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl border-4 border-white flex items-center justify-center text-white font-black text-3xl shadow-lg">
                    <%= user.getUsername().charAt(0) %>
                </div>
            </div>
        </div>
        <div class="pt-12 px-6 pb-6">
            <div class="flex items-start justify-between mb-6">
                <div>
                    <h2 class="text-xl font-bold text-gray-900"><%= user.getUsername() %></h2>
                    <span class="badge <%= "ADMIN".equals(user.getRole()) ? "badge-blue" : "badge-green" %> mt-1"><%= user.getRole() %></span>
                </div>
            </div>

            <!-- Profile Details Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                    <p class="text-[11px] text-gray-400 font-semibold uppercase tracking-wider mb-1">Username</p>
                    <p class="text-sm font-semibold text-gray-900"><%= user.getUsername() %></p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                    <p class="text-[11px] text-gray-400 font-semibold uppercase tracking-wider mb-1">Role</p>
                    <p class="text-sm font-semibold text-gray-900"><%= user.getRole() %></p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                    <p class="text-[11px] text-gray-400 font-semibold uppercase tracking-wider mb-1">Employee ID</p>
                    <p class="text-sm font-semibold text-gray-900">#<%= user.getEmployeeId() != 0 ? user.getEmployeeId() : "—" %></p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                    <p class="text-[11px] text-gray-400 font-semibold uppercase tracking-wider mb-1">User ID</p>
                    <p class="text-sm font-semibold text-gray-900">#<%= user.getUserId() %></p>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ Change Password Card ═══ -->
    <div class="card p-6">
        <div class="flex items-center gap-3 mb-5">
            <div class="w-9 h-9 bg-indigo-50 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
            </div>
            <div>
                <h3 class="text-sm font-semibold text-gray-900">Change Password</h3>
                <p class="text-xs text-gray-400">Update your account password</p>
            </div>
        </div>

        <form id="changePasswordForm" action="<%= request.getContextPath() %>/profile" method="post" class="space-y-4 max-w-md" onsubmit="return validatePasswordForm()">
            <input type="hidden" name="action" value="changePassword">
            <div>
                <label class="input-label" for="currentPass">Current Password</label>
                <input type="password" id="currentPass" name="currentPassword" class="input-field" placeholder="Enter current password" required>
            </div>
            <div>
                <label class="input-label" for="newPass">New Password</label>
                <input type="password" id="newPass" name="newPassword" class="input-field" placeholder="Enter new password" required>
                <p class="input-help">Minimum 4 characters</p>
            </div>
            <div>
                <label class="input-label" for="confirmPass">Confirm New Password</label>
                <input type="password" id="confirmPass" name="confirmPassword" class="input-field" placeholder="Re-enter new password" required>
            </div>
            <div id="passError" class="text-red-600 text-sm font-medium hidden"></div>
            <div class="flex gap-3 pt-1">
                <button type="submit" class="btn-primary">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
                    Update Password
                </button>
                <button type="reset" class="btn-secondary">Clear</button>
            </div>
        </form>
    </div>
</div>

<script>
function validatePasswordForm() {
    var newPass = document.getElementById('newPass').value;
    var confirmPass = document.getElementById('confirmPass').value;
    var errorDiv = document.getElementById('passError');
    if (newPass !== confirmPass) {
        errorDiv.textContent = 'New password and confirm password do not match.';
        errorDiv.classList.remove('hidden');
        return false;
    }
    if (newPass.length < 4) {
        errorDiv.textContent = 'New password must be at least 4 characters long.';
        errorDiv.classList.remove('hidden');
        return false;
    }
    errorDiv.classList.add('hidden');
    return true;
}
</script>

<%@ include file="../includes/footer.jsp" %>