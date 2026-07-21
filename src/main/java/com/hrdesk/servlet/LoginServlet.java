package com.hrdesk.servlet;

import java.io.IOException;

import com.hrdesk.dao.AttendanceDAO;
import com.hrdesk.dao.UserDAO;
import com.hrdesk.daoimp.AttendanceDAOImp;
import com.hrdesk.daoimp.UserDAOImpl;
import com.hrdesk.dto.AttendanceDTO;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAOImpl();
    private AttendanceDAO attendanceDAO = new AttendanceDAOImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("employeeId", user.getEmployeeId());

            if ("ADMIN".equals(user.getRole())) {
                // Admin → Admin Dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                // Auto-mark attendance: PRESENT with current time (NOW()) on login
                AttendanceDTO att = new AttendanceDTO();
                att.setEmployeeId(user.getEmployeeId());
                att.setAttendanceStatus("PRESENT");
                att.setAttendanceDate(new java.util.Date());
                att.setCheckIn(new java.sql.Time(System.currentTimeMillis()));
                attendanceDAO.markAttendance(att);

                // Employee → Employee Dashboard
                response.sendRedirect(request.getContextPath() + "/employee?action=dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
