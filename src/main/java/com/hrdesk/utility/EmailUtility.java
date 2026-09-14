package com.hrdesk.utility;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.BodyPart;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import java.util.Properties;

public class EmailUtility {

    // Read from environment variables; fall back to safe defaults / blanks.
    // Locally: set these in your .env file (docker run --env-file .env)
    // In production: injected via GitHub Secrets -> docker run -e
    private static final String HOST =
            System.getenv().getOrDefault("MAIL_HOST", "smtp.gmail.com");
    private static final String PORT =
            System.getenv().getOrDefault("MAIL_PORT", "587");
    private static final String USERNAME =
            System.getenv().getOrDefault("MAIL_USER", "");
    private static final String PASSWORD =
            System.getenv().getOrDefault("MAIL_PASSWORD", "");

    public static boolean sendPayslipEmail(String toEmail, String employeeName,
            String monthYear, String pdfPath) {

        // Fail fast if mail credentials are not configured
        if (USERNAME.isBlank() || PASSWORD.isBlank()) {
            System.err.println("[EmailUtility] MAIL_USER / MAIL_PASSWORD not set. "
                    + "Skipping email to: " + toEmail);
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.ssl.trust", HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
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
            System.err.println("[EmailUtility] Failed to send payslip email to "
                    + toEmail + ": " + e.getMessage());
            return false;
        }
    }
}