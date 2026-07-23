package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.hrdesk.dao.LeaveDAO;
import com.hrdesk.dto.LeaveDTO;
import com.hrdesk.utility.Connector;

public class LeaveDAOImp implements LeaveDAO {

    // Helper to map ResultSet row → LeaveDTO
    private LeaveDTO mapRow(ResultSet rs) throws SQLException {
        LeaveDTO leave = new LeaveDTO();
        leave.setLeaveId(rs.getInt("leave_id"));
        leave.setEmployeeId(rs.getInt("emp_id"));
        leave.setLeaveType(rs.getString("leave_type"));
        leave.setFromDate(rs.getDate("start_date"));
        leave.setToDate(rs.getDate("end_date"));
        leave.setReason(rs.getString("reason"));
        leave.setLeaveStatus(rs.getString("status"));
        return leave;
    }

    // APPLY
    @Override
    public boolean applyLeave(LeaveDTO leave) {
        String sql = "INSERT INTO leave_requests (emp_id, leave_type, start_date, end_date, reason, status) " +
                "VALUES (?, ?, ?, ?, ?, 'PENDING')";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, leave.getEmployeeId());
            ps.setString(2, leave.getLeaveType());
            ps.setDate(3, leave.getFromDate() != null ? new java.sql.Date(leave.getFromDate().getTime()) : null);
            ps.setDate(4, leave.getToDate() != null ? new java.sql.Date(leave.getToDate().getTime()) : null);
            ps.setString(5, leave.getReason());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE FULL
    @Override
    public boolean updateLeave(LeaveDTO leave) {
        String sql = "UPDATE leave_requests SET leave_type = ?, start_date = ?, end_date = ?, reason = ?, status = ? WHERE leave_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, leave.getLeaveType());
            ps.setDate(2, leave.getFromDate() != null ? new java.sql.Date(leave.getFromDate().getTime()) : null);
            ps.setDate(3, leave.getToDate() != null ? new java.sql.Date(leave.getToDate().getTime()) : null);
            ps.setString(4, leave.getReason());
            ps.setString(5, leave.getLeaveStatus());
            ps.setInt(6, leave.getLeaveId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    @Override
    public boolean deleteLeave(int leaveId) {
        String sql = "DELETE FROM leave_requests WHERE leave_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, leaveId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // GET BY ID
    @Override
    public LeaveDTO getLeaveById(int leaveId) {
        String sql = "SELECT * FROM leave_requests WHERE leave_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, leaveId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET BY EMPLOYEE
    @Override
    public List<LeaveDTO> getLeavesByEmployee(int employeeId) {
        List<LeaveDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM leave_requests WHERE emp_id = ? ORDER BY applied_at DESC";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET BY STATUS
    @Override
    public List<LeaveDTO> getLeavesByStatus(String status) {
        List<LeaveDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM leave_requests WHERE status = ? ORDER BY applied_at DESC";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET ALL
    @Override
    public List<LeaveDTO> getAllLeaves() {
        List<LeaveDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM leave_requests ORDER BY applied_at DESC";
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

    // UPDATE STATUS ONLY
    @Override
    public boolean updateLeaveStatus(int leaveId, String status) {
        String sql = "UPDATE leave_requests SET status = ? WHERE leave_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, leaveId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
	@Override
	public int countLeaveDays(int empId, String monthYear) {
		String sql = "SELECT COUNT(*) FROM leave_requests WHERE emp_id = ? AND status = 'APPROVED' AND DATE_FORMAT(start_date, '%Y-%m') = ?";
		try (Connection con = Connector.getConnection();
		     PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, empId);
			ps.setString(2, monthYear);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) return rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
}
