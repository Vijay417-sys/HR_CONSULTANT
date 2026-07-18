package com.hrdesk.dao;

import java.util.List;

import com.hrdesk.dto.SupportTokenDTO;

public interface SupportTokenDAO {

    boolean createToken(SupportTokenDTO token);

    boolean updateToken(SupportTokenDTO token);

    boolean deleteToken(int tokenId);

    SupportTokenDTO getTokenById(int tokenId);

    List<SupportTokenDTO> getTokensByEmployee(int employeeId);

    List<SupportTokenDTO> getTokensByStatus(String status);

    List<SupportTokenDTO> getAllTokens();

    boolean updateTokenStatus(int tokenId, String status);

}
