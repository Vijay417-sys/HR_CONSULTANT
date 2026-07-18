package com.hrdesk.dto;

public class DeptDTO {
	 private int departmentId;
	    private String departmentName;
	    private String location;
	    
		public int getDepartmentId() {
			return departmentId;
		}
		public void setDepartmentId(int departmentId) {
			this.departmentId = departmentId;
		}
		public String getDepartmentName() {
			return departmentName;
		}
		public void setDepartmentName(String departmentName) {
			this.departmentName = departmentName;
		}
		public String getLocation() {
			return location;
		}
		public void setLocation(String location) {
			this.location = location;
		}
		@Override
		public String toString() {
			return "Department [departmentId=" + departmentId + ", departmentName=" + departmentName + ", location="
					+ location + "]";
		}
}
