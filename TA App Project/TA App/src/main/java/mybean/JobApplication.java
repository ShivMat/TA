package mybean;
public class JobApplication {
   
	private String courseId;
    private String username;
    private String resume;
    private String hasServedAsTA;
    private String relevantCourses;
    private String otherCourses;
    private String status;
    
    public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getOtherCourses() {
		return otherCourses;
	}
	public void setOtherCourses(String otherCourses) {
		this.otherCourses = otherCourses;
	}

	

	private String application_id;
    private String dateAdded;
    
    public String getApplication_id() {
		return application_id;
	}
	public void setApplication_id(String application_id) {
		this.application_id = application_id;
	}
	public String getDateAdded() {
		return dateAdded;
	}
	public void setDateAdded(String dateAdded) {
		this.dateAdded = dateAdded;
	}

    
  
	public String getCourseId() {
		return courseId;
	}
	public void setCourseId(String courseId) {
		this.courseId = courseId;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getResume() {
		return resume;
	}
	public void setResume(String resume) {
		this.resume = resume;
	}
	public String getHasServedAsTA() {
		return hasServedAsTA;
	}
	public void setHasServedAsTA(String hasServedAsTA) {
		this.hasServedAsTA = hasServedAsTA;
	}
	public String getRelevantCourses() {
		return relevantCourses;
	}
	public void setRelevantCourses(String relevantCourses) {
		this.relevantCourses = relevantCourses;
	}

	public String formatRelevantCourses() {
        StringBuilder formattedCourses = new StringBuilder();

        if (relevantCourses != null && !relevantCourses.isEmpty()) {
            String[] coursesArray = relevantCourses.split(";");
            for (String course : coursesArray) {
                String[] courseDetails = course.split(",");
                if (courseDetails.length == 3) {
                    String courseName = courseDetails[0];
                    String fromDate = courseDetails[1];
                    String toDate = courseDetails[2];

                    formattedCourses.append("<ul><li><strong>Course ").append(courseName).append("</strong><br>");
                    formattedCourses.append("<strong>From date</strong> ").append(fromDate).append(" <br><strong>To date</strong> ").append(toDate).append("</li></ul><br>");
                }
            }
        }

        return formattedCourses.toString();
    }



    // Getters and setters
}