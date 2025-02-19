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
    CourseAllocatedTo: lone Course,
    // if the student is international or not
    isInternational: one Boolean
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
    Predicate that narrows down all courses to those that are valid courses (don't share ID with another course and
    have rankings that are continuous and not repetitive)
    */
    all disj course, course2: Course | {
        // all courses have and ID greater than 0
        course.CourseID > 0
        course2.CourseID > 0
        // two different courses must have different IDs
        course.CourseID != course2.CourseID
    }
    // the rankings of the course must be continuous and > 0, furthermore, candidates can't be ranked the same
    all cand: Candidate, course: Course | {
        // the rankings must be greater than 0
        all y: Int | {
            course.CandidateRankings[cand] = y implies {
                y > 0
            }
        }
        // the rankings must be linear
        all z: Int | {
            // if the course has a cand that is ranked above 1, there must be a cand that is ranked better than it
            (course.CandidateRankings[cand] = z and z > 1) implies {
                some c2: Candidate | {course.CandidateRankings[c2] = subtract[z,1]}
            }
        }
        // all candidates must have different rankings
        all cand2: Candidate | {
            (cand != cand2 and some course.CandidateRankings[cand2] and some course.CandidateRankings[cand]) implies {
                course.CandidateRankings[cand2] != course.CandidateRankings[cand]
            }
        }
    }
}

// DONE
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


// Predicate to determine if a candidate is elible to TA
// Includes criteria of:
// - has completed I9
// - is not on academic probation
// - has less than 2 jobs (if they are international)
pred isElligible[c: Candidate] {
    c.i9Status = True // I9
    and
    c.academicProbation = False // No probation
    and
    (c.isInternational = True implies c.numJobs < 2) // International students can only have 2 jobs (including the TA job)
}

// verify that the rankings are continuous
// pred ranking verifier (must be linear)

// numberApplications {
// a ta shoud not have applied to more than 4 and less than 1
//}

// DONE
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
}

// DONE
pred noOverAllocation {
    /* 
    Predicate that makes sure no courses become over allocated (too many TAs allocated to the class)
    */
    all course: Course | {
        #{cand: Candidate | course.Allocations[cand] = True} <= course.MaxTAs
    }
}


// DONE
// end state: Any course that is under allocated should not have TAs in their rankings that have allocated as false
pred endState {
    // having less allocated students that max means that no more students could fill the spot
    // if not full number of TAs
    all course: Course | {
        #{cand: Candidate | course.Allocations[cand] = True} <= course.MaxTAs implies {
            all cand: Candidate | {
                // if the candidate was ranked by the course, then it must be the case that the candidate has a match
                (some course.CandidateRankings[cand] and some cand.Applications[course]) implies some cand.CourseAllocatedTo
                ----- THIS MIGHT BE GOOD OUTSIDE OF THE CONSTRAINT OF COURSE BEING UNDERALLOCATED
                // can't be the case that some other candidate was not allocated, had it ranked, and was ranked higher than someone allocated
                not ( 
                    some cand2: Candidate | {
                    no cand2.CourseAllocatedTo
                    some course.CandidateRankings[cand2]
                    // the candidate should have also applied to the course <- <- <- <- This wasn't a constraint but feel like should be 
                    some cand2.Applications[course]
                    cand.CourseAllocatedTo = course
                    course.CandidateRankings[cand] < course.CandidateRankings[cand2]
                })
                and
                course.Allocations[cand] = True implies {
                    (course.CandidateRankings[cand] > 0 and cand.Applications[course] > 0)
                    and
                        // This course best matches the preferences of the TA.
                        isBestPreference[cand, course]
                    }
            }
        }
    }
}


/* Predicate that ensures the allocations are rounded -> I.E. reflected on both the candidate and course */
pred roundedAllocation {
    // if a candidate gets allocated to the course it must be reflected on both the Candidate and the Course 
    all cand: Candidate, course: Course | {
        cand.CourseAllocatedTo = course iff course.Allocations[cand] = True
    }
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
* The predicate which makes a decision: have we given the TA the best we could?
*/
pred isBestPreference[s : Candidate, c : Course] {
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
            (oCourse != c and (s.Applications[oCourse] > s.Applications[c])) implies 
            // No deficit issues with course
            not (notBiggestDeficit[s, c])
        })
        )
        or
        (all oCourse : Course | {
            (oCourse != c and (s.Applications[oCourse] < s.Applications[c])) implies 
            // Not highest ranking, only hired if in deficit, and the greatest one.
            (isInDeficit[c] and not notBiggestDeficit[s, c])
        })
    )
}

// run here
// run {
//     availableCourses
//     validCandidate
//     noOverAllocation
//     endState
//     roundedAllocation
//     all c : Course | {
//         c.MaxTAs = 5
//     }
// } for exactly 2 Course, exactly 4 Candidate