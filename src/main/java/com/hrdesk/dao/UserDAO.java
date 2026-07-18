package com.hrdesk.dao;

import java.util.List;

import com.hrdesk.dto.User;

public interface UserDAO {
	 boolean registerUser(User user);

	    User login(String username, String password);

	    boolean updateUser(User user);

	    boolean deleteUser(int userId);

	    User getUserById(int userId);

	    List<User> getAllUsers();

}
