package com.hrdesk.dto;

import java.sql.Time;
import java.util.Date;

public class AttendanceDTO {
	private int attendanceId;
	private int employeeId;
	private Date attendanceDate;
	private Time checkIn;
	private Time checkOut;
	private double workingHours;
	private String attendanceStatus;
	
	
	public int getAttendanceId() {
		return attendanceId;
	}
	public void setAttendanceId(int attendanceId) {
		this.attendanceId = attendanceId;
	}
	public int getEmployeeId() {
		return employeeId;
	}
	public void setEmployeeId(int employeeId) {
		this.employeeId = employeeId;
	}
	public Date getAttendanceDate() {
		return attendanceDate;
	}
	public void setAttendanceDate(Date attendanceDate) {
		this.attendanceDate = attendanceDate;
	}
	public Time getCheckIn() {
		return checkIn;
	}
	public void setCheckIn(Time checkIn) {
		this.checkIn = checkIn;
	}
	public Time getCheckOut() {
		return checkOut;
	}
	public void setCheckOut(Time checkOut) {
		this.checkOut = checkOut;
	}
	
	public double getWorkingHours() {
		return workingHours;
	}
	public void setWorkingHours(double workingHours) {
		this.workingHours = workingHours;
	}
	public String getAttendanceStatus() {
		return attendanceStatus;
	}
	public void setAttendanceStatus(String attendanceStatus) {
		this.attendanceStatus = attendanceStatus;
	}
	@Override
	public String toString() {
		return "Attendance [attendanceId=" + attendanceId + ", employeeId=" + employeeId + ", attendanceDate="
				+ attendanceDate + ", checkIn=" + checkIn + ", checkOut=" + checkOut + ", workingHours=" + workingHours
				+ ", attendanceStatus=" + attendanceStatus + "]";
	}
	

}
