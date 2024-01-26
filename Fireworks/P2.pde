enum RocketType 
{
  circulo,
  espiral,
  estrella,
  aleatorio
}

final int NUM_ROCKET_TYPES = RocketType.values().length;

enum ParticleType 
{
  CASING,
  REGULAR_PARTICLE 
}

// Particle control:

FireWorks _fw;   // Main object of the program
int _numParticles = 0;   // Number of particles of the simulation

// Problem paramaters:

final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, Gc);   // Acceleration due to gravity (m/(s*s))
PVector _windVelocity = new PVector(10.0, 0.0);   // Wind velocity (m/s)
final float WIND_CONSTANT = 1.0;   // Constant to convert apparent wind speed into wind force (Kg/s)
RocketType type = RocketType.aleatorio;

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)
final float SIM_STEP = 0.02;   // Simulation step (s)

// Output control:

PrintWriter _output;
final String FILE_NAME = "data.txt";


void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen();
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();

  _fw = new FireWorks();
  _numParticles = 0;
  
  _output = createWriter(FILE_NAME);
  

}

void printInfo()
{
  fill(255);
  text("Number of particles : " + _numParticles, width*0.025, height*0.05);
  text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.075);
  text("Elapsed time = " + _elapsedTime + " s", width*0.025 , height*0.1);
  text("Simulated time = " + _simTime + " s ", width*0.025, height*0.125);
  text("Viento", 85, 170);
  text("Aleatorio -> '0'", 70, 270);
  text("Circulo -> '1'", 70, 280);
  text("Espiral -> '2'", 70, 290);
  text("Estrella -> '3'", 70, 300);
  text("2024-> '4'", 70, 310);
}

void drawWind()
{
  stroke(255);
  
  //Palo
  
  line(100, 200, _windVelocity.x+100 , _windVelocity.y+200);
  
  
  circle(_windVelocity.x+100 , _windVelocity.y+200, 8);
  circle(100,200,5);
  
}

void draw()
{
  
  _output.println(frameRate + " " + _numParticles + " " + _simTime);

  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  
  _fw.run();
  printInfo();  
  drawWind();
}

void mousePressed()
{
  PVector pos = new PVector(mouseX, mouseY);
  PVector vel = new PVector((pos.x - width/2), (pos.y - height));
  color c = color(random(255),random(255),random(255));

  _fw.addRocket(type, new PVector(width/2, height), vel, c);
}

void keyPressed()
{
  if(keyCode == RIGHT)
  {
    _windVelocity.x += 1.0;
  }
  else if(keyCode == LEFT)
  {
    _windVelocity.x -= 1.0;
  }
  else if(keyCode == UP)
  {
    _windVelocity.y -= 1.0;
  }
  else if(keyCode == DOWN)
  {
    _windVelocity.y += 1.0;
  }
  else if(keyCode == '0')
  {
    type = RocketType.aleatorio;   
  
  }
  else if(keyCode == '1')
  {
    type = RocketType.circulo;   
  
  }
  else if(keyCode == '2')
  {
    type = RocketType.espiral;   
  
  }
  else if(keyCode == '3')
  {
    type = RocketType.estrella;   
  
  }
  
}

void stop()
{
  _output.flush();
  _output.close();
}
