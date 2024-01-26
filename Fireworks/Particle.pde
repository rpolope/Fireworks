public class Particle 
{
  ParticleType _type;

  PVector _s;   // Position (m)
  PVector _v;   // Velocity (m/s)
  PVector _a;   // Acceleration (m/(s*s))
  PVector _F;   // Force (N)
  PVector _fd;
  float _kd = -1;
  float _m;   // Mass (kg)

  int _ttl;   // Time to live (iterations)
  color _color;   // Color (RGB)
  
  final static int _particleSize = 2;   // Size (pixels)
  final static int _casingLength = 25;   // Length (pixels)

  Particle(ParticleType type, PVector s, PVector v, float m, int ttl, color c) 
  {
    _type = type;
    
    _s = s.copy();
    _v = v.copy();
    _m = m;

    _a = new PVector(0.0 ,0.0, 0.0);
    _F = new PVector(0.0, 0.0, 0.0);
   
    _fd = new PVector(0.0, 0.0, 0.0);
   
    _ttl = ttl;
    _color = c;
  }

  void run() 
  {
    update();
    display();
  }

  void update() 
  {
    if (isDead())
      return;
      
    updateForce();
       
    _s.add(PVector.mult(_v, SIM_STEP));
    _v.add(PVector.mult(_a, SIM_STEP));
    
    _a = PVector.div(_F, _m);
    
    _ttl--;
  }
  
  void updateForce()
  {
    
    PVector Fwv = new PVector();
    
    Fwv = _windVelocity.copy();

    Fwv.cross(_v);
    
    _F.add(G); 
    _F.add(Fwv);
    
  }
  
  PVector getPosition()
  {
    return _s;
  }

  void display() 
  {
    
    switch (_type)
    {
      case CASING:
      
        stroke(_color);
      
        circle(_s.x, _s.y, 20);
      
        break;
        
      case REGULAR_PARTICLE:
      
        stroke(_color);
      
        circle(_s.x, _s.y, 5);
      
        break;
       
    }
    
  }
  
  boolean isDead() 
  {
    if (_ttl < 0.0) 
      return true;
    else
      return false;
  }
}
