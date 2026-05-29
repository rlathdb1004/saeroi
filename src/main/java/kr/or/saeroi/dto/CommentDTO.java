package kr.or.saeroi.dto;

public class CommentDTO {
	
	private int comment_id;
	private int board_id;
	private Integer parent_comment_id;
	private int emp_id;
	private String empno;
	private String ename;
	private String content;
	private String created_date;
	private String updated_date;
	private String status;
	private String use_yn;
	private String remark;
	private String dept;
	private int comment_level;
	private int comment_indent;
	public int getComment_id() {
		return comment_id;
	}
	public void setComment_id(int comment_id) {
		this.comment_id = comment_id;
	}
	public int getBoard_id() {
		return board_id;
	}
	public void setBoard_id(int board_id) {
		this.board_id = board_id;
	}
	public Integer getParent_comment_id() {
		return parent_comment_id;
	}
	public void setParent_comment_id(Integer parent_comment_id) {
		this.parent_comment_id = parent_comment_id;
	}
	public int getEmp_id() {
		return emp_id;
	}
	public void setEmp_id(int emp_id) {
		this.emp_id = emp_id;
	}
	public String getEmpno() {
		return empno;
	}
	public void setEmpno(String empno) {
		this.empno = empno;
	}
	public String getEname() {
		return ename;
	}
	public void setEname(String ename) {
		this.ename = ename;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCreated_date() {
		return created_date;
	}
	public void setCreated_date(String created_date) {
		this.created_date = created_date;
	}
	public String getUpdated_date() {
		return updated_date;
	}
	public void setUpdated_date(String updated_date) {
		this.updated_date = updated_date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public int getComment_level() {
		return comment_level;
	}
	public void setComment_level(int comment_level) {
		this.comment_level = comment_level;
	}
	public int getComment_indent() {
		return comment_indent;
	}
	public void setComment_indent(int comment_indent) {
		this.comment_indent = comment_indent;
	}
	@Override
	public String toString() {
		return "CommentDTO [comment_id=" + comment_id + ", board_id=" + board_id + ", parent_comment_id="
				+ parent_comment_id + ", emp_id=" + emp_id + ", empno=" + empno + ", ename=" + ename + ", content="
				+ content + ", created_date=" + created_date + ", updated_date=" + updated_date + ", status=" + status
				+ ", use_yn=" + use_yn + ", remark=" + remark + ", dept=" + dept + ", comment_level=" + comment_level
				+ ", comment_indent=" + comment_indent + "]";
	}

	
	
}
