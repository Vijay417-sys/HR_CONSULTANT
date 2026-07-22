<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User"%>

<%
User user = (User) session.getAttribute("user");

if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
%>

<%@ include file="../includes/header.jsp"%>

<script>
document.getElementById('page-title').textContent='My Profile';
document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Profile';
</script>

<div class="max-w-3xl mx-auto">

    <div class="card overflow-hidden rounded-xl shadow-lg">

        <!-- Small Profile Header -->
        <div class="h-14 bg-gradient-to-r from-indigo-500 to-purple-600"></div>

        <div class="px-6 pb-6">

            <!-- Profile -->
            <div class="flex items-end gap-4 -mt-8 mb-6">

                <div
                    class="w-16 h-16 rounded-xl bg-indigo-600 border-4 border-white shadow-lg flex items-center justify-center text-white text-2xl font-bold">
                    <%=Character.toUpperCase(user.getUsername().charAt(0))%>
                </div>

                <div class="pb-1">
                    <h2 class="text-xl font-bold text-gray-900">
                        <%=user.getUsername()%>
                    </h2>

                    <span
                        class="inline-block px-3 py-1 rounded-full text-xs font-semibold
                        <%=user.getRole().equals("ADMIN") ? "bg-blue-100 text-blue-700"
        : "bg-green-100 text-green-700"%>">

                        <%=user.getRole()%>

                    </span>

                </div>

            </div>

            <!-- Information -->

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                <div class="bg-gray-50 rounded-lg p-4">

                    <p class="text-xs text-gray-500 uppercase">Username</p>

                    <p class="font-semibold text-gray-900 mt-1">
                        <%=user.getUsername()%>
                    </p>

                </div>

                <div class="bg-gray-50 rounded-lg p-4">

                    <p class="text-xs text-gray-500 uppercase">Role</p>

                    <p class="font-semibold text-gray-900 mt-1">
                        <%=user.getRole()%>
                    </p>

                </div>

                <div class="bg-gray-50 rounded-lg p-4">

                    <p class="text-xs text-gray-500 uppercase">Employee ID</p>

                    <p class="font-semibold text-gray-900 mt-1">
                        #<%=user.getEmployeeId()%>
                    </p>

                </div>

                <div class="bg-gray-50 rounded-lg p-4">

                    <p class="text-xs text-gray-500 uppercase">User ID</p>

                    <p class="font-semibold text-gray-900 mt-1">
                        #<%=user.getUserId()%>
                    </p>

                </div>

            </div>

            <!-- Password Card -->

            <div class="mt-8 border rounded-xl p-6 bg-white">

                <h3 class="text-lg font-bold mb-5">
                    Change Password
                </h3>

                <form action="<%=request.getContextPath()%>/profile"
                    method="post">

                    <input type="hidden"
                        name="action"
                        value="changePassword">

                    <div class="mb-4">

                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Current Password
                        </label>

                        <input type="password"
                            name="currentPassword"
                            placeholder="Enter Current Password"
                            class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                            required>

                    </div>

                    <div class="mb-4">

                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            New Password
                        </label>

                        <input type="password"
                            name="newPassword"
                            placeholder="Enter New Password"
                            class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                            required>

                    </div>

                    <div class="mb-5">

                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Confirm New Password
                        </label>

                        <input type="password"
                            name="confirmPassword"
                            placeholder="Confirm New Password"
                            class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-indigo-500 outline-none"
                            required>

                    </div>

                    <button type="submit"
                        class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-lg font-semibold transition">

                        Update Password

                    </button>

                </form>

            </div>

        </div>

    </div>

</div>

<%@ include file="../includes/footer.jsp"%>