package com.hrdesk.dto;

import java.sql.Timestamp;

public class SupportTokenDTO {

    private int tokenId;
    private int empId;
    private String title;
    private String description;
    private String category;   // HARDWARE, SOFTWARE, NETWORK, ACCESSORY, OTHER
    private String priority;   // LOW, MEDIUM, HIGH, URGENT
    private String status;     // OPEN, IN_PROGRESS, RESOLVED, CLOSED
    private int assignedTo;
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    // Getters & Setters
    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }

    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getAssignedTo() { return assignedTo; }
    public void setAssignedTo(int assignedTo) { this.assignedTo = assignedTo; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    @Override
    public String toString() {
        return "SupportToken [tokenId=" + tokenId + ", empId=" + empId + ", title=" + title
                + ", category=" + category + ", priority=" + priority + ", status=" + status + "]";
    }
}
