#lang forge/froglet


/*
This file contains the model for the allocation of TAs to courses for hiring
*/ 


// sig that can be used to determine if a condition is true or false
abstract sig Boolean {}
one sig True, False extends Boolean {}


// sig that models a candidate
sig Candidate {
    // ID to be able to reference each TA
    StudentID: one Int,
    // pfunc to know what courses the TA applied to TA (maps course to ranking from the TA)
    Applications: pfunc Course -> Int,
    // i9 form status of candidate (if they filled it out)
    i9Status: one Boolean,
    // if the candidate has been on academic probation
    academicProbation: one Boolean,
    // the total number of jobs the candidate currently has
    numJobs: one Int,
    // the actual course the TA was allocated to
    CourseAllocatedTo: lone Course
}

        
// sig that models a Course
sig Course {
    // int describing the max number of 
    MaxTAs: one Int,
    // int representing the ID for the course
    CourseID: one Int,
    // boolean whether the course is offered next semester
    OfferedNextSem: one Boolean,
    // pfunc mapping from students that applied to TA and how they rank the TA
    CandidateRankings: pfunc Candidate -> Int,
    // pfunc mapping from a candidate to a boolean 
    Allocations: pfunc Candidate -> Boolean
}

------------------------------------------------------------------------------------------------------------------------
pred validCourses {
    /* 
    Predicate that narrows down all courses to those that are valid courses
    */
    all disj course, course2: Course | {
        // all courses have and ID greater than 0
        course.CourseID > 0
        course2.CourseID > 0
        // two different courses must have different IDs
        course.CourseID != course2.CourseID
    }
}


pred availableCourses {
    /* 
    predicate that narrows down the courses to those that are available to be matched (should be valid and offered)
    */
    all course: Course | {
        // all the courses considered must be available the upcoming semester
        course.OfferedNextSem = True
    }
    // should also be valid courses
    validCourses

}


// predicate to determine if a candidate is el
pred isElligible[c: Candidate]{

}

// verify that the rankings are continuous
// pred ranking verifier (must be linear)

// numberApplications {
// a ta shoud not have applied to more than 4 and less than 1
//}

pred validCandidate {
    /*
    Predicate that narrows down to valid candidates 
    */ 

    // all candidates must have different StudentID numbers (maybe move to its own pred)
    all disj cand1, cand2: Candidate | {
        cand1.StudentID > 0
        cand2.StudentID > 0
        cand1.StudentID != cand2.StudentID
    }

    all cand: Candidate | {
        // the candidate must be elligible
        isElligible[cand]
        // must have ranked at least 1 and at most 4 courses 
        #{course: Course | some y: Int | cand.Applications[course] = y} >= 1
        #{course: Course | some y: Int | cand.Applications[course] = y} <=4
    }

    // the rankings of the candidate must be continuous from 1 - 4
    all cand: Candidate, course: Course | {
        // the ranking can only be between 1 and 4 (duplicates allowed)
        all y: Int | {
            cand.Applications[course] = y implies {
                y >= 1
                y <= 4
            }
        }
        // the rankings must be linear
        all z: Int | {
            // if the candidate has a course that is ranked above 1, there must be a course that is ranked better than it
            (cand.Applications[course] = z and z > 1) implies {
                some c2: Course | {cand.Applications[c2] = subtract[z,1]}
            }
        }
    }
}

// DONE
pred init {
    /* 
    Predicate representing the initial state of our model,
    ensuring that no one is allocated yet and courses have no allocations
    yet
    */
    
    // no candidate should be allocated to a course
    all candidate: Candidate | {
        no candidate.CourseAllocatedTo
    }

    // the courses should have no current allocations
    all course: Course, candidate: Candidate | {
        // maybe some merit in making this equal to False instead of there being none
        course.Allocations[candidate] = False

    }
    // 

}

//
pred overAllocated {
    // A course should never have more TAs allocated than the number of spots available

    /* 
    Predicate that makes sure no courses become over allocated (too many TAs allocated to the class)
    */
    all course: Course | {
        #{}

    }


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

// run {}


// run here



