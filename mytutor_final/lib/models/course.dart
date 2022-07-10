class Course {
  String? courseId;
  String? courseName;
  String? courseDescription;
  String? coursePrice;
  String? tutorId;
  String? courseSessions;
  String? courseRating;
  String? courseQty;

  Course(
      {this.courseId,
      this.courseName,
      this.courseDescription,
      this.coursePrice,
      this.tutorId,
      this.courseSessions,
      this.courseRating,
      this.courseQty
      });

  Course.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    courseName = json['course_name'];
    courseDescription = json['course_description'];
    coursePrice = json['course_price'];
    tutorId = json['tutor_id'];
    courseSessions = json['course_sessions'];
    courseRating = json['course_rating'];
    courseQty = json['course_qty'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_id'] = courseId;
    data['course_name'] = courseName;
    data['course_description'] = courseDescription;
    data['course_price'] = coursePrice;
    data['tutor_id'] = tutorId;
    data['course_sessions'] = courseSessions;
    data['course_rating'] = courseRating;
    data['course_qty'] = courseQty;
    return data;
  }
}