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
        some y: Int | {
            cand.Applications[course] = y implies {
                y >= 1
                y <= 4
            }
        }
        // the rankings must be linear
        some z: Int | {
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


// Confirms that an allocation of a student followed all rules:
/*
* We look at some course (C), and the highest unallocated student (S) for that course:
* We only make a change if we are looking at the highest ranked course for S.
* 1. If C is at MaxTAs, no change is made.
* 2. If C is not at MaxTAs, then:
*     a. If S ranked C AND S has no other rankings, then S is allocated to C.
*     b. If S ranked C and S has not been ranked by other courses, then S is allocated to C.
*     c. If S unsubmitted their rank for course C, no change is made.
*     d. If S ranked C AND all other courses S ranked are full, then S is allocated to C. 
*     e. If S ranked C = another course that is not full:
*        -    If C has the greatest deficet (apps - maxTAs), S is allocated to C, otherwise, no change is made.
*        -    If none of the equal ranked courses have a deficet, and C is not the highest number, no change is made.
*/
// Tas allocated to the course with the biggest defecit if they ranked it

// only ranked to a course if there are still spots left

// ta has been ranked to a course if either their first preference and not ranked anywhere else,

// someone has ranked something 2 or 3, should only be put on that course if no one else on that course list preferred it as their first
// their first preference, ranked elsewhere but enough people ranked higher than that person 


// If tie, we move to upper level course (no action if lower number course)
// If ranked multiple courses, and highest pref is current course:
// - only defer if another course is at a greater deficet
// If ranked multiple coures, and lower pref is current course:
// - only accept if in a deficiet and no other course is at a greater deficet

/*
* Predicate that confirms some candidate is the current top candidate who
* has not yet been allocated to the given course.
* 
* In other words, there are no higher ranked candidates above them who haven't yet
* been allocated to the course.
*/
pred isCurrentTopCandidate[s : Candidate, c : Course] {
    (c.CandidateRankings[s] > 0 and no c.Allocations[s])
    and
    (all otherStudent : Candidate | {
        otherStudent != s
        and
        // If higher (smaller number) ranked, they must already be allocated.
        (c.CandidateRankings[otherStudent] < c.CandidateRankings[s]) implies {
            c.Allocations[otherStudent] = True
        }
    })
}

/*
* Predicate that determines if a given course is the highest ranked
* (or tied for highest rank) course that student wants. (And, can actually get).
*/
pred isBestOptionForStudent[s : Candidate, c : Course] {
    // Confirm they ranked the course:
    s.Applications[c] > 0 
    and
    // Confirm they didn't rank any higher courses:
    (   all otherCourse : Course | {
            otherCourse != c
            and
            (s.Applications[otherCourse] > 0 implies {
                s.Applications[otherCourse] <= s.Applications[c] // Lower ranked.
                or
                // The other courses ranked higher are full, or they didn't rank the candidate.
                (s.Applications[otherCourse] > s.Applications[c] and (courseIsFull[otherCourse] or no otherCourse.CandidateRankings[s]))
            })
        }
    )
}

/*
* Predicate that determines if a course is full.
*/
pred courseIsFull[c : Course] {
    // Predicate that determines if a course is full.
    #({cands: Candidate | c.Allocations[cands] = True}) >= c.MaxTAs
}

/*
* Predicate to verify a given course isn't the biggest deficited course for a
* soon to be allocated student.
*/
pred notBiggestDeficit[s : Candidate, c : Course] {
    // Predicate to verify a given course isn't the biggest deficited course for a
    // soon to be allocated student.
    let cDeficit = (subtract[c.MaxTAs, #{cands : Candidate | cands.Applications[c] > 0 and c.CandidateRankings[cands] > 0}]) | {
        all otherCourse : Course | {
            (
                // They actually applied to the course, and that course wants them.
                otherCourse != c
                and
                otherCourse.CandidateRankings[s] > 0
                and
                s.Applications[otherCourse] > 0
            ) implies {
                // We compare the deficits.
                let otherDeficit = (subtract[otherCourse.MaxTAs, #{cands : Candidate | cands.Applications[otherCourse] > 0  and otherCourse.CandidateRankings[cands] > 0}]) | {
                    (otherDeficit > 0) and (otherDeficit > cDeficit)
                }
            }
        }
    }
}

/*
* Pred that confirms a course has less applicants than needed TA spots.
*/
pred isInDeficit[c : Course] {
    (subtract[c.MaxTAs, #{cands : Candidate | cands.Applications[c] > 0 and c.CandidateRankings[cands] > 0}]) > 0
}

/*
* The predicate which makes a decision: do we allocate? Or defer now for later.
*/
pred allocateStudentToCourse[s : Candidate, c : Course] {
    // This predicate determines if we allocate or defer the allocation.

    // We first verify they are the top candidate for this course.
    isCurrentTopCandidate[s, c]
    and
    // If the course is full, we do not allocate.
    (not courseIsFull[c])
    and
    (no s.CourseAllocatedTo) // We haven't already given them away.
    and
    (not (no s.Applications[c])) // They actually ranked the course.
    and
    // All the possible cases we would allocate them to c:
    (   
        // More basic cases - they have no other options!
        (all otherCourse : Course | {
            otherCourse != c and
            ((no s.Applications[otherCourse]) // They applied nowhere else
            or
            (no otherCourse.CandidateRankings[s]) // Candidate was unranked by every other class.
            or
            (s.Applications[otherCourse] > 0 implies courseIsFull[otherCourse])) // Everywhere else is full.
        })
        or
        // Tie, and no higher ranking.
        (isBestOptionForStudent[s, c] implies
        (some oCourse : Course | {
            oCourse != c and (s.Applications[oCourse] = s.Applications[c]) and (oCourse.CourseID < c.CourseID)
        }) // Tie
        or
        (all oCourse : Course | {
            (oCourse != c and (s.Applications[oCourse] != s.Applications[c])) implies 
            // No deficit issues with course
            not (notBiggestDeficit[s, c])
        })
        )
        or
        // Not highest ranking, only hired if in deficit, and the greatest one.
        (isInDeficit[c] and not notBiggestDeficit[s, c])
    )
}

// run here
