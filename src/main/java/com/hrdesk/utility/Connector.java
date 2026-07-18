package com.hrdesk.utility;

import java.sql.Connection;
import java.sql.DriverManager;

public class Connector {

    private static final String URL = "jdbc:mysql://localhost:3306/hrdesk_db";
    private static final String DB_USER = "root";
    private static final String PASSWORD = "Rashivu@246";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(URL, DB_USER, PASSWORD);
            return con;
        } catch (Exception e) {
            System.err.println("[Connector] DB connection failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
