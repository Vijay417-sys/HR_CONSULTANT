package com.hrdesk.utility;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class Connector {

    private static final Properties props = new Properties();

    static {
        load("db.properties"); // committed defaults (no real secrets)
        load("db.local.properties"); // local overrides — gitignored
    }

    private static void load(String name) {
        try (InputStream in = Connector.class.getClassLoader().getResourceAsStream(name)) {
            if (in != null)
                props.load(in);
        } catch (Exception ignored) {
        }
    }

    // env var wins, then properties file
    private static String get(String key) {
        String env = System.getenv(key);
        return (env != null && !env.isBlank()) ? env : props.getProperty(key, "");
    }

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(get("DB_URL"), get("DB_USER"), get("DB_PASSWORD"));
        } catch (Exception e) {
            System.err.println("[Connector] DB connection failed: " + e.getMessage());
            return null;
        }
    }
}