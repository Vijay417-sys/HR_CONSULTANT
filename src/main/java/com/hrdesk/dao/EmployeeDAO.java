package com.hrdesk.dao;

import java.util.List;

import com.hrdesk.dto.EmployeeDTO;

public interface EmployeeDAO {
	boolean addEmployee(EmployeeDTO employee);

    boolean updateEmployee(EmployeeDTO employee);

    boolean deleteEmployee(int employeeId);

    EmployeeDTO getEmployeeById(int employeeId);

    List<EmployeeDTO> getAllEmployees();

}
