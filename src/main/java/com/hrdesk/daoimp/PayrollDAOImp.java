package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.hrdesk.dao.PayrollDAO;
import com.hrdesk.dto.PayrollDTO;
import com.hrdesk.utility.Connector;


public class PayrollDAOImp implements PayrollDAO {

    // Helper to map ResultSet row → PayrollDTO
    private PayrollDTO mapRow(ResultSet rs) throws SQLException {
        PayrollDTO p = new PayrollDTO();
        p.setPayrollId(rs.getInt("payroll_id"));
        p.setEmployeeId(rs.getInt("emp_id"));
        p.setPayrollMonth(rs.getString("month_year"));
        p.setBasicSalary(rs.getDouble("basic_salary"));
        p.setDeduction(rs.getDouble("leave_deductions"));
        p.setBonus(rs.getDouble("bonus"));
        p.setNetSalary(rs.getDouble("net_salary"));
        p.setPaymentDate(rs.getTimestamp("generated_at"));
        return p;
    }

    //  ADD
    @Override
    public boolean addPayroll(PayrollDTO payroll) {
        String sql = "INSERT INTO payroll (emp_id, month_year, basic_salary, leave_deductions, bonus, net_salary) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = Connector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payroll.getEmployeeId());
            ps.setString(2, payroll.getPayrollMonth());
            ps.setDouble(3, payroll.getBasicSalary());
            ps.setDouble(4, payroll.getDeduction());
            ps.setDouble(5, payroll.getBonus());
            // auto-calculate net if not set
            double net = payroll.getNetSalary() > 0
                    ? payroll.getNetSalary()
                    : payroll.getBasicSalary() + payroll.getBonus() - payroll.getDeduction();
            ps.setDouble(6, net);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //  UPDATE
    @Override
    public boolean updatePayroll(PayrollDTO payroll) {
        String sql = "UPDATE payroll SET month_year = ?, basic_salary = ?, leave_deductions = ?, bonus = ?, net_salary = ? " +
                     "WHERE payroll_id = ?";
        try (Connection con = Connector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, payroll.getPayrollMonth());
            ps.setDouble(2, payroll.getBasicSalary());
            ps.setDouble(3, payroll.getDeduction());
            ps.setDouble(4, payroll.getBonus());
            double net = payroll.getNetSalary() > 0
                    ? payroll.getNetSalary()
                    : payroll.getBasicSalary() + payroll.getBonus() - payroll.getDeduction();
            ps.setDouble(5, net);
            ps.setInt(6, payroll.getPayrollId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //  DELETE
    @Override
    public boolean deletePayroll(int payrollId) {
        String sql = "DELETE FROM payroll WHERE payroll_id = ?";
        try (Connection con = Connector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payrollId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //  GET BY ID
    @Override
    public PayrollDTO getPayrollById(int payrollId) {
        String sql = "SELECT * FROM payroll WHERE payroll_id = ?";
        try (Connection con = Connector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payrollId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //  GET BY EMPLOYEE
    @Override
    public List<PayrollDTO> getPayrollByEmployee(int employeeId) {
        List<PayrollDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM payroll WHERE emp_id = ? ORDER BY generated_at DESC";
        try (Connection con = Connector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //  GET ALL
    @Override
    public List<PayrollDTO> getAllPayroll() {
        List<PayrollDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM payroll ORDER BY generated_at DESC";
        try (Connection con = Connector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
