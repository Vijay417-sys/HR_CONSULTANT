package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.LeaveDAO;
import com.hrdesk.daoimp.LeaveDAOImp;
import com.hrdesk.dto.LeaveDTO;
import com.hrdesk.dto.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/leave")
public class LeaveServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final LeaveDAO leaveDAO = new LeaveDAOImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "apply":
                request.getRequestDispatcher("/employee/apply-leave.jsp").forward(request, response);
                break;
            case "my":
                // Employee's own leaves
                List<LeaveDTO> myLeaves = leaveDAO.getLeavesByEmployee(user.getEmployeeId());
                request.setAttribute("leaves", myLeaves);
                request.getRequestDispatcher("/employee/my-leaves.jsp").forward(request, response);
                break;
            case "approve":
            case "reject":
                int leaveId = Integer.parseInt(request.getParameter("id"));
                String newStatus = "approve".equals(action) ? "APPROVED" : "REJECTED";
                leaveDAO.updateLeaveStatus(leaveId, newStatus);
                response.sendRedirect(request.getContextPath() + "/leave?action=list");
                return;
            case "delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                leaveDAO.deleteLeave(delId);
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/leave?action=list");
                } else {
                    response.sendRedirect(request.getContextPath() + "/leave?action=my");
                }
                return;
            default:
                // Admin list — all leaves
                List<LeaveDTO> allLeaves = leaveDAO.getAllLeaves();
                request.setAttribute("leaves", allLeaves);
                request.getRequestDispatcher("/admin/leave-requests.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null)
            action = "apply";

        if ("apply".equals(action)) {
            LeaveDTO leave = new LeaveDTO();
            leave.setEmployeeId(user.getEmployeeId());
            leave.setLeaveType(request.getParameter("leaveType"));
            leave.setReason(request.getParameter("reason"));

            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            try {
                if (fromDateStr != null && !fromDateStr.isEmpty())
                    leave.setFromDate(java.sql.Date.valueOf(fromDateStr));
                if (toDateStr != null && !toDateStr.isEmpty())
                    leave.setToDate(java.sql.Date.valueOf(toDateStr));
            } catch (Exception ignored) {
            }

            boolean success = leaveDAO.applyLeave(leave);
            if (success) {
                session.setAttribute("successMsg", "Leave application submitted successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to submit leave. Please try again.");
            }
            response.sendRedirect(request.getContextPath() + "/leave?action=my");
        } else {
            doGet(request, response);
        }
    }
}
