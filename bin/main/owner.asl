{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
{ include("common.asl") }
{ include("inc/skills.asl") }

my_preference("Floors",          1000).
my_preference("Walls",           1000).
my_preference("Roof",            2000).
my_preference("WindowsDoors",    2500).
my_preference("Plumbing",         500).
my_preference("ElectricalSystem", 500).
my_preference("Painting",        1200).
my_preference("SitePreparation", 2000).

reputation(companyB,"Floors",0.9).
reputation(companyB,"Walls",0.6).
reputation(companyB,"Roof",0.7).
reputation(companyB,"WindowsDoors",0.75).
reputation(companyB,"Plumbing",0.65).
reputation(companyB,"ElectricalSystem",0.55).
reputation(companyB,"Painting",0.85).
reputation(companyB,"SitePreparation",0.8).

reputation(companyE,"Floors",0.7).
reputation(companyE,"Walls",0.8).
reputation(companyE,"Roof",0.75).
reputation(companyE,"WindowsDoors",0.6).
reputation(companyE,"Plumbing",0.7).
reputation(companyE,"ElectricalSystem",0.65).
reputation(companyE,"Painting",0.7).
reputation(companyE,"SitePreparation",0.6).

reputation(companyA,"Floors",0.5).
reputation(companyA,"Walls",0.6).
reputation(companyA,"Roof",0.55).
reputation(companyA,"WindowsDoors",0.5).
reputation(companyA,"Plumbing",0.9).
reputation(companyA,"ElectricalSystem",0.5).
reputation(companyA,"Painting",0.5).
reputation(companyA,"SitePreparation",0.5).

reputation(companyD,"Floors",0.6).
reputation(companyD,"Walls",0.65).
reputation(companyD,"Roof",0.6).
reputation(companyD,"WindowsDoors",0.65).
reputation(companyD,"Plumbing",0.6).
reputation(companyD,"ElectricalSystem",0.9).
reputation(companyD,"Painting",0.6).
reputation(companyD,"SitePreparation",0.55).

reputation(companyC,"Floors",0.85).
reputation(companyC,"Walls",0.7).
reputation(companyC,"Roof",0.8).
reputation(companyC,"WindowsDoors",0.85).
reputation(companyC,"Plumbing",0.75).
reputation(companyC,"ElectricalSystem",0.7).
reputation(companyC,"Painting",0.8).
reputation(companyC,"SitePreparation",0.75).

min_reputation(0.6).

number_of_tasks(NS) :- .findall( S, task(S), L) & .length(L,NS).

enough_winners :- number_of_tasks(NS) &
       .findall( ArtId, currentWinner(A)[artifact_id(ArtId)] & A \== "no_winner", L) &
       .length(L, NS).

agents_for_task(Task, Agents) :-
   .findall( Ag, agent_can_do(Ag, Task), Agents).

trusted_agents_for_task(Task, Agents) :-
   min_reputation(Min) &
   .findall(Ag, agent_can_do(Ag,Task) & reputation(Ag,Task,R) & R >= Min, Agents).

!start_auction.

+sitePrepared : true <- .print("site has been prepared !!!! :-)").
+interiorPainted : true <- .print("interior has been painted !!!! :-)").
+exteriorPainted : true <- .print("exterior has been painted !!!! :-)").
+electricalSystemInstalled : true <- .print("electrical system has been installed !!!! :-)").
+plumbingInstalled : true <- .print("plumbing has been installed !!!! :-)").
+windowsFitted : true <- .print("windows have been fitted !!!! :-)").
+doorsFitted : true <- .print("doors have been fitted !!!! :-)").
+roofBuilt : true <- .print("roof has been built !!!! :-)").
+wallsBuilt : true <- .print("walls have been built !!!! :-)").
+floorsLayed : true <- .print("floors have been layed !!!! :-)").

+!start_auction
   <- !presentation_phase;
      !wait_for_bids.

+!presentation_phase
   <- println("Starting presentation phase.");
      !discover_tuple_space;
      !prepare_site;
      .wait(5000);
      println("Gathering agent information...");
      !gather_agent_capabilities;
      !invite_agents_to_auctions.

+!discover_tuple_space
   <- lookupArtifact("tuple_space_id", TupleSpaceId);
      focus(TupleSpaceId);
      +tuple_space_art_id(TupleSpaceId).

+!prepare_site
   <- ?tuple_space_art_id(TupleSpaceId);
      out(display_lock, owner)[artifact_id(TupleSpaceId)].

+!gather_agent_capabilities
   <- println("Agent capabilities collection completed.").

+!invite_agents_to_auctions
   <- for ( my_preference(Task, MaxPrice) ) {
         ?trusted_agents_for_task(Task, Agents);
         .length(Agents, N);
         if (N > 0) {
            !create_auction_and_invite(Task, MaxPrice, Agents);
         } else {
            println("No trusted agents available for task: ", Task);
            ?agents_for_task(Task, AgentsAll);
            .length(AgentsAll, NAll);
            if (NAll > 0) {
               !create_auction_and_invite(Task, MaxPrice, AgentsAll);
            } else {
               println("No agents capable of performing task: ", Task);
            }
         }
      }.

+!create_auction_and_invite(Task, MaxPrice, Agents)
   <- .concat("auction_for_", Task, ArtName);
      makeArtifact(ArtName, "tools.AuctionArt", [Task, MaxPrice], ArtId);
      focus(ArtId);
      println("Auction artifact created: ", ArtName, " for task: ", Task);
      for ( .member(Ag, Agents) ) {
         .send(Ag, tell, auction_to_use(Task, ArtName));
         println("Invitation sent to agent ", Ag, " for task: ", Task);
      }.

+my_task(Task)[source(Ag)]
   <- println("Received capability notification from ", Ag, " for task: ", Task);
      +agent_can_do(Ag, Task).

+!wait_for_bids
   <- println("Waiting for bids (5 seconds)...");
      .wait(5000);
      !show_winners.

+!show_winners
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
         ?currentBid(Price)[artifact_id(ArtId)];
         ?task(Task)[artifact_id(ArtId)];
         println("Auction winner for task ", Task, ": ", Ag, " with bid ", Price);
         if (Ag \== "no_winner") {
            .send(Ag, tell, winner(Task))
         }
      };
      println("========================================");
      println("AUCTION COMPLETE! To start execution, type: !go");
      println("========================================").

+!go <-
      .my_name(Me);
      createWorkspace("ora4mas");
      joinWorkspace("ora4mas",WOrg);
      makeArtifact(ora4mas, "ora4mas.nopl.OrgBoard", ["src/org/house-os.xml"], OrgArtId)[wid(WOrg)];
      focus(OrgArtId);
      createGroup(hsh_group, house_group, GrArtId);
      debug(inspector_gui(on))[artifact_id(GrArtId)];
      adoptRole(house_owner)[artifact_id(GrArtId)];
      focus(GrArtId);
      !contract_winners("hsh_group");
      createScheme(bhsch, build_house_sch, SchArtId);
      debug(inspector_gui(on))[artifact_id(SchArtId)];
      focus(SchArtId);
      ?formationStatus(ok)[artifact_id(GrArtId)];
      addScheme("bhsch")[artifact_id(GrArtId)];
      commitMission("management_of_house_building")[artifact_id(SchArtId)];
      .wait(120000).

+!contract_winners(GroupName) : enough_winners
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
            ?task(Task)[artifact_id(ArtId)];
            println("Establishing contract with ", Ag, " for task: ", Task);
            .send(Ag, achieve, contract(Task,GroupName)) 
      }.

+!contract_winners(_)
   <- println("** I didn't find enough builders!");
      .fail.

+?formationStatus(ok)[artifact_id(G)]
   <- .wait({+formationStatus(ok)[artifact_id(G)]}).

+!house_built
   <- println("*** Finished ***").
