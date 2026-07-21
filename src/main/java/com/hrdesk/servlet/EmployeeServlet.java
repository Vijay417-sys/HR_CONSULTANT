package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.EmployeeDAO;
import com.hrdesk.dao.DeptDAO;
import com.hrdesk.daoimp.EmployeeDAOImp;
import com.hrdesk.daoimp.DeptDAOImp;
import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.dto.DeptDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/employee")
public class EmployeeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO employeeDAO = new EmployeeDAOImp();
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
            case "dashboard":
                // Employee Dashboard – show logged-in employee's overview
                request.getRequestDispatcher("/employee/dashboard.jsp").forward(request, response);
                break;
            case "add":
                loadDepartments(request);
                request.getRequestDispatcher("/admin/add-employee.jsp").forward(request, response);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                EmployeeDTO emp = employeeDAO.getEmployeeById(editId);
                request.setAttribute("employee", emp);
                loadDepartments(request);
                request.getRequestDispatcher("/admin/add-employee.jsp").forward(request, response);
                break;
            case "delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                employeeDAO.deleteEmployee(delId);
                response.sendRedirect(request.getContextPath() + "/employee?action=list");
                break;
            default:
                // /list
                List<EmployeeDTO> employees = employeeDAO.getAllEmployees();
                request.setAttribute("employees", employees);
                loadDepartments(request);
                request.getRequestDispatcher("/admin/view-employees.jsp").forward(request, response);
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

        if ("add".equals(action) || "edit".equals(action)) {
            EmployeeDTO emp = new EmployeeDTO();

            String idParam = request.getParameter("employeeId");
            if (idParam != null && !idParam.isEmpty()) {
                emp.setEmployeeId(Integer.parseInt(idParam));
            }
            emp.setFirstName(request.getParameter("firstName"));
            emp.setLastName(request.getParameter("lastName") != null ? request.getParameter("lastName") : "");
            emp.setEmail(request.getParameter("email"));
            emp.setPhone(request.getParameter("phone"));
            emp.setGender(request.getParameter("gender"));
            String dobParam = request.getParameter("dob");
            if (dobParam != null && !dobParam.isEmpty()) {
                try {
                    emp.setDob(java.sql.Date.valueOf(dobParam));
                } catch (Exception ignored) {
                }
            }
            emp.setDesignation(
                    request.getParameter("designation") != null ? request.getParameter("designation") : "EMPLOYEE");
            emp.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "ACTIVE");
            String deptIdStr = request.getParameter("departmentId");
            if (deptIdStr != null && !deptIdStr.isEmpty())
                emp.setDepartmentId(Integer.parseInt(deptIdStr));
            String salaryStr = request.getParameter("salary");
            if (salaryStr != null && !salaryStr.isEmpty())
                emp.setSalary(Double.parseDouble(salaryStr));
            String hireDate = request.getParameter("hireDate");
            if (hireDate != null && !hireDate.isEmpty()) {
                try {
                    emp.setHireDate(java.sql.Date.valueOf(hireDate));
                } catch (Exception ignored) {
                }
            }

            boolean success;
            if (emp.getEmployeeId() > 0) {
                success = employeeDAO.updateEmployee(emp);
            } else {
                success = employeeDAO.addEmployee(emp);
            }

            if (success) {
                request.getSession().setAttribute("successMsg", "Employee saved successfully.");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to save employee. Please try again.");
            }
            response.sendRedirect(request.getContextPath() + "/employee?action=list");
        } else {
            doGet(request, response);
        }
    }

    private void loadDepartments(HttpServletRequest request) {
        List<DeptDTO> departments = deptDAO.getAllDepartments();
        request.setAttribute("departments", departments);
    }
}
