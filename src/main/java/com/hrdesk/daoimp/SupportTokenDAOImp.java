package com.hrdesk.daoimp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.hrdesk.dao.SupportTokenDAO;
import com.hrdesk.dto.SupportTokenDTO;
import com.hrdesk.utility.Connector;

public class SupportTokenDAOImp implements SupportTokenDAO {

    private SupportTokenDTO mapRow(ResultSet rs) throws SQLException {
        SupportTokenDTO t = new SupportTokenDTO();
        t.setTokenId(rs.getInt("token_id"));
        t.setEmpId(rs.getInt("emp_id"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setCategory(rs.getString("category"));
        t.setPriority(rs.getString("priority"));
        t.setStatus(rs.getString("status"));
        t.setAssignedTo(rs.getInt("assigned_to"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setResolvedAt(rs.getTimestamp("resolved_at"));
        return t;
    }

    // CREATE
    @Override
    public boolean createToken(SupportTokenDTO token) {
        String sql = "INSERT INTO support_tokens (emp_id, title, description, category, priority, status) " +
                "VALUES (?, ?, ?, ?, ?, 'OPEN')";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, token.getEmpId());
            ps.setString(2, token.getTitle());
            ps.setString(3, token.getDescription());
            ps.setString(4, token.getCategory() != null ? token.getCategory() : "OTHER");
            ps.setString(5, token.getPriority() != null ? token.getPriority() : "MEDIUM");
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE FULL
    @Override
    public boolean updateToken(SupportTokenDTO token) {
        String sql = "UPDATE support_tokens SET title = ?, description = ?, category = ?, priority = ?, " +
                "status = ?, assigned_to = ? WHERE token_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token.getTitle());
            ps.setString(2, token.getDescription());
            ps.setString(3, token.getCategory());
            ps.setString(4, token.getPriority());
            ps.setString(5, token.getStatus());
            if (token.getAssignedTo() > 0)
                ps.setInt(6, token.getAssignedTo());
            else
                ps.setNull(6, Types.INTEGER);
            ps.setInt(7, token.getTokenId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    @Override
    public boolean deleteToken(int tokenId) {
        String sql = "DELETE FROM support_tokens WHERE token_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, tokenId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // GET BY ID
    @Override
    public SupportTokenDTO getTokenById(int tokenId) {
        String sql = "SELECT * FROM support_tokens WHERE token_id = ?";
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, tokenId);
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
    public List<SupportTokenDTO> getTokensByEmployee(int employeeId) {
        List<SupportTokenDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM support_tokens WHERE emp_id = ? ORDER BY created_at DESC";
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
    public List<SupportTokenDTO> getTokensByStatus(String status) {
        List<SupportTokenDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM support_tokens WHERE status = ? ORDER BY created_at DESC";
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
    public List<SupportTokenDTO> getAllTokens() {
        List<SupportTokenDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM support_tokens ORDER BY created_at DESC";
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
    public boolean updateTokenStatus(int tokenId, String status) {
        String sql;
        if ("RESOLVED".equals(status) || "CLOSED".equals(status)) {
            sql = "UPDATE support_tokens SET status = ?, resolved_at = NOW() WHERE token_id = ?";
        } else {
            sql = "UPDATE support_tokens SET status = ? WHERE token_id = ?";
        }
        try (Connection con = Connector.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, tokenId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
