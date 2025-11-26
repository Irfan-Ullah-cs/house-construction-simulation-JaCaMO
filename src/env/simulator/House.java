package simulator;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.util.ArrayList;

import javax.swing.JFrame;
import javax.swing.JPanel;

import cartago.OPERATION;
import cartago.tools.GUIArtifact;

public class House extends GUIArtifact {

    HouseView view;

    @Override
    public void init(){
        view = new HouseView();
        view.setVisible(true);
    }

    // Actions that simulate the building progress

    // simple logger for timestamps to help verify parallel execution
    private void logOp(String op, String phase) {
        System.out.println("[House] " + op + " " + phase + " @ " + System.currentTimeMillis());
    }

    @OPERATION void prepareSite(){
        logOp("prepareSite","START");
        view.addPart(new Site());
        logOp("prepareSite","DONE");
        signal("sitePrepared");
    }

    @OPERATION void layFloors(){
        logOp("layFloors","START");
        await_time(1000);
        view.addPart(new Floor());
        logOp("layFloors","DONE");
        signal("floorsLayed");
    }

    @OPERATION void buildWalls(){
        logOp("buildWalls","START");
        await_time(500);
        view.addPart(new Walls());
        logOp("buildWalls","DONE");
        signal("wallsBuilt");
    }

    @OPERATION void buildRoof(){
        logOp("buildRoof","START");
        await_time(1000);
        view.addPart(new Roof());
        logOp("buildRoof","DONE");
        signal("roofBuilt");
    }

    @OPERATION void fitDoors(){
        logOp("fitDoors","START");
        await_time(300);
        view.addPart(new Doors());
        logOp("fitDoors","DONE");
        signal("doorsFitted");
    }

    @OPERATION void fitWindows(){
        logOp("fitWindows","START");
        await_time(300);
        view.addPart(new Windows());
        logOp("fitWindows","DONE");
        signal("windowsFitted");
    }

    @OPERATION void paintExterior(){
        logOp("paintExterior","START");
        await_time(2000);
        view.addPart(new ExteriorPainting());
        logOp("paintExterior","DONE");
        signal("exteriorPainted");
    }

    @OPERATION void installPlumbing(){
        logOp("installPlumbing","START");
        await_time(300);
        view.addPart(new Plumbing());
        logOp("installPlumbing","DONE");
        signal("plumbingInstalled");
    }

    @OPERATION void installElectricalSystem(){
        logOp("installElectricalSystem","START");
        await_time(300);
        view.addPart(new ElectricalSystem());
        logOp("installElectricalSystem","DONE");
        signal("electricalSystemInstalled");
    }

    @OPERATION void paintInterior(){
        logOp("paintInterior","START");
        await_time(500);
        view.addPart(new InteriorPainting());
        logOp("paintInterior","DONE");
        signal("interiorPainted");
    }


    class HouseView extends JFrame {

        HousePanel           housePanel;
        ArrayList<HousePart> partsToDraw;

        public HouseView(){
            setTitle(" -- Home Sweet Home -- ");
            setSize(800,600);

            partsToDraw = new ArrayList<HousePart>();
            housePanel  = new HousePanel(this);
            setContentPane(housePanel);
        }

        public synchronized void addPart(HousePart part){
            partsToDraw.add(part);
            repaint();
        }

        @SuppressWarnings("unchecked")
        public synchronized ArrayList<HousePart> getParts(){
            return (ArrayList<HousePart>)partsToDraw.clone();
        }
    }

    class HousePanel extends JPanel {

        HouseView view;

        public HousePanel(HouseView view){
            this.view = view;
        }

        public void paintComponent(Graphics g) {
            super.paintComponent(g);

               g.setColor(Color.WHITE);
               Dimension size = getSize();
               g.fillRect(0, 0, size.width, size.height);

               for (HousePart part: view.getParts()){
                   part.draw(size,(Graphics2D)g);
               }
        }
    }
}
