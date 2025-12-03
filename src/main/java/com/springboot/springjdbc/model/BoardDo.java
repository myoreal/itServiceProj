package com.springboot.springjdbc.model;

public class BoardDo {
    private int seq; 
    private String title;
    private String writer;
    private String content;
    private String category;
    private int voteCount;
    private String status;
    private String regDate;
    private int writerId;
    private String filename; 
    private int viewCount;
    private String updateDate;


	// Getter & Setter
    public int getSeq() { return seq; }
    public void setSeq(int seq) { this.seq = seq; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }
    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }
    public int getWriterId() { return writerId; }
    public void setWriterId(int writerId) { this.writerId = writerId; }
    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    public String getUpdateDate() {return updateDate;}
	public void setUpdateDate(String updateDate) {this.updateDate = updateDate;}
}