// Utility predicate
i_am_winning(Art) :- currentWinner(W)[artifact_id(Art)] & .my_name(Me) & .term2string(Me,MeS) & W == MeS.

// Present skills to owner
+!start[source(self)] : true
   <- !present_skills;
      !discover_tuple_space.

+!present_skills
   <- .my_name(Me);
      println(Me, ": Presenting capabilities to owner agent.");
      for ( my_task(Task) ) {
         .send(giacomo, tell, my_task(Task));
      }.

+auction_to_use(Task, ArtifactName)
   <- println("Received auction invitation for task: ", Task, " using artifact: ", ArtifactName);
      !discover_art(ArtifactName).

+!discover_art(ToolName)
   <- lookupArtifact(ToolName,ToolId);
      focus(ToolId).

+!discover_tuple_space
   <- lookupArtifact("tuple_space_id", TupleSpaceId);
      focus(TupleSpaceId);
      // Store the TupleSpaceId as a belief for later use if needed
      +tuple_space_art_id(TupleSpaceId).

// Plan triggered when agent receives winner(Task) belief
+winner(Task)[source(Owner)]
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      out(task_info, Me, Task)[artifact_id(TupleSpaceId)];
      out(done, Me)[artifact_id(TupleSpaceId)];
      println(Me, " won task: ", Task);
      // ===== Step c - RD, observing another tuple (Uncomment these for step 2) =====
      // rd(task_info, Other, Task);
      // println("I (", Me, ") see another tuple: (", Other, ",", Task, ")");

      // ===== Step 3 - IN, removing tuple (Uncomment these for step 3) =====
      // in(task_info, Other, Task);
      // println("I (", Me, ") removed tuple: (", Other, ",", Task, ")");

      // ===== Step 4 - Try to use rd/in on a non-existent template (Uncomment these for step 4) =====
      // rd(running_task, Other);
      // println("Tried to read a tuple (running_task, Other): ", Other);
      // in(running_task, Other);
      // println("Tried to remove tuple (running_task, Other): ", Other);

      // ===== Step 5 - Call show_shared_info to display other agents' tasks =====
      // .wait(10000); // Give other agents more time to post their tuples (5 seconds delay)
      // !show_shared_info;

      out(done, Me)[artifact_id(TupleSpaceId)];
      !wait_until_all_done(Me, TupleSpaceId);

.

+!wait_until_all_done(Me, TupleSpaceId)
   : count(done, X)[artifact_id(TupleSpaceId)] & X < 10   // 10 = number of agents
   <- .wait(200);
      !wait_until_all_done(Me, TupleSpaceId).

+!wait_until_all_done(Me, TupleSpaceId)
   : count(done, 10)[artifact_id(TupleSpaceId)]
   <- !show_shared_info.


// Step 5 - Plan for showing all shared info except own
+!show_shared_info
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      println(Me, " sees shared auction info:");
      !read_and_remove_all(Me, TupleSpaceId, []).

/* Recursive clause: read all tuples without removing them */
+!read_and_remove_all(Me, TupleSpaceId, Collected)
   : rdp(task_info, _, _)[artifact_id(TupleSpaceId)]
   <- rdp(task_info, Agent, Task)[artifact_id(TupleSpaceId)];
      !read_and_remove_all(Me, TupleSpaceId, [[Agent,Task]|Collected]).

/* Base clause */
+!read_and_remove_all(Me, TupleSpaceId, Collected)
   : not rdp(task_info, _, _)[artifact_id(TupleSpaceId)]
   <- for (.member([Agent, Task], Collected)) {
         if (Agent \== Me) {
            println("  Agent: ", Agent, " won Task: ", Task);
         }
      }.