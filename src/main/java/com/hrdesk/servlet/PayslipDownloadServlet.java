package com.hrdesk.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import com.hrdesk.dao.EmployeeDAO;
import com.hrdesk.dao.PayrollDAO;
import com.hrdesk.daoimp.EmployeeDAOImp;
import com.hrdesk.daoimp.PayrollDAOImp;
import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.dto.PayrollDTO;
import com.hrdesk.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/download-payslip")
public class PayslipDownloadServlet extends HttpServlet {

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
        String payrollIdStr = request.getParameter("payrollId");

        if (payrollIdStr == null || payrollIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/payroll?action=my");
            return;
        }

        try {
            int payrollId = Integer.parseInt(payrollIdStr);
            PayrollDTO payroll = payrollDAO.getPayrollById(payrollId);
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payslip not found");
                return;
            }

            // Security: employees can only download their own payslips
            if (!"ADMIN".equals(user.getRole()) && payroll.getEmployeeId() != user.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            EmployeeDTO emp = employeeDAO.getEmployeeById(payroll.getEmployeeId());
            if (emp == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Employee not found");
                return;
            }

            // Build PDF path (same format as PDFGenerator)
            String catalinaBase = System.getProperty("catalina.base");
            String payslipDir = (catalinaBase != null ? catalinaBase : ".") + "/payslips/";
            String fileName = "Payslip_" + emp.getFullName().replace(" ", "_") + "_"
                           + payroll.getPayrollMonth() + ".pdf";
            File pdfFile = new File(payslipDir + fileName);

            if (!pdfFile.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "PDF file not found. Generate payroll first.");
                return;
            }

            // Serve the file as download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength((int) pdfFile.length());

            try (FileInputStream fis = new FileInputStream(pdfFile);
                 OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid payroll ID");
        }
    }
}
