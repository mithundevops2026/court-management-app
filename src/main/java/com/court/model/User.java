package com.court.model;

import java.io.Serializable;

/**
 * Represents authenticated Court personnel (e.g., Judge/Clerk).
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String fullName;
    private String role;
    private String chamber;
    private String courtroom;

    public User() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getChamber() { return chamber; }
    public void setChamber(String chamber) { this.chamber = chamber; }

    public String getCourtroom() { return courtroom; }
    public void setCourtroom(String courtroom) { this.courtroom = courtroom; }
}