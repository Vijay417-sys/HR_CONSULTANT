package com.hrdesk.utility;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtility {
    
    // Your Gmail SMTP settings
    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";
    private static final String USERNAME = "vijays.23.becs@acharya.ac.in";      
    private static final String PASSWORD = "duap dnvu nbib ckpf";         // CHANGE THIS (App Password, not Gmail password)
    
    public static boolean sendPayslipEmail(String toEmail, String employeeName, 
                                          String monthYear, String pdfPath) {
        
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.ssl.trust", HOST);
        
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, "HRDesk Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(monthYear + " Payslip - HRDesk");
            
            // Email body
            BodyPart messageBodyPart = new MimeBodyPart();
            String htmlBody = "<h2>HRDesk - Salary Slip</h2>"
                + "<p>Dear " + employeeName + ",</p>"
                + "<p>Your payslip for <b>" + monthYear + "</b> has been generated.</p>"
                + "<p>Please find the attached PDF for your records.</p>"
                + "<br><p>Regards,<br>HRDesk Team</p>";
            messageBodyPart.setContent(htmlBody, "text/html");
            
            // PDF attachment
            MimeBodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.attachFile(pdfPath);
            
            // Combine body + attachment
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            multipart.addBodyPart(attachmentPart);
            message.setContent(multipart);
            
            // Send email
            Transport.send(message);
            System.out.println("Payslip email sent to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}