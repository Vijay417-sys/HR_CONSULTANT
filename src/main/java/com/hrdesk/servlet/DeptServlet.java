package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.DeptDAO;
import com.hrdesk.daoimp.DeptDAOImp;
import com.hrdesk.dto.DeptDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dept")
public class DeptServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final DeptDAO deptDAO = new DeptDAOImp();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                deptDAO.deleteDepartment(delId);
                response.sendRedirect(request.getContextPath() + "/dept?action=list");
                return;
            default:
                List<DeptDTO> departments = deptDAO.getAllDepartments();
                request.setAttribute("departments", departments);
                request.getRequestDispatcher("/admin/departments.jsp").forward(request, response);
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
            action = "add";

        DeptDTO dept = new DeptDTO();
        String idStr = request.getParameter("departmentId");
        if (idStr != null && !idStr.isEmpty())
            dept.setDepartmentId(Integer.parseInt(idStr));
        dept.setDepartmentName(request.getParameter("departmentName"));
        dept.setLocation(request.getParameter("location"));

        boolean success;
        if (dept.getDepartmentId() > 0) {
            success = deptDAO.updateDepartment(dept);
        } else {
            success = deptDAO.addDepartment(dept);
        }

        if (success) {
            session.setAttribute("successMsg", "Department saved successfully.");
        } else {
            session.setAttribute("errorMsg", "Failed to save department.");
        }
        response.sendRedirect(request.getContextPath() + "/dept?action=list");
    }
}
