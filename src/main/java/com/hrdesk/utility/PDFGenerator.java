package com.hrdesk.utility;

import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.dto.PayrollDTO;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.File;
import java.io.FileOutputStream;

public class PDFGenerator {
    
    // Save PDFs relative to app server (works on Linux & Windows)
    private static final String UPLOAD_PATH = System.getProperty("catalina.base") != null
            ? System.getProperty("catalina.base") + "/payslips/"
            : "payslips/";

    public static String generatePayslip(EmployeeDTO emp, PayrollDTO payroll) {

        String fileName = "Payslip_" + emp.getFullName().replace(" ", "_") + "_"
                        + payroll.getMonthYear() + ".pdf";
        String filePath = UPLOAD_PATH + fileName;

        // Create folder if not exists
        new File(UPLOAD_PATH).mkdirs();
        
        try {
            Document document = new Document();
            PdfWriter.getInstance(document, new FileOutputStream(filePath));
            document.open();
            
            // Company Header
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLUE);
            Paragraph header = new Paragraph("HRDesk - Salary Slip", headerFont);
            header.setAlignment(Element.ALIGN_CENTER);
            document.add(header);
            document.add(Chunk.NEWLINE);
            
            // Employee Details
            Font labelFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            Font valueFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
            
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);
            
            addTableRow(table, "Employee Name:", emp.getFullName(), labelFont, valueFont);
            addTableRow(table, "Email:", emp.getEmail(), labelFont, valueFont);
            addTableRow(table, "Department:", String.valueOf(emp.getDeptId()), labelFont, valueFont);
            addTableRow(table, "Month/Year:", payroll.getMonthYear(), labelFont, valueFont);
            
            document.add(table);
            document.add(Chunk.NEWLINE);
            
            // Salary Breakdown
            PdfPTable salaryTable = new PdfPTable(2);
            salaryTable.setWidthPercentage(100);
            
            addTableRow(salaryTable, "Basic Salary:", "₹" + payroll.getBasicSalary(), labelFont, valueFont);
            addTableRow(salaryTable, "Leave Deductions:", "- ₹" + payroll.getLeaveDeductions(), labelFont, valueFont);
            addTableRow(salaryTable, "Bonus:", "+ ₹" + payroll.getBonus(), labelFont, valueFont);
            
            // Net Salary (Highlighted)
            Font netFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.GREEN);
            PdfPCell netLabel = new PdfPCell(new Phrase("NET SALARY:", labelFont));
            PdfPCell netValue = new PdfPCell(new Phrase("₹" + payroll.getNetSalary(), netFont));
            netLabel.setPadding(10);
            netValue.setPadding(10);
            salaryTable.addCell(netLabel);
            salaryTable.addCell(netValue);
            
            document.add(salaryTable);
            
            // Footer
            document.add(Chunk.NEWLINE);
            Font footerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY);
            Paragraph footer = new Paragraph("This is a computer-generated payslip. No signature required.", footerFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            
            document.close();
            System.out.println("PDF generated: " + filePath);
            return filePath;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private static void addTableRow(PdfPTable table, String label, String value, 
                                   Font labelFont, Font valueFont) {
        PdfPCell cell1 = new PdfPCell(new Phrase(label, labelFont));
        PdfPCell cell2 = new PdfPCell(new Phrase(value, valueFont));
        cell1.setPadding(8);
        cell2.setPadding(8);
        table.addCell(cell1);
        table.addCell(cell2);
    }
}