#lang forge/froglet


/*
This file contains the model for the allocation of TAs to courses for hiring
*/ 


// sig that can be used to determine if a condition is true or false
abstract sig Boolean {}
one sig True, False extends Boolean {}


// sig AvailableCourses {}
    // maybe have pfunc that maps from an int (in our case would be course ID) to a course
    // 

// maybe should do an:
//
// abstract sig Student {}
// sig Ta extends Student {}
// sig regularStudent extends Studnet {}

// make this abstract if we want to go UTA and HTA route
sig TA {
    // ID to be able to reference each TA
    StudentID: one Int,
    // pfunc to know what courses the TA applied to TA (maps course ID to boolean)
    Applications: pfunc Int -> Boolean 

    // other possible fields:
    // list of courses that TA has taken before
    // pfunc mapping from courses taken to bool for passed the course with acceptable grade/grade they received
    // ranking for the courses they applied to

}


/*
Section in case we want to take the UTA/HTA route of distinguishing those
*/
// sig UTA extends TA {}

// sig HTA extends TA {}


    // maybe fields for 
        // having taken the course before
        // bool for passed the course with acceptable grade (could change this to the actual grade they received)
        // something that indicates what courses they applied to
            // ranking for the courses they applied to
        // int that is a student ID number
        
    
sig Course {
    // int describing the max number of 
    MaxTAs: one Int,
    // int representing the ID for the course
    CourseID: one Int,
    // boolean whether the course is offered next semester
    OfferedNextSem: one Boolean,
    // pfunc mapping from students that applied to TA and if they passed the interview
    TAInterviews: pfunc Int -> Boolean
    // possible fields for Max number of students/enrollment
    // possible field for professor

}

------- possible preds 

pred validCourses {
    // predicate that narrows down the courses to those that are considered valid: ID > 0
    all course: Course | {
        // all courses have and ID greater than 0
        course.CourseID > 0

        all course2: Course | {
            // two different courses must have a different ID
            course != course2 implies {
                course.courseID != course2.courseID

            }
        }
    }
}


pred validTAs {
    // all TAs must have different StudentID numbers
    all disj ta1, ta2: TA | {
        ta1.StudentID > 0
        ta2.StudentID > 0
        ta1.StudentID != ta2.StudentID
    }
    // other conditions

}

// could change this to be if they are in a list of courses that TAs must be matched to then must be offered next semester
pred availableCourses {
    // predicate that narrows down the courses to those that are available next semester
    all course: Course | {
        course.OfferedNextSem = True
    }
}


// pred allPassedOrFailed{
//  // predicate that ensures that every student either has a pass or fail for the interview for every course 
// }



pred 


