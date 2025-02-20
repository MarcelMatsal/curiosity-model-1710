#lang forge/froglet

open "ta_allocation.frg"

test suite for availableCourses {

    assert validCourses is sat

    example is_available is {availableCourses} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Course = `c1 + `c2
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem = `c1 -> `true +  `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
    }

    // not all available next semester
    example not_available is {not availableCourses} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Course = `c1 + `c2
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem = `c1 -> `true +  `c2 -> `false
    }
    
    // some have the same ID
    example not_available2 is {not availableCourses} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Course = `c1 + `c2
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 1
            OfferedNextSem = `c1 -> `true +  `c2 -> `true
    }

    // not continuous rankings from the course
    example not_available3 is {not availableCourses} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Course = `c1 + `c2
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem = `c1 -> `true +  `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 3 + `c1 -> `p3 -> 4
    }

    // ranked two candidates the same
    example not_available4 is {not availableCourses} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Course = `c1 + `c2
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem = `c1 -> `true +  `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 2
    }
    // no 1 ranking
    example not_available5 is {not availableCourses} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Course = `c1 + `c2
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem = `c1 -> `true +  `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 2 + `c1 -> `p2 -> 3 + `c1 -> `p3 -> 4
    }
}

/*
* Confirms a candidate has applied to the right number of courses (between 1 and 4).
*/
pred correctNumApplications {
    all s : Candidate | {
        #{course: Course | some y: Int | s.Applications[course] = y} >= 1
        #{course: Course | some y: Int | s.Applications[course] = y} <= 4
    }
}

test suite for validCandidate {

    // most basic candidate, has a basic ranking of preferences
    example correct_candidate is {validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true   
        Allocations = `c1 -> `p1 -> `false
    }

    // case where ranked multiple courses
    example correct_candidate2 is {validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 2 + `p1 -> `c3 -> 3 + `p1 -> `c4 -> 4
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }


    // cases where ranked multiple courses and doubled up some rankings
    example correct_candidate3 is {validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 1 + `p1 -> `c3 -> 2 + `p1 -> `c4 -> 3
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    example correct_candidate4 is {validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 2 + `p1 -> `c3 -> 2 + `p1 -> `c4 -> 3
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    // case where ranked less than 4 coureses (doesn't have to rank all available)
    example correct_candidate5 is {validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 2
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    // case did not rank any course
        example invalid_candidate is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    // case ranked too many courses
    example invalid_candidate2 is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4 + `c5
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        numJobs =  `p1 -> 0
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 1 + `p1 -> `c3 -> 2 + `p1 -> `c4 -> 3 + `p1 -> `c5 -> 4
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2 + `c5 -> 2 
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4 + `c5 -> 5
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true + `c5 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false 
            + `c5 -> `p1 -> `false
    }

    // case ranked courses out of bounds
    example invalid_candidate3 is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 0
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    example invalid_candidate4 is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 5
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }


    // case ranked courses with gap in ranking
    example invalid_candidate5 is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 3 + `p1 -> `c3 -> 4
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    example invalid_candidate6 is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 2 + `p1 -> `c3 -> 4
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    example invalid_candidate7 is {not validCandidate} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 1 + `p1 -> `c3 -> 4
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }

    assert correctNumApplications is necessary for validCandidate for 5 Candidate
}


test suite for noOverAllocation {

    // most basic condition, no allocations
    example no_over_allocation is {noOverAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        //CourseAllocatedTo = `p1 -> `c1
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true   
        Allocations = `c1 -> `p1 -> `false
    }
    // less allocations than max
    example no_over_allocation2 is {noOverAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        //CourseAllocatedTo = `p1 -> `c1
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true   
        Allocations = `c1 -> `p1 -> `true
    }

    // same number of allocations as max
    example no_over_allocation3 is {noOverAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2
        i9Status = `p1 -> `true + `p2 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false
        //CourseAllocatedTo = `p1 -> `c1
        numJobs =  `p1 -> 0 + `p2 -> 1
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true   
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true
    }

    // over allocation
    example overallocated is {not noOverAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `true
        //CourseAllocatedTo = `p1 -> `c1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true   
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }
}



test suite for endState {

    // someone not matched to it and open slot but they are matched somewhere else
    example basic_end_state is {endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 + `c2
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1 + `p3 -> `c2 -> 2
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 +  `c2 -> 1
        CourseID = `c1 -> 1 + `c2 -> 2
        OfferedNextSem =  `c1 -> `true + `c2 -> `true
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false +  `c2 -> `p3 -> `true
    }
    // A student can't be allocated to a course they didn't apply to
    example misranked_end_state is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2
        i9Status = `p1 -> `true + `p2 -> `true 
        academicProbation = `p1 -> `false + `p2 -> `false
        Applications = `p1 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true
    }
    // Even if underallocated, can't allocate a student who was unranked.
    example notranked_end_state is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2
        i9Status = `p1 -> `true + `p2 -> `true 
        academicProbation = `p1 -> `false + `p2 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true
        CandidateRankings = `c1 -> `p1 -> 1
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true
    }

    // two candidates matched and filled max number of TAs
    example end_state is {endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false
    }

    // candidate ranked by the course but not matched, however course is full
    example end_state2 is {endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 1 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false
    }
    // candidate ranked by the course but not matched
    example not_end_state is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 + `c2 + `c3 + `c4
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 2 + `p1 -> `c3 -> 3 + `p1 -> `c4 -> 4 + `p2 -> `c2 -> 1 + `p3 -> `c4 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 + `c2 -> 1 + `c3 -> 3 + `c4 -> 2
        CourseID = `c1 -> 1 + `c2 -> 2 + `c3 -> 3 + `c4 -> 4
        OfferedNextSem =  `c1 -> `true + `c2 -> `true + `c3 -> `true + `c4 -> `true
        CandidateRankings = `c1 -> `p1 -> 1 + `c2 -> `p1 -> 2
        Allocations = `c1 -> `p1 -> `false + `c2 -> `p1 -> `false + `c3 -> `p1 -> `false + `c4 -> `p1 -> `false
    }
    
    // can't be the case that someone that was ranked higher than someone allocated to the class ended up not being allocated
       example not_end_state2 is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false
    }
    // If a course isn't full, there should not be a waitlist for it.
    example not_end_state_full is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 3
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false
    }
    // Basic singular allocation.
    example end_state_all_alloc is {endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 3
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }
    // Against prefs to fill
    example basic_against_prefs_end_state is {endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 + `c2
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1 + `p3 -> `c2 -> 2
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 +  `c2 -> 1
        CourseID = `c1 -> 1 + `c2 -> 2
        OfferedNextSem =  `c1 -> `true + `c2 -> `true
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 3 + `c1 -> `p3 -> 2 + `c2 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false +  `c2 -> `p3 -> `true
    }
    // MUST be pulled against prefs
    example neg_basic_against_prefs_end_state is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1 + `c2
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1 + `p3 -> `c2 -> 2
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 +  `c2 -> 1
        CourseID = `c1 -> 1 + `c2 -> 2
        OfferedNextSem =  `c1 -> `true + `c2 -> `true
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 3 + `c1 -> `p3 -> 2 + `c2 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `true +  `c2 -> `p3 -> `false
    }
    // Tie breaking
    example neg_break_tie is {not endState} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1
        Course = `c1 + `c2
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        Applications = `p1 -> `c1 -> 1 + `p1 -> `c2 -> 1 // Tie
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 1 +  `c2 -> 1
        CourseID = `c1 -> 1 + `c2 -> 2
        OfferedNextSem =  `c1 -> `true + `c2 -> `true
        CandidateRankings = `c1 -> `p1 -> 1 + `c2 -> `p1 -> 1
        Allocations = `c1 -> `p1 -> `true + `c2 -> `p1 -> `false
    }
}

test suite for courseIsFull {
    test expect {
        // A fully allocated course.
        fullCourse: {
            some c : Course | {
                c.MaxTAs = 2 and (
                    some s1, s2 : Candidate | {
                        s1 != s2 and
                        c.Allocations[s1] = True and c.Allocations[s2] = True
                    }
                )
                and
                courseIsFull[c]
            }
        } is sat
        // A course that still has room.
        roomCourse : {
            some c : Course | {
                c.MaxTAs = 5 and (
                    some s1, s2 : Candidate | {
                        s1 != s2 and
                        c.Allocations[s1] = True and c.Allocations[s2] = True
                        and (all s : Candidate | {
                            s != s1 and s != s2 and
                            c.Allocations[s] = False or no c.Allocations[s]
                        })
                    }
                )
                and
                courseIsFull[c]
            }
        } is unsat
    }
}

test suite for isElligible {
    test expect {
        // Perfectly eligible student.
        goodStudent: {
            some s : Candidate | {
                s.i9Status = True and
                s.academicProbation = False and
                s.isInternational = True and
                s.numJobs = 1
                isElligible[s]
            }
        } is sat
        // Is on academic probation.
        badStudent: {
            some s : Candidate | {
                s.i9Status = True and
                s.academicProbation = True and
                s.isInternational = True and
                s.numJobs = 1
                isElligible[s]
            }
        } is unsat
        noINine: {
            some s : Candidate | {
                s.i9Status = False and
                s.academicProbation = False and
                s.isInternational = True and
                s.numJobs = 1
                isElligible[s]
            }
        } is unsat
        // More than 2 jobs but isn't international
        lotsOfJobs : {
            some s : Candidate | {
                s.i9Status = True and
                s.academicProbation = False and
                s.isInternational = False and
                s.numJobs = 6
                isElligible[s]
            }
        } is sat
        // Too many jobs for international
        tooManyJobsInter: {
            some s : Candidate | {
                s.i9Status = True and
                s.academicProbation = True and
                s.isInternational = True and
                s.numJobs = 7
                isElligible[s]
            }
        } is unsat
    }
}

test suite for noWaitlistOnNeededCourse {
    test expect {
        // A fully allocated course.
        waitlistButFull: {
            one c : Course | {
                courseIsFull[c] and (
                    some s : Candidate | {
                    c.CandidateRankings[s] = 4
                    s.Applications[c] = 1
                    no s.CourseAllocatedTo
                })
            }
            and noWaitlistOnNeededCourse
        } is sat
        // If a course has room, and there is a waitlist, that's wrong!
        waitlistButRoom : {
            one c : Course | {
                not courseIsFull[c] and (
                    some s : Candidate | {
                    c.CandidateRankings[s] = 4
                    s.Applications[c] = 1
                    no s.CourseAllocatedTo
                })
            }
            and noWaitlistOnNeededCourse
        } is unsat
    }
}

