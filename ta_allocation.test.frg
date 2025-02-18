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
        Applications = `p1 -> `c1 -> 1
        numJobs =  `p1 -> 0
        MaxTAs = `c1 -> 2
        CourseID = `c1 -> 1
        OfferedNextSem =  `c1 -> `true   
        Allocations = `c1 -> `p1 -> `false
    }


    // case where ranked multiple courses and doubled up some rankings



    // case where ranked less than 4 coureses



    // case did not rank any course



    // case ranked courses out of bounds



    // case ranked courses with gap in ranking

}