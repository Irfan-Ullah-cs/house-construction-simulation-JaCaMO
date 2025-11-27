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

-!discover_art(ToolName)
   <- .wait(100);
      !discover_art(ToolName).

+!discover_tuple_space
   <- lookupArtifact("tuple_space_id", TupleSpaceId);
      focus(TupleSpaceId);
      +tuple_space_art_id(TupleSpaceId).

// === ROOM COORDINATION (Exercise 2 Part 2) ===

// Room mapping for parallelism
room_for_task("SitePreparation", "kitchen").
room_for_task("Floors", "kitchen").
room_for_task("Walls", "kitchen").
room_for_task("Roof", "bedroom1").
room_for_task("WindowsDoors", "bedroom2").
room_for_task("Plumbing", "kitchen").
room_for_task("ElectricalSystem", "bathroom").
room_for_task("Painting", "bedroom1").

+winner(Task)[source(Owner)] : not coordinating
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      ?room_for_task(Task, Room);
      in(Room, Day)[artifact_id(TupleSpaceId)];
      out(Room, Day + 1)[artifact_id(TupleSpaceId)];
      +coordinating;
      out(task_info, MeStr, Task, Room, Day)[artifact_id(TupleSpaceId)];
      out(ready, MeStr)[artifact_id(TupleSpaceId)];
      println(Me, " reserved ", Room, " day ", Day, " for ", Task);
      .wait(4000);
      !show_shared_info.

+winner(Task)[source(Owner)] : coordinating
   <- ?tuple_space_art_id(TupleSpaceId);
      .my_name(Me);
      .term2string(Me, MeStr);
      ?room_for_task(Task, Room);
      in(Room, Day)[artifact_id(TupleSpaceId)];
      out(Room, Day + 1)[artifact_id(TupleSpaceId)];
      out(task_info, MeStr, Task, Room, Day)[artifact_id(TupleSpaceId)];
      out(ready, MeStr)[artifact_id(TupleSpaceId)];
      println(Me, " reserved ", Room, " day ", Day, " for ", Task).

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
      println(MeStr, " PARALLEL SCHEDULE:");
      for (temp_info(Agent, Task, Room, Day)) {
         println("  ", Agent, ": ", Task, " in ", Room, " on day ", Day)
      };
      for (temp_info(Agent, Task, Room, Day)) {
         out(task_info, Agent, Task, Room, Day)[artifact_id(TupleSpaceId)]
      };
      .abolish(temp_info(_,_,_,_)).

+!collect_all_tuples(TupleSpaceId)
   <- inp(task_info, Agent, Task, Room, Day)[artifact_id(TupleSpaceId)];
      +temp_info(Agent, Task, Room, Day);
      !collect_all_tuples(TupleSpaceId).

-!collect_all_tuples(TupleSpaceId)
   <- true.

+!release_lock(TupleSpaceId, MeStr)
   <- inp(display_lock, MeStr)[artifact_id(TupleSpaceId)].

-!release_lock(TupleSpaceId, MeStr)
   <- true.
