package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.hrdesk.dao.AttendanceDAO;
import com.hrdesk.dto.AttendanceDTO;
import com.hrdesk.utility.Connector;

public class AttendanceDAOImp implements AttendanceDAO {

    private AttendanceDTO mapRow(ResultSet rs) throws SQLException {
        AttendanceDTO att = new AttendanceDTO();
        att.setAttendanceId(rs.getInt("att_id"));
        att.setEmployeeId(rs.getInt("emp_id"));
        att.setAttendanceDate(rs.getDate("date"));
        att.setAttendanceStatus(rs.getString("status"));
        att.setCheckIn(rs.getTime("check_in"));
        att.setCheckOut(rs.getTime("check_out"));

        // Calculate working hours from check_in and check_out
        Time ci = rs.getTime("check_in");
        Time co = rs.getTime("check_out"); // CHECKOUT
        if (ci != null && co != null) {
            long diff = co.getTime() - ci.getTime();
            if (diff > 0)
                att.setWorkingHours(diff / 3600000.0);
        }
        return att;
    }

    // MARK (INSERT or UPDATE if already exists for same employee + date)
    @Override
    public boolean markAttendance(AttendanceDTO att) {
        String sql = "INSERT INTO attendance (emp_id, date, status, check_in, check_out) VALUES (?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE status = VALUES(status), check_in = VALUES(check_in), check_out = VALUES(check_out)";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, att.getEmployeeId());
            ps.setDate(2, att.getAttendanceDate() != null
                    ? new java.sql.Date(att.getAttendanceDate().getTime())
                    : null);
            ps.setString(3, att.getAttendanceStatus() != null ? att.getAttendanceStatus() : "PRESENT");
            ps.setTime(4, att.getCheckIn());
            ps.setTime(5, att.getCheckOut());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE
    @Override
    public boolean updateAttendance(AttendanceDTO att) {
        String sql = "UPDATE attendance SET date = ?, status = ?, check_in = ?, check_out = ? WHERE att_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, att.getAttendanceDate() != null
                    ? new java.sql.Date(att.getAttendanceDate().getTime())
                    : null);
            ps.setString(2, att.getAttendanceStatus());
            ps.setTime(3, att.getCheckIn());
            ps.setTime(4, att.getCheckOut());
            ps.setInt(5, att.getAttendanceId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    @Override
    public boolean deleteAttendance(int attendanceId) {
        String sql = "DELETE FROM attendance WHERE att_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, attendanceId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // GET BY ID
    @Override
    public AttendanceDTO getAttendanceById(int attendanceId) {
        String sql = "SELECT * FROM attendance WHERE att_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, attendanceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET BY
    // EMPLOYEE
    @Override
    public List<AttendanceDTO> getAttendanceByEmployee(int employeeId) {
        List<AttendanceDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE emp_id = ? ORDER BY date DESC";
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

    // GET BY
    // DATE
    @Override
    public List<AttendanceDTO> getAttendanceByDate(Date attendanceDate) {
        List<AttendanceDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE date = ? ORDER BY emp_id ASC";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, new java.sql.Date(attendanceDate.getTime()));
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
    public List<AttendanceDTO> getAllAttendance() {
        List<AttendanceDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance ORDER BY date DESC, emp_id ASC";
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
