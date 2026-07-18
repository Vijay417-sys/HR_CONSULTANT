package com.hrdesk.dao;

import java.util.Date;
import java.util.List;

import com.hrdesk.dto.AttendanceDTO;

public interface AttendanceDAO {
	boolean markAttendance(AttendanceDTO attendance);

    boolean updateAttendance(AttendanceDTO attendance);

    boolean deleteAttendance(int attendanceId);

    AttendanceDTO getAttendanceById(int attendanceId);

    List<AttendanceDTO> getAttendanceByEmployee(int employeeId);

    List<AttendanceDTO> getAttendanceByDate(Date attendanceDate);

    List<AttendanceDTO> getAllAttendance();

}
