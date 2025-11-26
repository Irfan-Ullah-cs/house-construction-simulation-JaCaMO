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

+winner(Task)[source(Owner)] : not coordinating
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      +coordinating;
      +my_winning_task(Task);
      out(task_info, MeStr, Task)[artifact_id(TupleSpaceId)];
      out(done, MeStr)[artifact_id(TupleSpaceId)];
      println(Me, " won task: ", Task);
      .wait(1500);
      !show_shared_info.

+winner(Task)[source(Owner)] : coordinating
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      +my_winning_task(Task);
      out(task_info, MeStr, Task)[artifact_id(TupleSpaceId)];
      println(Me, " won task: ", Task).

// Step 5 - Plan for showing all shared info except own
+!show_shared_info
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      println(Me, " sees shared auction info:");
      !collect_all_tuples(TupleSpaceId, []).

+!collect_all_tuples(TupleSpaceId, Collected)
   <- inp(task_info, Agent, Task)[artifact_id(TupleSpaceId)];
      !collect_all_tuples(TupleSpaceId, [[Agent,Task]|Collected]).

-!collect_all_tuples(TupleSpaceId, Collected)
   <- .my_name(Me);
      .term2string(Me, MeStr);  // Convert ONCE here
      !restore_and_display(TupleSpaceId, Collected, MeStr).  // Pass STRING

+!restore_and_display(TupleSpaceId, [], MeStr)
   <- true.

+!restore_and_display(TupleSpaceId, [[Agent,Task]|Rest], MeStr)
   <- out(task_info, Agent, Task)[artifact_id(TupleSpaceId)];
      if (Agent \== MeStr) {  // Compare string to string directly
         println("  Agent: ", Agent, " won Task: ", Task);
      } else {
         println("DEBUG: FILTERED OUT my own task: ", Task);
      };
      !restore_and_display(TupleSpaceId, Rest, MeStr).  // Pass MeStr through recursion