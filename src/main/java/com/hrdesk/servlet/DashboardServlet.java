package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.EmployeeDAO;
import com.hrdesk.dao.AttendanceDAO;
import com.hrdesk.dao.LeaveDAO;
import com.hrdesk.dao.DeptDAO;
import com.hrdesk.dao.SupportTokenDAO;
import com.hrdesk.dao.PayrollDAO;
import com.hrdesk.daoimp.EmployeeDAOImp;
import com.hrdesk.daoimp.AttendanceDAOImp;
import com.hrdesk.daoimp.LeaveDAOImp;
import com.hrdesk.daoimp.DeptDAOImp;
import com.hrdesk.daoimp.SupportTokenDAOImp;
import com.hrdesk.daoimp.PayrollDAOImp;
import com.hrdesk.dto.AttendanceDTO;
import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.dto.LeaveDTO;
import com.hrdesk.dto.SupportTokenDTO;
import com.hrdesk.dto.PayrollDTO;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final EmployeeDAO employeeDAO = new EmployeeDAOImp();
    private final AttendanceDAO attendDAO = new AttendanceDAOImp();
    private final LeaveDAO leaveDAO = new LeaveDAOImp();
    private final DeptDAO deptDAO = new DeptDAOImp();
    private final SupportTokenDAO supportDAO = new SupportTokenDAOImp();
    private final PayrollDAO payrollDAO = new PayrollDAOImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if ("ADMIN".equals(user.getRole())) {
            // Aggregate stats
            List<EmployeeDTO> allEmployees = employeeDAO.getAllEmployees();
            int totalEmployees = allEmployees.size();

            List<LeaveDTO> pendingLeaves = leaveDAO.getLeavesByStatus("PENDING");
            int pendingLeaveCount = pendingLeaves.size();

            int totalDepts = deptDAO.getAllDepartments().size();

            // Get today's attendance count (present)
            java.util.Date today = new java.util.Date();
            List<?> todayAtt = attendDAO.getAttendanceByDate(today);
            long presentToday = todayAtt.stream()
                    .filter(a -> "PRESENT".equals(((com.hrdesk.dto.AttendanceDTO) a).getAttendanceStatus()))
                    .count();

            // Support ticket stats
            List<SupportTokenDTO> openTickets = supportDAO.getTokensByStatus("OPEN");
            int openTicketCount = openTickets.size();

            // Recent 5 tickets for dashboard
            List<SupportTokenDTO> allTickets = supportDAO.getAllTokens();
            List<SupportTokenDTO> recentTickets = allTickets.size() > 5
                    ? allTickets.subList(0, 5)
                    : allTickets;

            // Recent 5 employees for table
            List<EmployeeDTO> recentEmployees = allEmployees.size() > 5
                    ? allEmployees.subList(0, 5)
                    : allEmployees;

            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("pendingLeaves", pendingLeaveCount);
            request.setAttribute("totalDepts", totalDepts);
            request.setAttribute("presentToday", (int) presentToday);
            request.setAttribute("openTickets", openTicketCount);
            request.setAttribute("recentTickets", recentTickets);
            request.setAttribute("recentEmployees", recentEmployees);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } else {
            // Employee dashboard — compute stats for logged-in employee
            int empId = user.getEmployeeId();

            // Days present
            List<AttendanceDTO> myAttendance = attendDAO.getAttendanceByEmployee(empId);
            long presentDays = myAttendance.stream()
                    .filter(a -> "PRESENT".equals(a.getAttendanceStatus()))
                    .count();
            int totalDays = myAttendance.size();
            int attendancePct = totalDays > 0 ? (int) (presentDays * 100 / totalDays) : 0;

            // Leave balance (total approved leaves taken)
            List<LeaveDTO> myLeaves = leaveDAO.getLeavesByEmployee(empId);
            long leaveBalance = myLeaves.stream()
                    .filter(l -> "APPROVED".equals(l.getLeaveStatus()))
                    .count();

            // Monthly salary
            EmployeeDTO empDetails = employeeDAO.getEmployeeById(empId);
            double monthlySalary = (empDetails != null) ? empDetails.getSalary() : 0;

            // Latest payslip for download
            List<PayrollDTO> payrolls = payrollDAO.getPayrollByEmployee(empId);
            PayrollDTO latestPayroll = (payrolls != null && !payrolls.isEmpty()) ? payrolls.get(0) : null;
            if (latestPayroll != null) request.setAttribute("latestPayroll", latestPayroll);

            request.setAttribute("presentDays", (int) presentDays);
            request.setAttribute("leaveBalance", (int) leaveBalance);
            request.setAttribute("monthlySalary", monthlySalary);
            request.setAttribute("attendancePct", attendancePct);

            request.getRequestDispatcher("/employee/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
