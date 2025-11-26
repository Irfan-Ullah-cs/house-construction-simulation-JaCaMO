// This company bids for site preparation
// Strategy: decreasing its price by 150 until its minimal value

// Inclusion of standards agent's behavior to make agents able to work in an JaCaMo environment
{ include("$jacamoJar/templates/common-cartago.asl") }
// Inclusion of common behaviors for this application
{ include("common.asl") }

// initial belief
my_price(1500). 
my_task("SitePreparation").

// initial goal to discover artifact
!start.

// Plan for start with source annotation
+!start[source(self)]
   <- !present_skills;
      !discover_tuple_space.

// Plan for present_skills with source annotation
+!present_skills[source(self)] : true
   <- .my_name(Me);
      println(Me, ": Presenting capabilities to owner agent.");
      for ( my_task(Task) ) {
         .send(giacomo, tell, my_task(Task));
      }.

+currentBid(V)[artifact_id(Art)]        // there is a new value for current bid
    : not i_am_winning(Art) &           // I am not the winner
      my_price(P) & P < V               // I can offer a better bid
   <- println("[companyB] placing bid ", P, " for artifact ", Art, " (currentBid=", V, ")");
      bid( math.max(V-150,P) ).         // place my bid offering a cheaper service

/* plans for execution phase */

{ include("org_code.asl") }
{ include("skills.asl") }

