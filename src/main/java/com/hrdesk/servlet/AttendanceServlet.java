package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.AttendanceDAO;
import com.hrdesk.dao.EmployeeDAO;
import com.hrdesk.daoimp.AttendanceDAOImp;
import com.hrdesk.daoimp.EmployeeDAOImp;
import com.hrdesk.dto.AttendanceDTO;
import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.dto.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final AttendanceDAO attendanceDAO = new AttendanceDAOImp();
    private final EmployeeDAO employeeDAO = new EmployeeDAOImp();

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

        if (action.equals("my")) {
            // Employee's own attendance
            List<AttendanceDTO> myAttendance = attendanceDAO.getAttendanceByEmployee(user.getEmployeeId());
            request.setAttribute("attendanceList", myAttendance);
            request.getRequestDispatcher("/employee/my-attendance.jsp").forward(request, response);
        } else if (action.equals("checkout")) {
            // Employee checks out — set check_out on today's attendance
            java.util.Date today = new java.util.Date();
            AttendanceDTO todayAtt = attendanceDAO.getAttendanceByDate(today).stream()
                .filter(a -> a.getEmployeeId() == user.getEmployeeId())
                .findFirst().orElse(null);
            if (todayAtt != null) {
                todayAtt.setCheckOut(new java.sql.Time(System.currentTimeMillis()));
                attendanceDAO.updateAttendance(todayAtt);
                session.setAttribute("successMsg", "Check-out recorded successfully.");
            } else {
                session.setAttribute("errorMsg", "No check-in record found for today.");
            }
            response.sendRedirect(request.getContextPath() + "/attendance?action=my");
        } else if (action.equals("delete")) {
            int delId = Integer.parseInt(request.getParameter("id"));
            attendanceDAO.deleteAttendance(delId);
            String redirect = "ADMIN".equals(user.getRole()) ? "list" : "my";
            response.sendRedirect(request.getContextPath() + "/attendance?action=" + redirect);
        } else {
            // Admin list all + load employees for mark form
            List<AttendanceDTO> all = attendanceDAO.getAllAttendance();
            request.setAttribute("attendanceList", all);
            List<EmployeeDTO> employees = employeeDAO.getAllEmployees();
            request.setAttribute("employeeList", employees);
            request.getRequestDispatcher("/admin/attendance-report.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        if (action == null)
            action = "mark";

        if ("mark".equals(action)) {
            AttendanceDTO att = new AttendanceDTO();

            String empIdStr = request.getParameter("empId");
            if (empIdStr != null && !empIdStr.isEmpty()) {
                att.setEmployeeId(Integer.parseInt(empIdStr));
            } else {
                User user = (User) session.getAttribute("user");
                att.setEmployeeId(user.getEmployeeId());
            }

            att.setAttendanceStatus(
                    request.getParameter("status") != null ? request.getParameter("status") : "PRESENT");

            String dateStr = request.getParameter("date");
            try {
                if (dateStr != null && !dateStr.isEmpty())
                    att.setAttendanceDate(java.sql.Date.valueOf(dateStr));
                else
                    att.setAttendanceDate(new java.util.Date());
            } catch (Exception ignored) {
                att.setAttendanceDate(new java.util.Date());
            }

            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            try {
                if (checkIn != null && !checkIn.isEmpty())
                    att.setCheckIn(java.sql.Time.valueOf(checkIn + ":00"));
                if (checkOut != null && !checkOut.isEmpty())
                    att.setCheckOut(java.sql.Time.valueOf(checkOut + ":00"));
            } catch (Exception ignored) {
            }

            boolean success = attendanceDAO.markAttendance(att);
            if (success) {
                session.setAttribute("successMsg", "Attendance marked successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to mark attendance.");
            }
            // Redirect based on role
            User sessionUser = (User) session.getAttribute("user");
            String redirectAction = "ADMIN".equals(sessionUser.getRole()) ? "list" : "my";
            response.sendRedirect(request.getContextPath() + "/attendance?action=" + redirectAction);
        } else {
            doGet(request, response);
        }
    }
}
