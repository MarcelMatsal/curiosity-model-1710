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

    assert all cand: Candidate | cand.numJobs >= 0 is necessary for validCandidate

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
    
    // basic case not matched but all courses full
    example no_waitlist is {noWaitlistOnNeededCourse} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        CourseAllocatedTo = `p2 -> `c1 + `p3 -> `c1
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 3 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }

    // basic case not matched but did not apply to course
    example no_waitlist2 is {noWaitlistOnNeededCourse} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        CourseAllocatedTo = `p2 -> `c1 + `p3 -> `c1
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications =  `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 3 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 3 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }

    // basic case not matched but course did not rank the student
    example no_waitlist3 is {noWaitlistOnNeededCourse} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        CourseAllocatedTo = `p2 -> `c1 + `p3 -> `c1
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 4 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings =  `c1 -> `p2 -> 2 + `c1 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }

    // negative case where non of the conditions are met
    example not_no_waitlist is {not noWaitlistOnNeededCourse} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        CourseAllocatedTo = `p2 -> `c1 + `p3 -> `c1
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 4 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 3 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 1
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }

    assert endState is sufficient for noWaitlistOnNeededCourse

}

test suite for roundedAllocation {

    // positive case
    example is_rouned is {roundedAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        CourseAllocatedTo = `p2 -> `c1 + `p3 -> `c1
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }

    // negative case (not in allocations)
    example not_rouned is {not roundedAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        CourseAllocatedTo = `p3 -> `c1
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `true
    }

    // negative case (not in CourseAllocatedTo)
    example not_rouned2 is {not roundedAllocation} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 + `p2 + `p3
        Course = `c1
        StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
        i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
        CourseAllocatedTo = `p2 -> `c1 + `p3 -> `c1
        academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
        Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 1 + `p3 -> `c1 -> 1
        numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
        MaxTAs = `c1 -> 2 
        CourseID = `c1 -> 1 
        OfferedNextSem =  `c1 -> `true 
        CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3
        Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `true + `c1 -> `p3 -> `false
    }
}


/* Testing they actually applied */
pred applied[s : Candidate, c : Course] {
    s.Applications[c] > 0
}

/* Testing they were actually rankings */
pred ranked[s : Candidate, c : Course] {
    c.CandidateRankings[s] > 0
}


test suite for isBestSpotFor {
    test expect {
        // Nowhere else to go
        noOtherChoices: {
            one c : Course | {
                one s : Candidate | {
                    s.Applications[c] = 1
                    c.CandidateRankings[s] = 1
                    c.MaxTAs = 1
                    isBestSpotFor[s, c]
                }
            }
        } is sat
        allFull: {
            some c1, c2 : Course | {
                c1 != c2
                one s : Candidate | {
                    s.Applications[c1] = 1
                    s.Applications[c2] = 1
                    c1.CandidateRankings[s] = 1
                    c2.CandidateRankings[s] = 2
                    courseIsFull[c2]
                    c1.MaxTAs = 2
                    isBestSpotFor[s, c1]
                }
            }
        } is sat
        // Lower ranked but needed.
        againstPrefButDef : {
            some c, c2 : Course | {
                c != c2
                one s : Candidate | {
                    s.Applications[c] = 1
                    s.Applications[c2] = 2
                    c.CandidateRankings[s] = 1
                    c2.CandidateRankings[s] = 1
                    and
                    c.MaxTAs = 1
                    c2.MaxTAs = 3
                    isBestSpotFor[s, c2]
                }
            }
        } is sat
        // Tie, went to higher course
        tiedHigher : {
            validCandidate and
            validCourses and
            (some s : Candidate | {
                (some c1, c2 : Course | {
                    c1 != c2
                    not courseIsFull[c1]
                    not courseIsFull[c2]
                    not courseNeededMore[c1, s, c2]
                    c1.MaxTAs = 1
                    c2.MaxTAs = 1
                    (s.Applications[c1] = 1)
                    (s.Applications[c2] = 1)
                    (c1.CandidateRankings[s] = 1)
                    (c2.CandidateRankings[s] = 1)
                    (c1.CourseID = 3)
                    (c2.CourseID = 2)
                    and
                    not courseIsFull[c1]
                    not courseIsFull[c2]
                    isBestSpotFor[s, c1]
                }
            )}
        )} is sat
        // Tied, went to lower course. BAD!
        tiedLower : {
            validCandidate and
            validCourses and
            (some s : Candidate | {
                #Course = 2
                (some c1, c2 : Course | {
                    c1 != c2
                    not courseIsFull[c1]
                    not courseIsFull[c2]
                    not courseNeededMore[c1, s, c2]
                    c1.MaxTAs = 1
                    c2.MaxTAs = 1
                    (s.Applications[c1] = 1)
                    (s.Applications[c2] = 1)
                    (c1.CandidateRankings[s] = 1)
                    (c2.CandidateRankings[s] = 1)
                    (c1.CourseID = 2)
                    (c2.CourseID = 4)
                    and
                    not courseIsFull[c1]
                    not courseIsFull[c2]
                    isBestSpotFor[s, c1]
                }
            )}
        )} is unsat
    }

    // They actually applied to the course
    assert all s : Candidate, c : Course | { applied[s, c] }  is necessary for isBestSpotFor[s, c]

    // The course actually ranked them
    assert all s : Candidate, c : Course | { ranked[s, c] }  is necessary for isBestSpotFor[s, c]
}

test suite for courseNeededMore {
    test expect {
        // Course does need applicant more.
        greaterDeficit: {
            some c, c2 : Course | {
                c != c2
                one s : Candidate | {
                    s.Applications[c] = 1
                    s.Applications[c2] = 1
                    c.CandidateRankings[s] = 1
                    c2.CandidateRankings[s] = 1
                     and
                    c.MaxTAs = 3
                    c2.MaxTAs = 1
                    courseNeededMore[c, s, c2]
                }
            }
        } is sat
        // Other course needs them more!
        smallerDeficit : {
            some c, c2 : Course | {
                c != c2
                one s : Candidate | {
                    s.Applications[c] = 1
                    s.Applications[c2] = 1
                    c.CandidateRankings[s] = 1
                    c2.CandidateRankings[s] = 1
                    and
                    c.MaxTAs = 1
                    c2.MaxTAs = 3
                    courseNeededMore[c, s, c2]
                }
            }
        } is unsat
    }
}

// some wholistic tests for the model working together 
test suite for Cohesive {

    // some checks of things that should sufficient when the model is run
    assert {availableCourses and validCandidate and noOverAllocation and endState and roundedAllocation} is sufficient for validCourses
    assert {availableCourses and validCandidate and noOverAllocation and endState and roundedAllocation} is sufficient for noWaitlistOnNeededCourse

    // tests combinging a bunch of preds to ensure overall consistency of model (passing condition)
    example working_together is {
        availableCourses
        validCandidate
        noOverAllocation
        endState
        roundedAllocation} for {
            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 0 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true

    }

    // condition of model violated: intenrational student >= 2 jobs
    example not_working_together is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 2 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true

    }

    // condition of model violated: i9 not done for a candidate
    example not_working_together2 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `false + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true
    }

    // condition of model violated: academic violation for a candidate
    example not_working_together3 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1
            academicProbation = `p1 -> `false + `p2 -> `true + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `true
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true

    }

    // condition of model violated: course not offered next semester
    example not_working_together4 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `false
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true

    }


    // did not allocate a candidate that should have been allocated
    example not_working_together5 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `false
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true
    }

    // allocated to a course did not apply to
    example not_working_together6 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c2
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `false
            CandidateRankings = `c1 -> `p1 -> 1 + `c1 -> `p2 -> 2 + `c1 -> `p3 -> 3 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `false + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `true + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true
    }

    // allocated to a course when the course did not rank user
    example not_working_together7 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `false
            CandidateRankings =  `c1 -> `p2 -> 1 + `c1 -> `p3 -> 2 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true
    }

    // candidate allocated to multiple courses
    example not_working_together8 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1 
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 2 + `c2 -> 2
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `false
            CandidateRankings =  `c1 -> `p2 -> 1 + `c1 -> `p3 -> 2 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `true + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true
    }

    // over allocated a course
    example not_working_together9 is {
        not (availableCourses and
        validCandidate and
        noOverAllocation and
        endState and
        roundedAllocation)} for {

            Boolean =  `true + `false
            True = `true
            False = `false
            Candidate = `p1 + `p2 + `p3
            Course = `c1 + `c2
            StudentID = `p1 -> 1 + `p2 -> 2 + `p3 -> 3
            i9Status = `p1 -> `true + `p2 -> `true + `p3 -> `true
            isInternational = `p1 -> `true + `p2 -> `false + `p3 -> `true
            CourseAllocatedTo = `p2 -> `c2 + `p3 -> `c2 + `p1 -> `c1 
            academicProbation = `p1 -> `false + `p2 -> `false + `p3 -> `false
            Applications = `p1 -> `c1 -> 1 + `p2 -> `c1 -> 2 + `p2 -> `c2 -> 1 + `p3 -> `c1 -> 2 + `p3 -> `c2 -> 1
            numJobs =  `p1 -> 1 + `p2 -> 1 + `p3 -> 1
            MaxTAs = `c1 -> 1 + `c2 -> 1
            CourseID = `c1 -> 1 + `c2 -> 2
            OfferedNextSem =  `c1 -> `true + `c2 -> `false
            CandidateRankings =  `c1 -> `p2 -> 1 + `c1 -> `p3 -> 2 + `c2 -> `p2 -> 2 + `c2 -> `p3 -> 1
            Allocations = `c1 -> `p1 -> `true + `c1 -> `p2 -> `false + `c1 -> `p3 -> `false + `c2 -> `p1 -> `false + `c2 -> `p2 -> `true
                +  `c2 -> `p3 -> `true
    }
}
