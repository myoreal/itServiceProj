package com.springboot.springjdbc.model;

public class ReplyDo {
    private int r_no;
    private int b_no;
    private String r_writer;
    private String r_content;
    private String r_reg_date;
    private int rWriterId;

    // Getter & Setter
    public int getR_no() { return r_no; }
    public void setR_no(int r_no) { this.r_no = r_no; }
    public int getB_no() { return b_no; }
    public void setB_no(int b_no) { this.b_no = b_no; }
    public String getR_writer() { return r_writer; }
    public void setR_writer(String r_writer) { this.r_writer = r_writer; }
    public String getR_content() { return r_content; }
    public void setR_content(String r_content) { this.r_content = r_content; }
    public String getR_reg_date() { return r_reg_date; }
    public void setR_reg_date(String r_reg_date) { this.r_reg_date = r_reg_date; }
    public int getrWriterId() { return rWriterId; }
    public void setrWriterId(int rWriterId) { this.rWriterId = rWriterId; }

}