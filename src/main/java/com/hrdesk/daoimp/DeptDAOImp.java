package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.hrdesk.dao.DeptDAO;
import com.hrdesk.dto.DeptDTO;
import com.hrdesk.utility.Connector;

public class DeptDAOImp implements DeptDAO {

    private DeptDTO mapRow(ResultSet rs) throws SQLException {
        DeptDTO dept = new DeptDTO();
        dept.setDepartmentId(rs.getInt("dept_id"));
        dept.setDepartmentName(rs.getString("dept_name"));
        dept.setLocation(rs.getString("location"));
        return dept;
    }

    // ADD
    @Override
    public boolean addDepartment(DeptDTO dept) {
        String sql = "INSERT INTO departments (dept_name, location) VALUES (?, ?)";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dept.getDepartmentName());
            ps.setString(2, dept.getLocation());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE
    @Override
    public boolean updateDepartment(DeptDTO dept) {
        String sql = "UPDATE departments SET dept_name = ?, location = ? WHERE dept_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dept.getDepartmentName());
            ps.setString(2, dept.getLocation());
            ps.setInt(3, dept.getDepartmentId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    @Override
    public boolean deleteDepartment(int departmentId) {
        String sql = "DELETE FROM departments WHERE dept_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // GET BY ID
    @Override
    public DeptDTO getDepartmentById(int departmentId) {
        String sql = "SELECT * FROM departments WHERE dept_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
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
    public List<DeptDTO> getAllDepartments() {
        List<DeptDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY dept_id ASC";
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
