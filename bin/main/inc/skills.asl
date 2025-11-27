// plan to execute goals

+!site_prepared      // the goal
   <- prepareSite.   // action on the simulated house (in GUI artifact)
+!floors_laid        // the goal
   <- layFloors.     // action on the simulated house (in GUI artifact)
+!walls_built        // the goal
   <- buildWalls.    // action on the simulated house (in GUI artifact)
+!roof_built         // the goal
   <- buildRoof.    // action on the simulated house (in GUI artifact)
+!windows_fitted     // the goal
   <- fitWindows.    // action on the simulated house (in GUI artifact)
+!doors_fitted       // the goal
   <- fitDoors.    // action on the simulated house (in GUI artifact)
+!electrical_system_installed         // the goal
   <- installElectricalSystem.    // action on the simulated house (in GUI artifact)
+!plumbing_installed       // the goal
   <- installPlumbing.    // action on the simulated house (in GUI artifact)
+!exterior_painted         // the goal
   <- paintExterior.    // action on the simulated house (in GUI artifact)
+!interior_painted         // the goal
   <- paintInterior.    // action on the simulated house (in GUI artifact)
