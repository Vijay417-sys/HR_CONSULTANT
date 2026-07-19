package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.AttendanceDAO;
import com.hrdesk.daoimp.AttendanceDAOImp;
import com.hrdesk.dto.AttendanceDTO;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final AttendanceDAO attendanceDAO = new AttendanceDAOImp();

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
        } else if (action.equals("delete")) {
            int delId = Integer.parseInt(request.getParameter("id"));
            attendanceDAO.deleteAttendance(delId);
            response.sendRedirect(request.getContextPath() + "/attendance?action=list");
        } else {
            // Admin list all
            List<AttendanceDTO> all = attendanceDAO.getAllAttendance();
            request.setAttribute("attendanceList", all);
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
            response.sendRedirect(request.getContextPath() + "/attendance?action=list");
        } else {
            doGet(request, response);
        }
    }
}
