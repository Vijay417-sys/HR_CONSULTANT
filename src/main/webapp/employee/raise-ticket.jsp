<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrdesk.dto.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    request.setAttribute("navPage", "tickets");

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<%@ include file="../includes/header.jsp" %>
<script>document.getElementById('page-title').textContent='Raise Ticket';document.getElementById('page-breadcrumb').textContent='HRDesk / Employee / Support';</script>

<div class="max-w-xl">
    <div class="card p-6">
        <div class="flex items-center gap-3 mb-5">
            <div class="w-9 h-9 bg-indigo-50 rounded-lg flex items-center justify-center">
                <svg class="w-4 h-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>
            </div>
            <div>
                <h3 class="text-sm font-semibold text-gray-900">Submit a Support Ticket</h3>
                <p class="text-xs text-gray-400">Describe your issue and we'll get back to you</p>
            </div>
        </div>

        <% if (successMsg != null) { %>
        <div class="alert alert-success mb-5"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-danger mb-5"><svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> <%= errorMsg %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/support?action=raise" method="post" class="space-y-5">
            <div>
                <label class="input-label" for="category">Category *</label>
                <select id="category" name="category" class="input-field" required>
                    <option value="">Select category</option>
                    <option value="HARDWARE">Hardware</option>
                    <option value="SOFTWARE">Software</option>
                    <option value="NETWORK">Network</option>
                    <option value="ACCESSORY">Accessory</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>
            <div>
                <label class="input-label" for="title">Title / Subject *</label>
                <input type="text" id="title" name="title" class="input-field" placeholder="Brief description of your issue" required>
            </div>
            <div>
                <label class="input-label" for="priority">Priority</label>
                <select id="priority" name="priority" class="input-field">
                    <option value="LOW">Low</option>
                    <option value="MEDIUM" selected>Medium</option>
                    <option value="HIGH">High</option>
                    <option value="URGENT">Urgent</option>
                </select>
            </div>
            <div>
                <label class="input-label" for="description">Description *</label>
                <textarea id="description" name="description" rows="4" class="input-field" placeholder="Describe your issue in detail..." required></textarea>
            </div>
            <div class="flex gap-3">
                <button type="submit" class="btn-primary">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/></svg>
                    Submit Ticket
                </button>
                <a href="<%= request.getContextPath() %>/support?action=my" class="btn-secondary no-underline">View My Tickets</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>