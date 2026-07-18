package com.hrdesk.servlet;

import java.io.IOException;
import java.util.List;

import com.hrdesk.dao.PayrollDAO;
import com.hrdesk.dao.EmployeeDAO;
import com.hrdesk.daoimp.PayrollDAOImp;
import com.hrdesk.daoimp.EmployeeDAOImp;
import com.hrdesk.dto.PayrollDTO;
import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payroll/*")
public class PayrollServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final PayrollDAO payrollDAO = new PayrollDAOImp();
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
        String action = request.getPathInfo();
        if (action == null)
            action = "/list";

        switch (action) {
            case "/my":
                // Employee's own payslips
                List<PayrollDTO> myPayroll = payrollDAO.getPayrollByEmployee(user.getEmployeeId());
                request.setAttribute("payrollList", myPayroll);
                request.getRequestDispatcher("/employee/my-payslip.jsp").forward(request, response);
                break;
            case "/delete":
                int delId = Integer.parseInt(request.getParameter("id"));
                payrollDAO.deletePayroll(delId);
                response.sendRedirect(request.getContextPath() + "/payroll/list");
                return;
            default:
                // Admin — list all payroll + load employees for form
                List<PayrollDTO> allPayroll = payrollDAO.getAllPayroll();
                List<EmployeeDTO> employees = employeeDAO.getAllEmployees();
                request.setAttribute("payrollList", allPayroll);
                request.setAttribute("employees", employees);
                request.getRequestDispatcher("/admin/payroll-generate.jsp").forward(request, response);
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

        String action = request.getPathInfo();
        if (action == null)
            action = "/generate";

        if ("/generate".equals(action) || "/add".equals(action)) {
            PayrollDTO payroll = new PayrollDTO();

            String empIdStr = request.getParameter("employeeId");
            if (empIdStr != null && !empIdStr.isEmpty())
                payroll.setEmployeeId(Integer.parseInt(empIdStr));

            payroll.setPayrollMonth(request.getParameter("payrollMonth"));

            String basicStr = request.getParameter("basicSalary");
            String bonusStr = request.getParameter("bonus");
            String deductionStr = request.getParameter("deduction");

            if (basicStr != null && !basicStr.isEmpty())
                payroll.setBasicSalary(Double.parseDouble(basicStr));
            if (bonusStr != null && !bonusStr.isEmpty())
                payroll.setBonus(Double.parseDouble(bonusStr));
            if (deductionStr != null && !deductionStr.isEmpty())
                payroll.setDeduction(Double.parseDouble(deductionStr));

            // net salary auto-calculated in DAOImp
            boolean success = payrollDAO.addPayroll(payroll);
            if (success) {
                session.setAttribute("successMsg", "Payroll generated successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to generate payroll.");
            }
            response.sendRedirect(request.getContextPath() + "/payroll/list");
        } else {
            doGet(request, response);
        }
    }
}
