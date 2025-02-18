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
sig Candidate {
    // ID to be able to reference each TA
    StudentID: one Int,
    // pfunc to know what courses the TA applied to TA (maps course ID to ranking from the TA)
    Applications: pfunc Int -> Int,
    // i9 form status of candidate (if they filled it out)
    i9Status: one Boolean,
    // if the candidate has been on academic probation
    academicProbation: one Boolea,
    // the total number of jobs the candidate currently has
    numJobs: one Int,
    // boolean of whether the TA has already been allocated
    CurrentlyAllocated: one Boolean,

    CourseAllocatedTo: one Course
}

        
    
sig Course {
    // int describing the max number of 
    MaxTAs: one Int,
    // int representing the ID for the course
    CourseID: one Int,
    // boolean whether the course is offered next semester
    OfferedNextSem: one Boolean,
    // pfunc mapping from students that applied to TA and how they rank the TA
    CandidateRankings: pfunc Int -> Int,
    // 
    CurrentlyAllocated: one Boolean,
    // 
    Allocations: pfunc 

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


// predicate to determine if a 
pred isElligible[c: Candidate]{

}

// verify that the rankings are continuous
// pred ranking verifier (must be linear)

// numberApplications {
// a ta shoud not have applied to more than 4 and less than 1
//}

pred validCandidate {
    // all TAs must have different StudentID numbers
    all disj ta1, ta2: TA | {
        ta1.StudentID > 0
        ta2.StudentID > 0
        ta1.StudentID != ta2.StudentID
    }
    // other conditions

    //
}



// could change this to be if they are in a list of courses that TAs must be matched to then must be offered next semester
pred availableCourses {
    // predicate that narrows down the courses to those that are available next semester
    all course: Course | {
        course.OfferedNextSem = True
    }
}


pred init {
    // no allocations yet
    // nobody should have allocated flags as true and no one 
    // 

}

pred overAllocated {
    // A course should never have more TAs allocated than the number of spots available


}




// end state: Any course that is under allocated should not have TAs in their rankings that have allocated as false
pred endState {


}



// Tas allocated to the course with the biggest defecit if they ranked it

// only ranked to a course if there are still spots left

// ta has been ranked to a course if either their first preference and not ranked anywhere else,

// someone has ranked something 2 or 3, should only be put on that course if no one else on that course list preferred it as their first
// their first preference, ranked elsewhere but enough people ranked higher than that person 
pred validAllocation {

}
// pred allPassedOrFailed{
//  // predicate that ensures that every student either has a pass or fail for the interview for every course 
// }


// run here



pred 


