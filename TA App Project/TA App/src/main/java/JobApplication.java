public class JobApplication {
   
	private String courseId;
    private String username;
    private String resume;
    private String hasServedAsTA;
    private String relevantCourses;
    private String otherCourses;
    public String getOtherCourses() {
		return otherCourses;
	}
	public void setOtherCourses(String otherCourses) {
		this.otherCourses = otherCourses;
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

                    formattedCourses.append("Course ").append(courseName).append("\n");
                    formattedCourses.append("From date ").append(fromDate).append(" To date ").append(toDate).append("\n");
                }
            }
        }

        return formattedCourses.toString();
    }

    // Getters and setters
}