public class DampedSpring
{
  Particle _p1;   // First particle attached to the spring
  Particle _p2;   // Second particle attached to the spring

  float _Ke;   // Elastic constant (N/m) 
  float _Kd;   // Damping coefficient (kg/m)

  float _lr;   // Rest length (m)
  float _l;    // Current length (m)
  float _lMax; // Maximum allowed distance before breaking apart (m)
  float _v;    // Current rate of change of length (m/s)

  PVector _e;   // Current elongation vector (m)
  PVector _eN;  // Current normalized elongation vector (no units)
  PVector _F;   // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)
  float _FMax;  // Maximum allowed force before breaking apart (N)

  boolean _broken;   // True when the spring is broken 
  boolean _repulsionOnly;   // True if the spring only works one way (repulsion only)


  DampedSpring(Particle p1, Particle p2, float Ke, float Kd, boolean repulsionOnly, float maxForce, float maxDist)
  {
    _p1 = p1;
    _p2 = p2;

    _Ke = Ke;
    _Kd = Kd;

    _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
    _eN = _e.copy();
    _eN.normalize();

    _l = _e.mag();
    _lr = _l; 

    _FMax = maxForce;
    _lMax = maxDist;

    _v = 0.0;
    _broken = false;
    _repulsionOnly = repulsionOnly;

    _F = new PVector(0.0, 0.0, 0.0);
  }

  Particle getParticle1()
  {
    return _p1;
  }
  
  Particle getParticle2()
  {
    return _p2;
  }
  
  void setRestLength(float restLength)
  {
    _lr = restLength;
  }
  
  void update(float simStep)
  {
    /* Este método debe actualizar todas las variables de la clase 
       que cambien según avanza la simulación (_e, _l, _v, _F, etc.),
       siguiendo las ecuaciones de un muelle con amortiguamiento lineal
       entre dos partículas.
     */
     
     PVector Fdamp = new PVector();
     PVector Fel = new PVector();
     float lini = _l;
     
     _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
     _eN = _e.copy();
     _eN.normalize();
     _l = _e.mag();
     
      
      if(_repulsionOnly)
      {
        Fel = PVector.mult(_eN,(_ball.getRadius() - _l)* -_Ke);
      }
      else
      {
        Fel = PVector.mult(_eN,(_lr - _l)* -_Ke);
      }
      
      _v = (lini - _l)/simStep;
      
      Fdamp = PVector.mult(_eN, _Kd * _v);
      _F = PVector.sub(Fel,Fdamp);
      
      if(!isBroken())
      {
        if(_F.mag() >= _FMax || _l >= _lr*_lMax)
        {
          breakIt();
          _F.set(0.0,0.0,0.0);
        }
      }
  }

  void applyForces()
  { 
    _p1.addExternalForce(_F);
    _p2.addExternalForce(PVector.mult(_F, -1.0));
  }

  boolean isBroken()
  {
    return _broken;
  }

  void breakIt()
  {
    _broken = true;
  }

  void fixIt()
  {
    _broken = false;
  }
}
