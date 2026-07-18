package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.SupportTokenDAO;
import com.hrdesk.daoimp.SupportTokenDAOImp;
import com.hrdesk.dto.SupportTokenDTO;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/support/*")
public class SupportTokenServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final SupportTokenDAO tokenDAO = new SupportTokenDAOImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getPathInfo();
        if (action == null) action = "/list";

        switch (action) {
            case "/raise":
                request.getRequestDispatcher("/employee/raise-ticket.jsp").forward(request, response);
                break;
            case "/my":
                List<SupportTokenDTO> myTokens = tokenDAO.getTokensByEmployee(user.getEmployeeId());
                request.setAttribute("tokens", myTokens);
                request.getRequestDispatcher("/employee/my-tickets.jsp").forward(request, response);
                break;
            case "/resolve":
                int resolveId = Integer.parseInt(request.getParameter("id"));
                tokenDAO.updateTokenStatus(resolveId, "RESOLVED");
                response.sendRedirect(request.getContextPath() + "/support/list");
                return;
            case "/close":
                int closeId = Integer.parseInt(request.getParameter("id"));
                tokenDAO.updateTokenStatus(closeId, "CLOSED");
                response.sendRedirect(request.getContextPath() + "/support/list");
                return;
            case "/inprogress":
                int inProgressId = Integer.parseInt(request.getParameter("id"));
                tokenDAO.updateTokenStatus(inProgressId, "IN_PROGRESS");
                response.sendRedirect(request.getContextPath() + "/support/list");
                return;
            case "/delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                tokenDAO.deleteToken(delId);
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/support/list");
                } else {
                    response.sendRedirect(request.getContextPath() + "/support/my");
                }
                return;
            default:
                // Admin — list all tickets
                List<SupportTokenDTO> allTokens = tokenDAO.getAllTokens();
                request.setAttribute("tokens", allTokens);
                request.getRequestDispatcher("/admin/manage-tickets.jsp").forward(request, response);
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
        String action = request.getPathInfo();
        if (action == null) action = "/raise";

        if ("/raise".equals(action)) {
            SupportTokenDTO token = new SupportTokenDTO();
            token.setEmpId(user.getEmployeeId());
            token.setTitle(request.getParameter("title"));
            token.setDescription(request.getParameter("description"));
            token.setCategory(request.getParameter("category") != null ? request.getParameter("category") : "OTHER");
            token.setPriority(request.getParameter("priority") != null ? request.getParameter("priority") : "MEDIUM");

            boolean success = tokenDAO.createToken(token);
            if (success) {
                session.setAttribute("successMsg", "Support ticket raised successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to raise ticket. Please try again.");
            }
            response.sendRedirect(request.getContextPath() + "/support/my");
        } else {
            doGet(request, response);
        }
    }
}
