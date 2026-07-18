<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='My Profile';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Profile';</script>

<div class="max-w-2xl">
    <div class="card overflow-hidden" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
        <!-- Profile Header -->
        <div class="h-24 bg-gradient-to-r from-indigo-500 to-purple-600 relative"></div>
        <div class="px-6 pb-6">
            <div class="flex items-end gap-4 -mt-10 mb-6">
                <div class="w-20 h-20 bg-indigo-600 rounded-2xl border-4 border-white flex items-center justify-center text-white font-black text-2xl shadow-md">
                    <%= user.getUsername().charAt(0) %>
                </div>
                <div class="pb-2">
                    <h2 class="text-xl font-bold text-gray-900"><%= user.getUsername() %></h2>
                    <span class="badge <%= "ADMIN".equals(user.getRole()) ? "badge-blue" : "badge-green" %>"><%= user.getRole() %></span>
                </div>
            </div>

            <!-- Profile Fields -->
            <div class="space-y-4">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div class="bg-gray-50 rounded-lg p-4">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Username</p>
                        <p class="text-sm font-semibold text-gray-900"><%= user.getUsername() %></p>
                    </div>
                    <div class="bg-gray-50 rounded-lg p-4">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Role</p>
                        <p class="text-sm font-semibold text-gray-900"><%= user.getRole() %></p>
                    </div>
                    <div class="bg-gray-50 rounded-lg p-4">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Employee ID</p>
                        <p class="text-sm font-semibold text-gray-900">#<%= user.getEmployeeId() != 0 ? user.getEmployeeId() : "—" %></p>
                    </div>
                    <div class="bg-gray-50 rounded-lg p-4">
                        <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">User ID</p>
                        <p class="text-sm font-semibold text-gray-900">#<%= user.getUserId() %></p>
                    </div>
                </div>

                <!-- Change Password -->
                <div class="border border-gray-200 rounded-xl p-5 mt-4">
                    <h3 class="text-sm font-semibold text-gray-900 mb-4">Change Password</h3>
                    <form action="<%= request.getContextPath() %>/profile" method="post" class="space-y-4">
                        <input type="hidden" name="action" value="changePassword">
                        <div>
                            <label class="input-label" for="currentPass">Current Password</label>
                            <input type="password" id="currentPass" name="currentPassword" class="input-field" placeholder="••••••••" required>
                        </div>
                        <div>
                            <label class="input-label" for="newPass">New Password</label>
                            <input type="password" id="newPass" name="newPassword" class="input-field" placeholder="••••••••" required>
                        </div>
                        <div>
                            <label class="input-label" for="confirmPass">Confirm New Password</label>
                            <input type="password" id="confirmPass" name="confirmPassword" class="input-field" placeholder="••••••••" required>
                        </div>
                        <button type="submit" class="btn-primary">Update Password</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>