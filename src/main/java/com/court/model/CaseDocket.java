package com.court.model;

import java.io.Serializable;

/**
 * Model class covering specific court case details.
 */
public class CaseDocket implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String caseNumber;
    private String title;
    private String type;
    private String priority;
    private String status;
    private String hearingDate;
    private String courtroom;
    private String description;
    private String latestUpdate;

    public CaseDocket() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCaseNumber() { return caseNumber; }
    public void setCaseNumber(String caseNumber) { this.caseNumber = caseNumber; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getHearingDate() { return hearingDate; }
    public void setHearingDate(String hearingDate) { this.hearingDate = hearingDate; }

    public String getCourtroom() { return courtroom; }
    public void setCourtroom(String courtroom) { this.courtroom = courtroom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLatestUpdate() { return latestUpdate; }
    public void setLatestUpdate(String latestUpdate) { this.latestUpdate = latestUpdate; }
}