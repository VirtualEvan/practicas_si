import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.Random;
import java.util.logging.Logger;

public class MarsEnv extends Environment {

    public static final int GSize = 8; // grid size
    public static final int BLACK  = 16; // black cell code in grid model
	public static final int QUEEN  = 32; // queen code in grid model
	
	
    static Logger logger = Logger.getLogger(MarsEnv.class.getName());

    private MarsModel model;
    private MarsView  view;
    
    @Override
    public void init(String[] args) {
        model = new MarsModel();
        view  = new MarsView(model);
        model.setView(view);
    }
    
    @Override
    public boolean executeAction(String ag, Structure action) {
        logger.info(ag+" doing: "+ action);
        try {

                return false;

        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            Thread.sleep(200);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }
    

    class MarsModel extends GridWorldModel {
        
        private MarsModel() {
            super(GSize, GSize, 2);
			
			// initial location of garbage
            for(int x=0; x < GSize; x++)
			{
				for(int y=0; y<GSize; y++)
				{
					if((x+y)%2!=0){					
						add(BLACK, x, y);
					}
					add(QUEEN, x, y);
				}
			}
		}
        

    }
    
    class MarsView extends GridWorldView {

        public MarsView(MarsModel model) {
            super(model, "Mars World", 600);
            defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
            setVisible(true);
            repaint();
        }

        /** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int Object) {
            switch (Object) {
                case MarsEnv.BLACK: super.drawObstacle(g, x, y);	break;
				case MarsEnv.QUEEN: drawQueen(g, x, y);		break;
            }
        }

        
        public void drawQueen(Graphics g, int x, int y) {
			super.drawAgent(g, x, y, Color.cian, -1);
        }
    }    
}
