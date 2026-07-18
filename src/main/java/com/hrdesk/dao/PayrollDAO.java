package com.hrdesk.dao;

import java.util.List;

import com.hrdesk.dto.PayrollDTO;

public interface PayrollDAO {
	 boolean addPayroll(PayrollDTO payroll);

	    boolean updatePayroll(PayrollDTO payroll);

	    boolean deletePayroll(int payrollId);

	    PayrollDTO getPayrollById(int payrollId);

	    List<PayrollDTO> getPayrollByEmployee(int employeeId);

	    List<PayrollDTO> getAllPayroll();

}
