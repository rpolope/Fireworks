public class Rocket 
{
  RocketType _type;

  Particle _casing;
  Particle particle;
  ArrayList<Particle> _particles;
  
  PVector _launchPoint;
  PVector _launchVel;  
  PVector _explosionPoint;
  
  color _color;
  boolean _hasExploded;

  Rocket(RocketType type, PVector pos, PVector vel, color c) 
  {
    _type = type;
    _particles = new ArrayList<Particle>();
    
    _launchPoint = pos.copy();
    _launchVel = vel.copy();
    _explosionPoint = new PVector(0.0, 0.0, 0.0);
    
    _color = c;
    _hasExploded = false;
    
    createCasing();
  }
  
  void createCasing()
  { 
    
    _casing = new Particle(ParticleType.CASING, _launchPoint, _launchVel, 10, 50, _color);
    
    _numParticles ++;
    
  }

  void explosion() 
  {
    
    PVector v = new PVector();
    
    float angle = 0;
    float incAngle = (2*PI)/50;
    float r = 100;
    
    switch (_type)
    {
      
      case circulo:
        for (int i = 0; i < 200; i++) {
          float x = r * cos(angle);
          float y = r * sin(angle);
          v.set(x, y -r/2);
          
          particle = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, v, 5, 200, _color);
          
          _particles.add(particle);
          
          _numParticles++;
          
          angle += incAngle;
        }
      break;

        
      case espiral:
        
        for(int i = 0; i < 200; i++){
          
          r += 0.2;
          
          if (r > 50)
            r = 0;
          
          v.add(r*cos(angle),r*sin(angle));
          
          particle = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint , v , 5, 200, _color);
        
          _particles.add(particle);
          
          _numParticles ++;

          
          angle += incAngle;
        
        }
      
     break;
        
     case estrella:
      float outerRadius = 2 * r;
      float innerRadius = r / 2;
    
      for (int i = 0; i < 10; i++) {
        float angleOuter = angle + i * PI / 5;
        float angleInner = angleOuter + PI / 5;
    
        float xOuter = outerRadius * cos(angleOuter);
        float yOuter = outerRadius * sin(angleOuter);
        v.set(xOuter, yOuter);
        particle = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, v, 5, 200, _color);
        _particles.add(particle);
        _numParticles++;
    
        float xInner = innerRadius * cos(angleInner);
        float yInner = innerRadius * sin(angleInner);
        v.set(xInner, yInner);
        particle = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint, v, 5, 200, _color);
        _particles.add(particle);
        _numParticles++;
      }
     break;

     case aleatorio:
        
        for(int i = 0; i < 200; i++){
          
          v.add(random(-50,50),random(-50,50));
          
          particle = new Particle(ParticleType.REGULAR_PARTICLE, _explosionPoint , v , 5, 200, _color);
        
          _particles.add(particle);
          
          _numParticles ++;
          
          angle += incAngle;
        
        }
      
     break;
       
       
    }
  }

  void run() 
  {
    // Código con la lógica de funcionamiento del cohete. En principio no hay que modificarlo.
    // Si la carcasa no ha explotado, se simula su ascenso.
    // Si la carcasa ha explotado, se genera su explosión y se simulan después las partículas creadas.
    // Cuando una partícula agota su tiempo de vida, es eliminada.
    
    if (!_casing.isDead())
      _casing.run();
    else if (_casing.isDead() && !_hasExploded)
    {
      _numParticles--;
      _hasExploded = true;

      _explosionPoint = _casing.getPosition().copy();
      explosion();
    }
    else
    {
      for (int i = _particles.size() - 1; i >= 0; i--) 
      {
        Particle p = _particles.get(i);
        p.run();
        
        if (p.isDead()) 
        {
          _numParticles--;
          _particles.remove(i);
        }
      }
    }
  }
}
