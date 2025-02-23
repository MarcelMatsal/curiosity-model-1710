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

// Predicates
------------------------------------------------------------------------------------------------------------------------

/* 
* Predicate that narrows down all courses to those that are valid courses (don't share ID with another course and
* have rankings that are continuous and not repetitive)
*/
pred validCourses {
    
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

        // A ranked candidate had to have applied.
        some course.CandidateRankings[cand] implies {
            some cand.Applications[course]
        }
    }
}

/* 
* predicate that narrows down the courses to those that are available to be matched (should be valid and offered)
*/
pred availableCourses {
    all course: Course | {
        // all the courses considered must be available the upcoming semester
        course.OfferedNextSem = True
    }
    // should also be valid courses
    validCourses
}


/*
* Predicate to determine if a candidate is elible to TA
* Includes criteria of:
* - has completed I9
* - is not on academic probation
* - has less than 2 jobs (if they are international
*/
pred isElligible[c: Candidate] {
    c.i9Status = True // I9
    and
    c.academicProbation = False // No probation
    and
    (c.isInternational = True implies c.numJobs < 2) // International students can only have 2 jobs (including the TA job)
}


/*
Predicate that narrows down to valid candidates 
*/ 
pred validCandidate {
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

        // added -> cant have a negative number of jobs
        cand.numJobs >= 0
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


/* 
Predicate that makes sure no courses become over allocated (too many TAs allocated to the class)
*/
pred noOverAllocation {
    all course: Course | {
        #{cand: Candidate | course.Allocations[cand] = True} <= course.MaxTAs
    }
}


/*
* End state: Any course that is under allocated should not have TAs in their rankings that have allocated as false
*/
pred endState {
    // having less allocated students that max means that no more students could fill the spot
    // if not full number of TAs
    all course: Course | {
        #{cand: Candidate | course.Allocations[cand] = True} <= course.MaxTAs implies {
            all cand: Candidate | {
                // if the candidate was ranked by the course, then it must be the case that the candidate has a match
                (some course.CandidateRankings[cand] and some cand.Applications[course]) implies some cand.CourseAllocatedTo
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
                        isBestSpotFor[cand, course]
                    }
            }
        }
    }
    // If a candidate wasn't hired - why?
    and noWaitlistOnNeededCourse
}


/*
* Makes sure there aren't waitlists on courses that are underallocated.
*/
pred noWaitlistOnNeededCourse {
    all cand : Candidate | {
        no cand.CourseAllocatedTo implies {
            all course : Course | {
                courseIsFull[course] or no course.CandidateRankings[cand] or no cand.Applications[course]
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


/* Predicate to ensure an allocation was the "best choice" for a candidate. */
pred isBestSpotFor[s : Candidate, c : Course] {
    // A candidate only went to a lower rated course if:
    // 1. They had tying prefs, and went to higher level course.
    // 2. The course had exactly MaxTAs applicants or less.
    (s.Applications[c] > 0 and c.CandidateRankings[s] > 0) 
    and
    (all otherCourse : Course | {
        (otherCourse != c and s.Applications[otherCourse] > 0 and otherCourse.CandidateRankings[s] > 0) implies {
            (s.Applications[otherCourse] < s.Applications[c] and
                // Othercourse needed s more.
                courseNeededMore[c, s, otherCourse]
            )
            or
            (s.Applications[otherCourse] = s.Applications[c] and (otherCourse.CourseID < c.CourseID or courseNeededMore[c, s, otherCourse]))
            or
            courseIsFull[otherCourse]
            or 
            (s.Applications[c] < s.Applications[otherCourse] and not courseNeededMore[otherCourse, s, c])
        }
    })
}


/*
* Affirm a course needed a TA more than another.
*/ 
pred courseNeededMore[inNeedCourse : Course, student : Candidate, prefCourse : Course] {
    // The course needed the student more than the other course.
    let inNeedDeficit = (subtract[inNeedCourse.MaxTAs, #{cands : Candidate | cands.Applications[inNeedCourse] > 0 and inNeedCourse.CandidateRankings[cands] > 0}]) | {
        let prefDeficit = (subtract[prefCourse.MaxTAs, #{cands : Candidate | cands.Applications[prefCourse] > 0 and prefCourse.CandidateRankings[cands] > 0}]) | {
            (inNeedDeficit > 0) and (inNeedDeficit > prefDeficit)
        }
    }
}


/*
* Predicate that determines if a course is full.
*/
pred courseIsFull[c : Course] {
    // Predicate that determines if a course is full.
    #({cands: Candidate | c.Allocations[cands] = True}) >= c.MaxTAs
}


// Example run of the system functioning as intended
our_system: run {
    availableCourses
    validCandidate
    noOverAllocation
    endState
    roundedAllocation
    all c : Course | {
        c.MaxTAs = 5
    }
} for exactly 2 Course, exactly 6 Candidate


// runs to experiment and understand the intricacies within out system of allocating TAs
// what happens when the allocations the TA sees does not have to be reflected in what the courses see
loosen_roundedAllocation: run {
    availableCourses
    validCandidate
    noOverAllocation
    endState
    // roundedAllocation
    all c : Course | {
        c.MaxTAs = 5
    }
} for exactly 2 Course, exactly 6 Candidate


// runs to experiment and understand the intricacies within out system of allocating TAs
// what happens when we allow courses to become overallocated (causes the system to fail in more than one way than we would have assumed)
allow_overallocation: run {
    availableCourses
    validCandidate
    // noOverAllocation
    endState
    roundedAllocation
    all c : Course | {
        c.MaxTAs = 2
    }
} for exactly 2 Course, exactly 6 Candidate

