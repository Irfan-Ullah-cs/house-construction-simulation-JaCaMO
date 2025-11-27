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
      +tuple_space_art_id(TupleSpaceId).

+winner(Task)[source(Owner)] : not coordinating
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      +coordinating;
      out(task_info, MeStr, Task)[artifact_id(TupleSpaceId)];
      out(ready, MeStr)[artifact_id(TupleSpaceId)];
      println(Me, " won task: ", Task);
      .wait(4000);
      !show_shared_info.

+winner(Task)[source(Owner)] : coordinating
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      out(task_info, MeStr, Task)[artifact_id(TupleSpaceId)];
      out(ready, MeStr)[artifact_id(TupleSpaceId)];
      println(Me, " won task: ", Task).

+!show_shared_info
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      !wait_for_all_ready(TupleSpaceId);
      !acquire_lock(TupleSpaceId, MeStr);
      !read_display_restore(TupleSpaceId, MeStr);
      !release_lock(TupleSpaceId, MeStr).

+!wait_for_all_ready(TupleSpaceId)
   <- .wait(1000).

+!acquire_lock(TupleSpaceId, MeStr)
   <- inp(display_lock, CurrentHolder)[artifact_id(TupleSpaceId)];
      .wait(100);
      !acquire_lock(TupleSpaceId, MeStr).

-!acquire_lock(TupleSpaceId, MeStr)
   <- out(display_lock, MeStr)[artifact_id(TupleSpaceId)].

+!read_display_restore(TupleSpaceId, MeStr)
   <- !collect_all_tuples(TupleSpaceId);
      println(MeStr, " sees shared auction info:");
      for (temp_info(Agent, Task) & Agent \== MeStr) {
         println("  Agent: ", Agent, " won Task: ", Task)
      };
      for (temp_info(Agent, Task)) {
         out(task_info, Agent, Task)[artifact_id(TupleSpaceId)]
      };
      .abolish(temp_info(_,_)).

+!collect_all_tuples(TupleSpaceId)
   <- inp(task_info, Agent, Task)[artifact_id(TupleSpaceId)];
      +temp_info(Agent, Task);
      !collect_all_tuples(TupleSpaceId).

-!collect_all_tuples(TupleSpaceId)
   <- true.

+!release_lock(TupleSpaceId, MeStr)
   <- inp(display_lock, MeStr)[artifact_id(TupleSpaceId)].

-!release_lock(TupleSpaceId, MeStr)
   <- true.