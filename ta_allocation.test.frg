#lang forge/froglet

open "ta_allocation.frg"

// write the tests here for our model



test suite for init {

    // most basic condition, 1 cand and 1 course where no one is matched to anything
    example basicCondition is {init} for {
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

    // case a candidate is allocated already
    example candIsAllocated is {not init} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        numJobs =  `p1 -> 0
        CourseAllocatedTo = `p1 -> `c1
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true     
    }

    // case a course is allocated already
    example courseIsAllocated is {not init} for {
        Boolean =  `true + `false
        True = `true
        False = `false
        Candidate = `p1 
        Course = `c1
        StudentID = `p1 -> 1
        i9Status = `p1 -> `true
        academicProbation = `p1 -> `false
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true     
        Allocations = `c1 -> `p1 -> `false
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
