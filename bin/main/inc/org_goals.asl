// plan to execute goals

+!site_prepared      // the goal
   <- prepareSite.   // action on the simulated house (in GUI artifact)
+!floors_laid                   <- layFloors.
+!walls_built                   <- buildWalls.
+!roof_built                    <- buildRoof.
+!windows_fitted                <- fitWindows.
+!doors_fitted                  <- fitDoors.
+!electrical_system_installed   <- installElectricalSystem.
+!plumbing_installed            <- installPlumbing.
+!exterior_painted              <- paintExterior.
+!interior_painted              <- paintInterior.
