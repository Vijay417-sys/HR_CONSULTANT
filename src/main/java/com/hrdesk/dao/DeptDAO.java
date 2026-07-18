package com.hrdesk.dao;

import java.util.List;

import com.hrdesk.dto.DeptDTO;

public interface DeptDAO {
	boolean addDepartment(DeptDTO department);

    boolean updateDepartment(DeptDTO department);

    boolean deleteDepartment(int departmentId);

    DeptDTO getDepartmentById(int departmentId);

    List<DeptDTO> getAllDepartments();

}
