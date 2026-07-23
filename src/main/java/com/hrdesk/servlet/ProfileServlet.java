package com.hrdesk.servlet;

import java.io.IOException;

import com.hrdesk.dao.UserDAO;
import com.hrdesk.daoimp.UserDAOImpl;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward to the employee profile page
        request.getRequestDispatcher("/employee/my-profile.jsp").forward(request, response);
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
        if ("changePassword".equals(action)) {
            changePassword(request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        User sessionUser = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate current password matches the database
        User dbUser = userDAO.login(sessionUser.getEmail(), currentPassword);
        if (dbUser == null) {
            session.setAttribute("errorMsg", "Current password is incorrect.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Validate new password
        if (newPassword == null || newPassword.trim().isEmpty()) {
            session.setAttribute("errorMsg", "New password cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Validate confirm password matches
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "New password and confirm password do not match.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Update password in database
        User updatedUser = new User();
        updatedUser.setUserId(sessionUser.getUserId());
        updatedUser.setEmail(sessionUser.getEmail());
        updatedUser.setPassword(newPassword);
        updatedUser.setRole(sessionUser.getRole());

        boolean success = userDAO.updateUser(updatedUser);
        if (success) {
            // Update the session user's password too
            sessionUser.setPassword(newPassword);
            session.setAttribute("user", sessionUser);
            session.setAttribute("successMsg", "Password updated successfully.");
        } else {
            session.setAttribute("errorMsg", "Failed to update password. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
