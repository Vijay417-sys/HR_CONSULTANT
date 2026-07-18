<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User, com.hrdesk.dto.PayrollDTO, com.hrdesk.dto.EmployeeDTO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<PayrollDTO> payrolls = (List<PayrollDTO>) request.getAttribute("payrollList");
    List<EmployeeDTO> employees = (List<EmployeeDTO>) request.getAttribute("employees");

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");

    // Compute totals
    double totalDisbursed = 0;
    if (payrolls != null) {
        for (PayrollDTO p : payrolls) totalDisbursed += p.getNetSalary();
    }
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Payroll';document.getElementById('page-breadcrumb').textContent='HRDesk / Admin / Payroll';</script>

<% if (successMsg != null) { %>
<div class="flex items-center gap-2 bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-6 text-sm">
    <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <%= successMsg %>
</div>
<% } %>
<% if (errorMsg != null) { %>
<div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-6 text-sm">
    <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    <%= errorMsg %>
</div>
<% } %>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Generate Payroll Panel -->
    <div class="lg:col-span-1">
        <div class="card p-6 mb-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <h3 class="text-sm font-semibold text-gray-900 mb-4">Generate Payroll</h3>
            <form action="<%= request.getContextPath() %>/payroll/generate" method="post" class="space-y-4">
                <div>
                    <label class="input-label" for="employeeId">Employee *</label>
                    <select id="employeeId" name="employeeId" class="input-field" required>
                        <option value="">Select Employee</option>
                        <% if (employees != null) {
                            for (EmployeeDTO emp : employees) {
                                String empName = (emp.getFirstName() != null ? emp.getFirstName() : "")
                                              + (emp.getLastName() != null && !emp.getLastName().isEmpty() ? " " + emp.getLastName() : "");
                        %>
                        <option value="<%= emp.getEmployeeId() %>"><%= empName.trim().isEmpty() ? "Emp #" + emp.getEmployeeId() : empName.trim() %></option>
                        <% } } %>
                    </select>
                </div>
                <div>
                    <label class="input-label" for="payrollMonth">Month *</label>
                    <input type="month" id="payrollMonth" name="payrollMonth" class="input-field" required>
                </div>
                <div>
                    <label class="input-label" for="basicSalary">Basic Salary (₹) *</label>
                    <input type="number" id="basicSalary" name="basicSalary" class="input-field" placeholder="50000" min="0" step="100" required>
                </div>
                <div>
                    <label class="input-label" for="bonus">Bonus (₹)</label>
                    <input type="number" id="bonus" name="bonus" class="input-field" placeholder="0" min="0" step="100" value="0">
                </div>
                <div>
                    <label class="input-label" for="deduction">Deduction (₹)</label>
                    <input type="number" id="deduction" name="deduction" class="input-field" placeholder="0" min="0" step="100" value="0">
                </div>
                <button type="submit" class="btn-primary w-full" style="justify-content:center;">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                    Generate Payroll
                </button>
            </form>
        </div>

        <!-- Quick Stats -->
        <div class="card p-5" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">Summary</h3>
            <div class="space-y-3">
                <div class="flex justify-between items-center">
                    <span class="text-sm text-gray-600">Records Total</span>
                    <span class="text-sm font-semibold text-gray-900"><%= payrolls != null ? payrolls.size() : 0 %></span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-sm text-gray-600">Total Disbursed</span>
                    <span class="text-sm font-semibold text-green-600">₹<%= String.format("%,.0f", totalDisbursed) %></span>
                </div>
            </div>
        </div>
    </div>

    <!-- Payroll Records -->
    <div class="lg:col-span-2">
        <div class="card" style="box-shadow:0 1px 4px rgba(0,0,0,.06);">
            <div class="px-6 py-4 border-b border-gray-100">
                <h3 class="text-sm font-semibold text-gray-900">Payroll Records</h3>
            </div>
            <div class="overflow-x-auto">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Emp ID</th>
                            <th>Month</th>
                            <th>Basic Salary</th>
                            <th>Bonus</th>
                            <th>Deduction</th>
                            <th>Net Pay</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (payrolls != null && !payrolls.isEmpty()) {
                            int sn = 1;
                            for (PayrollDTO p : payrolls) { %>
                        <tr>
                            <td class="text-gray-400 text-xs"><%= sn++ %></td>
                            <td class="font-medium text-gray-900">Emp #<%= p.getEmployeeId() %></td>
                            <td class="text-gray-500"><%= p.getPayrollMonth() != null ? p.getPayrollMonth() : "—" %></td>
                            <td class="text-gray-900">₹<%= String.format("%,.0f", p.getBasicSalary()) %></td>
                            <td class="text-green-600">+₹<%= String.format("%,.0f", p.getBonus()) %></td>
                            <td class="text-red-500">-₹<%= String.format("%,.0f", p.getDeduction()) %></td>
                            <td class="font-semibold text-gray-900">₹<%= String.format("%,.0f", p.getNetSalary()) %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/payroll/delete?id=<%= p.getPayrollId() %>" class="text-xs text-red-500 hover:text-red-700 font-medium no-underline" onclick="return confirm('Delete this payroll record?')">Delete</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="8" class="py-16 text-center">
                                <div class="flex flex-col items-center gap-2">
                                    <svg class="w-10 h-10 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                    <p class="text-sm text-gray-400">No payroll records yet. Generate payroll to begin.</p>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>