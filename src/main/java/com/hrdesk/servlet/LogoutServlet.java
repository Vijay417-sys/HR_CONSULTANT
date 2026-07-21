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

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final AttendanceDAO attendanceDAO = new AttendanceDAOImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && !"ADMIN".equals(user.getRole())) {
                // Auto-checkout: update today's attendance with logout time
                List<AttendanceDTO> records = attendanceDAO.getAttendanceByEmployee(user.getEmployeeId());
                String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                for (AttendanceDTO att : records) {
                    if (att.getAttendanceDate() != null && today.equals(att.getAttendanceDate().toString())) {
                        att.setCheckOut(new java.sql.Time(System.currentTimeMillis()));
                        attendanceDAO.updateAttendance(att);
                        break;
                    }
                }
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
