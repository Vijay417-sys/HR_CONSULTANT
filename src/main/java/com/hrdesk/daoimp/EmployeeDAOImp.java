package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.hrdesk.dao.EmployeeDAO;
import com.hrdesk.dto.EmployeeDTO;
import com.hrdesk.utility.Connector;

public class EmployeeDAOImp implements EmployeeDAO {

    private EmployeeDTO mapRow(ResultSet rs) throws SQLException {
        EmployeeDTO emp = new EmployeeDTO();
        emp.setEmployeeId(rs.getInt("emp_id"));
        emp.setDepartmentId(rs.getInt("dept_id"));
        String fullName = rs.getString("full_name");
        if (fullName != null) {
            int spaceIdx = fullName.indexOf(' ');
            if (spaceIdx > 0) {
                emp.setFirstName(fullName.substring(0, spaceIdx));
                emp.setLastName(fullName.substring(spaceIdx + 1));
            } else {
                emp.setFirstName(fullName);
                emp.setLastName("");
            }
        }
        emp.setEmail(rs.getString("email"));
        emp.setPhone(rs.getString("phone"));
        emp.setDesignation(rs.getString("role")); // using role as designation proxy
        emp.setHireDate(rs.getDate("hire_date"));
        emp.setSalary(rs.getDouble("salary"));
        emp.setStatus(rs.getString("status"));
        return emp;
    }

    // ADD
    @Override
    public boolean addEmployee(EmployeeDTO emp) {
        String sql = "INSERT INTO employees (full_name, email, phone, hire_date, salary, dept_id, role, password_hash, status) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE')";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String fullName = (emp.getFirstName() != null ? emp.getFirstName() : "")
                    + (emp.getLastName() != null && !emp.getLastName().isEmpty() ? " " + emp.getLastName() : "");
            ps.setString(1, fullName.trim());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getPhone());
            ps.setDate(4, emp.getHireDate() != null ? new java.sql.Date(emp.getHireDate().getTime()) : null);
            ps.setDouble(5, emp.getSalary());
            ps.setInt(6, emp.getDepartmentId());
            ps.setString(7, emp.getDesignation() != null ? emp.getDesignation() : "EMPLOYEE");
            ps.setString(8, emp.getQrCode() != null ? emp.getQrCode() : "changeme123"); // temp default password

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE
    @Override
    public boolean updateEmployee(EmployeeDTO emp) {
        String sql = "UPDATE employees SET full_name = ?, email = ?, phone = ?, hire_date = ?, salary = ?, dept_id = ?, status = ? WHERE emp_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String fullName = (emp.getFirstName() != null ? emp.getFirstName() : "")
                    + (emp.getLastName() != null && !emp.getLastName().isEmpty() ? " " + emp.getLastName() : "");
            ps.setString(1, fullName.trim());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getPhone());
            ps.setDate(4, emp.getHireDate() != null ? new java.sql.Date(emp.getHireDate().getTime()) : null);
            ps.setDouble(5, emp.getSalary());
            ps.setInt(6, emp.getDepartmentId());
            ps.setString(7, emp.getStatus() != null ? emp.getStatus() : "ACTIVE");
            ps.setInt(8, emp.getEmployeeId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    @Override
    public boolean deleteEmployee(int employeeId) {
        String sql = "DELETE FROM employees WHERE emp_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // GET BY ID
    @Override
    public EmployeeDTO getEmployeeById(int employeeId) {
        String sql = "SELECT * FROM employees WHERE emp_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL
    @Override
    public List<EmployeeDTO> getAllEmployees() {
        List<EmployeeDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY emp_id DESC";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                list.add(mapRow(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
