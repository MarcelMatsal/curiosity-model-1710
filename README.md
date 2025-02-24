# curiosity-model-1710

## Project Objective
We came into this project with one basic goal: to better understand the current system that is being used by the MTAs to allocate TAs to certain courses. It may seem like a simple thing to do, but there are a lot of things that must be considered in order for it to function properly and to maximize utility (maximize the overall happniess of all candidates). Truth be told, it was difficult for the MTAs to describe how they know make a decision.

A big question we were trying to answer is one that the MTAs receive quite frequently from Professors and TAs alike: "why was I allocated to course X?". Professors often expect to get all of their top candidates, and sometimes even know that their top candidate ranked them back as their first choice, but still don't receive that applicant. We wanted to learn the intricacies of the current system to find possible places where it could be improved, and to formalize a standard that can be passed down to the next generation of MTAs (Tyler will graduate soon :(   ), and equally provided to professors and the greater applicant population to help answer questions on what may seem like disparities in rankings and allocations. Defining these rules and exploring the situations where one TA might be moved from one class to another is a big step in being able to provide examples, take feedback on a more rule-based process, and find flaws in the design of the hiring process.

## Model Design and Visualization

We tried to make our model as close to the real situation as possible: confining the domain to "eligible" TAs, and then producing the "end state" as a means of mapping where each TA went. The run statements will show this `endState` mapping, and when viewing an instance there are a key things to look at in the default sterling visualization:
- `Course`s
- `Candidate`s

From a candidate, you can see extensions of `Applications`, which can be tracked to see which courses they applied to, and from a course, you can see an extension of `CandidateRankings`, which can also give you a picture of which candidates a course ranked.

Probably the most helpful thing from this view is the arrows with `CourseAllocatedTo` from candidates. This will point to the course they were ended up put in by the model.

The table view gives a better view into the actual ranking match up. Namely, `Allocations` table shows the final list of all the courses and which Candidates they receieved. You can then peruse the different tables to see the different rankings, MaxTAs given, and deduce why or why not a candidate was put into a course based on the formal rules that were defined in the project. We felt the default visualizer sufficient, given the large amount of data and usual view in just a google sheet, we weren't sure how to iterate on a better visual without abstracting needed information.

Notably, we conceived two strong formal rules during the project:

- If a candidate is ranked back by some choice A, but is given a choice B that they ranked lower, it must be the case that B was in greater need of a TA.
- If a candidate is ranked back by some choice A, and is ranked by some choice B, and they ranked both of those courses the same, and they received B, it must be the case that B was a higher level course, or in greater need of a TA.
- If both of the previous were not true, a candidate will get the highest ranked course that ranked them back, and isn't full.

These formal rules will be extremely helpful in the years to come, as MTAs will now have a stronger guideline for allocating candidates to courses. This will aid them in explaining the process to curious students and professors, clarifying any concerns anyone may have. Additionally, now that it is formally written and we have studied that it works through the visualizations, we can feel confident that we are giving candidates and courses good matches.

We also wanted to note that we included other run commands that omitted some constraints from our model to see how it would react. This was purely to understand the intricacies of the system and see how things could go awry if the MTAs stop considering something. With the omissions, the matches were no longer logical, leading us to be thankful that we modeled this system as it taught us more about the system we are currently using. 

## Signatures and Predicates

Our model is made up of two main sigs: 

- `Candidate` 
- `Course`

They represent their real life counterparts when the MTAs undergo the process of allocating TAs to available courses in a semester. Each of these sigs contains a lot of different fields that a real-life candidate or course would have (and which the MTAs would utilize when considering how to allocate candidates to specific courses). Additionally, we have a sig `Boolean` which is extended by:

- `True`
- `False`

These two sigs are used as boolean values throughout the model. They simplify the model and allow other parts of the model to know certain conditions about candidates and courses that may impact multiple deciscions. These are the model's counterparts of basic states of being for a person or course, states of being (either true or false) for certain conditions that may impact decisions the MTAs make (or may even disqualify someone from becoming a TA).

The model contains many different predicates that are used to ensure that parts of the model are operating within the proper constraints and also to properly represent the situation. We wrote these predicates:

- `validCourses` - helper that narrows down all courses to those that are valid within the real world (such as having unique positive ids) and in the case of allocating TAs, ensures that the course has a valid ranking of candidates for hire (as is required in the real world).
- `availableCourses` - the main predicate used to constrain the courses utilized by the model. It ensures, as in the real world, that the course would be offered the upcoming semester (to allocate TAs to it, it must be the case that it will be offered next semester). Additionally, it utilizes validCourses to constrain to the courses being valid as well. This narrows down our domain of courses but also makes it a lot more reflective of the real world.
- `isEligible` - helper predicate that determines if an applicant is ready to be hired (have they done their I9, follow US working rules, and are not on probation).
- `validCandidate` - the main predicate used to constrain the candidates utilized by the model. It ensures that all the candidates have a proper ranking of courses they applied to (as is the case in the real world where candidates must submit a valid application with the rankings to be able to be allocated), ensures that all the candidates are reflective of the real world (such as having unique IDs), and also utilizes the `isEligible` predicate to ensure that every candidate would be eligible in the real world.
- `noOverAllocation` - helper predicate that verifies no course has been given too many TAs (rip TA budget).
- `endState` - the main predicate of our allocation model : this predicate basically determines all necessary allocation functions and a wellformed selection of applicants from rankings lists. It models the "end state" of what the MTAs would want to see when they are done making their hiring decisions.
- `noWaitlistOnNeededCourse` - helper for making sure that there are no available TAs on a "waitlist" for a course if it hasn't been fully allocated to its max TAs.
- `roundedAllocation` - helper for verifying that if a candidate has their "allocated" flag to a course, that course also has that candidate as allocated to them.
- `isBestSpotFor` - helper for ensuring that a TA was put into the correct course for them. It uses the "formal rules" for allocated a TA (described in the model section) to confirm that a TA got the best course they could, while also best suiting the needs of the program.
- `courseNeededMore` - helper for determining if some course A needs a student more than course B (compares how much of a deficit of TAs each course will be in).
- `courseIsFull` - helper for determining if a course is at its max allocation.



## Testing
For our testing we made use of `example`, `test-expect` and `assertions` to verify our predicates. 

We started with tests on the predicates that confine our domain: `validCourses` and `validCandidate` which ensure properly typed and contrained bounds for courses and candidates.

Notably, we used larger `example`s as a means of checking end states - as these tested out our allocaiton "scenarios" that we sought to explore the feasibility of.

When possible, we wrote helper predicates to `assert` necessary components of other larger predicates. We also made use of `sufficient` tests to confirm that predicates of a "later" state could confirm that an earlier state was followed (like `endState`).

When it came to the allocating decisions, we used `test expect` tests to verify if courses were truly the best for applicants in different situations (like in `isBestSpotFor`).

Finally, we created a test suite called `Cohesive` that verified the collision of our predicates in how they may actually be used in the real world (all in tandem). These tests combined all our predicates for the working system as a means of verifying the integrity of our system on a higher level, not just unit by unit.


Overall we tried to be rigorous in our testing, making use of the different features of Forge, and being sure that all predicates used had some form of positive and negative testing. We included comments within the each testing suite to describe the conditions that we were testing for in each predicate. To be specific, the tests that verified our domain are the ones related to `validCourse`, `validCandidate`, `correctNumApplications` etc. The tests more specific for testing the model itself would be `Cohesive`, `EndState`, `noWailistOnNeededCourse`, etc.

One note on testing is that we didn't use induction or traces as a means of verification due to the parallel nature of the hiring process (it is far from linear). Thus, after discussion with Prof Tim, we decided to do what we felt most important for the situation, which was mostly look at the final state (the allocation).

## Documentation

We used inline and doc comments to describe our predicates, testing suites, and in some cases, write out criteria we were trying to cover through constraints.