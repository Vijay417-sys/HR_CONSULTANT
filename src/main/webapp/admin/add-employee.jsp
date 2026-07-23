<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.EmployeeDTO, com.hrdesk.dto.DeptDTO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    request.setAttribute("navPage", "employees");
    EmployeeDTO editEmployee = (EmployeeDTO) request.getAttribute("employee");
    boolean isEdit = (editEmployee != null);
    List<DeptDTO> departments = (List<DeptDTO>) request.getAttribute("departments");

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='<%= isEdit ? "Edit Employee" : "Add Employee" %>';document.getElementById('page-breadcrumb').textContent='HRDesk / Admin / <%= isEdit ? "Edit" : "Add" %> Employee';</script>

<div class="max-w-2xl">
    <% if (successMsg != null) { %>
    <div class="alert alert-success mb-6"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
    <div class="alert alert-danger mb-6"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= errorMsg %></div>
    <% } %>

    <div class="card">
        <div class="px-6 py-5 border-b border-gray-100">
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 bg-indigo-50 rounded-lg flex items-center justify-center">
                    <svg class="w-4 h-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
                </div>
                <div>
                    <h3 class="text-sm font-semibold text-gray-900"><%= isEdit ? "Edit Employee" : "Add New Employee" %></h3>
                    <p class="text-xs text-gray-400 mt-0.5"><%= isEdit ? "Update employee details." : "Fill in the details to add a new employee." %></p>
                </div>
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/employee?action=<%= isEdit ? "edit" : "add" %>" method="post" class="p-6 space-y-5">
            <% if (isEdit) { %>
            <input type="hidden" name="employeeId" value="<%= editEmployee.getEmployeeId() %>">
            <% } %>
            <div class="form-grid">
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="firstName">First Name *</label>
                    <input type="text" id="firstName" name="firstName" class="input-field" placeholder="John" required
                           value="<%= isEdit && editEmployee.getFirstName() != null ? editEmployee.getFirstName() : "" %>">
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="input-field" placeholder="Doe"
                           value="<%= isEdit && editEmployee.getLastName() != null ? editEmployee.getLastName() : "" %>">
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="email">Email Address *</label>
                    <input type="email" id="email" name="email" class="input-field" placeholder="john@company.com" required
                           value="<%= isEdit && editEmployee.getEmail() != null ? editEmployee.getEmail() : "" %>">
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="input-field" placeholder="+91 98765 43210"
                           value="<%= isEdit && editEmployee.getPhone() != null ? editEmployee.getPhone() : "" %>">
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="gender">Gender</label>
                    <select id="gender" name="gender" class="input-field">
                        <option value="">Select Gender</option>
                        <option value="MALE"   <%= isEdit && "MALE".equals(editEmployee.getGender())   ? "selected" : "" %>>Male</option>
                        <option value="FEMALE" <%= isEdit && "FEMALE".equals(editEmployee.getGender()) ? "selected" : "" %>>Female</option>
                        <option value="OTHER"  <%= isEdit && "OTHER".equals(editEmployee.getGender())  ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="dob">Date of Birth</label>
                    <input type="date" id="dob" name="dob" class="input-field"
                           value="<%= isEdit && editEmployee.getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(editEmployee.getDob()) : "" %>">
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="designation">Designation / Role</label>
                    <input type="text" id="designation" name="designation" class="input-field" placeholder="e.g. Software Engineer"
                           value="<%= isEdit && editEmployee.getDesignation() != null ? editEmployee.getDesignation() : "" %>">
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="departmentId">Department *</label>
                    <select id="departmentId" name="departmentId" class="input-field" required>
                        <option value="">Select Department</option>
                        <% if (departments != null) {
                            for (DeptDTO dept : departments) { %>
                        <option value="<%= dept.getDepartmentId() %>" <%= isEdit && editEmployee.getDepartmentId() == dept.getDepartmentId() ? "selected" : "" %>>
                            <%= dept.getDepartmentName() %>
                        </option>
                        <% } } %>
                    </select>
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="salary">Monthly Salary (₹) *</label>
                    <input type="number" id="salary" name="salary" class="input-field" placeholder="50000" min="0" step="500" required
                           value="<%= isEdit ? editEmployee.getSalary() : "" %>">
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label class="input-label" for="hireDate">Hire Date *</label>
                    <input type="date" id="hireDate" name="hireDate" class="input-field" required
                           value="<%= isEdit && editEmployee.getHireDate() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(editEmployee.getHireDate()) : "" %>">
                </div>
            </div>
            <div class="form-group" style="margin-bottom:0;">
                <label class="input-label" for="status">Status</label>
                <select id="status" name="status" class="input-field">
                    <option value="ACTIVE"   <%= isEdit && "ACTIVE".equals(editEmployee.getStatus())   ? "selected" : "" %>>Active</option>
                    <option value="INACTIVE" <%= isEdit && "INACTIVE".equals(editEmployee.getStatus()) ? "selected" : "" %>>Inactive</option>
                </select>
            </div>
            <div class="flex gap-3 pt-2">
                <button type="submit" class="btn-primary">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
                    <%= isEdit ? "Update Employee" : "Add Employee" %>
                </button>
                <a href="<%= request.getContextPath() %>/employee?action=list" class="btn-secondary no-underline">Cancel</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>