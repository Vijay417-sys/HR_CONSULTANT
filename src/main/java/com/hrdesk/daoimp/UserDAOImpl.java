package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.hrdesk.dao.UserDAO;
import com.hrdesk.dto.User;
import com.hrdesk.utility.Connector;


public class UserDAOImpl implements UserDAO {

    //  REGISTER
    @Override
    public boolean registerUser(User user) {
        Connection con = Connector.getConnection();
        if (con == null) {
            System.err.println("[UserDAOImpl] registerUser: DB connection is null");
            return false;
        }
        String sql = "INSERT INTO employees (full_name, email, password_hash, role, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());           // full_name
            ps.setString(2, user.getEmail());              // email  ← separate field
            ps.setString(3, user.getPassword());           // password_hash
            ps.setString(4, user.getRole() != null ? user.getRole() : "EMPLOYEE");

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] registerUser SQL error: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    //  LOGIN
    @Override
    public User login(String username, String password) {
        Connection con = Connector.getConnection();
        if (con == null) {
            System.err.println("[UserDAOImpl] login: DB connection is null");
            return null;
        }
        // Accept login by email
        String sql = "SELECT emp_id, full_name, email, password_hash, role FROM employees WHERE email = ? AND password_hash = ? AND status = 'ACTIVE'";
        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("emp_id"));
                user.setEmployeeId(rs.getInt("emp_id"));
                user.setUsername(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
                return user;
            }

        } catch (SQLException e) {
            System.err.println("[UserDAOImpl] login SQL error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
        return null;
    }

    //  UPDATE
    @Override
    public boolean updateUser(User user) {
        Connection con = Connector.getConnection();
        if (con == null) return false;
        String sql = "UPDATE employees SET email = ?, password_hash = ?, role = ? WHERE emp_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setInt(4, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    //  DELETE
    @Override
    public boolean deleteUser(int userId) {
        Connection con = Connector.getConnection();
        if (con == null) return false;
        String sql = "DELETE FROM employees WHERE emp_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    //  GET BY ID
    @Override
    public User getUserById(int userId) {
        Connection con = Connector.getConnection();
        if (con == null) return null;
        String sql = "SELECT emp_id, full_name, email, password_hash, role FROM employees WHERE emp_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("emp_id"));
                user.setEmployeeId(rs.getInt("emp_id"));
                user.setUsername(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
        return null;
    }

    //  GET ALL
    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        Connection con = Connector.getConnection();
        if (con == null) return users;
        String sql = "SELECT emp_id, full_name, email, password_hash, role FROM employees ORDER BY emp_id DESC";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("emp_id"));
                user.setEmployeeId(rs.getInt("emp_id"));
                user.setUsername(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
        return users;
    }
}
