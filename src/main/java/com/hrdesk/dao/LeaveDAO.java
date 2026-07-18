package com.hrdesk.dao;

import java.util.List;

import com.hrdesk.dto.LeaveDTO;

public interface LeaveDAO {

    boolean applyLeave(LeaveDTO leave);

    boolean updateLeave(LeaveDTO leave);

    boolean deleteLeave(int leaveId);

    LeaveDTO getLeaveById(int leaveId);

    List<LeaveDTO> getLeavesByEmployee(int employeeId);

    List<LeaveDTO> getLeavesByStatus(String status);

    List<LeaveDTO> getAllLeaves();

    boolean updateLeaveStatus(int leaveId, String status);

}
