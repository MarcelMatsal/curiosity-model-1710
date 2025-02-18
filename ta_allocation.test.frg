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