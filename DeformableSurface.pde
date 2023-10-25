import java.util.TreeMap;

public class DeformableSurface 
{
  float _lengthX;   // Length of the surface in X direction (m)
  float _lengthY;   // Length of the surface in Y direction (m)
  
  int _numNodesX;   // Number of nodes in X direction
  int _numNodesY;   // Number of nides in Y direction

  SpringLayout _springLayout;  // Physical layout of the springs that define the surface
  boolean _isUnbreakable;   // True if the surface cannot be broken
  color _color;   // Color (RGB)

  Particle[][] _nodes;   // Particles defining the surface
  ArrayList<DampedSpring> _springsSurface;   // Springs joining the particles
  TreeMap<String, DampedSpring> _springsCollision;   // Springs for collision handling


  DeformableSurface(float lengthX, float lengthY, int numNodesX, int numNodesY, float surfacePosZ, float nodeMass, float Ke, float Kd, float maxForce, float breakLengthFactor, SpringLayout springLayout, boolean isUnbreakable, color c)
  {
    _lengthX = lengthX;
    _lengthY = lengthY;

    _numNodesX = numNodesX;
    _numNodesY = numNodesY;
    
    _springLayout = springLayout;
    _isUnbreakable = isUnbreakable;
    _color = c;

    _nodes = new Particle[_numNodesX][_numNodesY];
    _springsSurface = new ArrayList();
    _springsCollision = new TreeMap<String, DampedSpring>();

    createNodes(surfacePosZ, nodeMass);
    createSurfaceSprings(Ke, Kd, maxForce, breakLengthFactor);
  }

  void createNodes(float surfacePosZ, float nodeMass)
  {
    /* Este método debe dar valores al vector de nodos ('_nodes') en función del
       tamaño que tenga la malla y de las propiedades de ésta (número de nodos, 
       masa de los mismos, etc.).
     */
     PVector _v = new PVector(0.0,0.0,0.0);
     float lux = _lengthX/_numNodesX;
     float luy = _lengthY/_numNodesY;
     boolean clamp = false;
     
     for(int i = 0; i < _numNodesX; i++)
     {
       for(int j = 0; j < _numNodesY; j++)
       {
         if(i == 0 || j == 0 || i == _numNodesX - 1 || j == _numNodesY -1) //Comprobamos que son los bordes de la malla
           clamp = true;
         else
           clamp = false;
          PVector _s = new PVector(i*lux -_lengthX/2,j*luy - _lengthY/2,surfacePosZ);
         _nodes[i][j] = new Particle(_s,_v,nodeMass,clamp);
       }
     }
  }

  void createSurfaceSprings(float Ke, float Kd, float maxForce, float breakLengthFactor)
  {
    /* Este método debe añadir muelles a la lista de muelles de la malla ('_springsSurfaces')
       en función de la disposición deseada para éstos dentro de la malla, y de los parámetros
       de los muelles (Ke, Kd, etc.).
     */
     
     switch(_springLayout)
     {
       case STRUCTURAL:
         for(int i = 0; i < _numNodesX - 1; i++)
         {
           for(int j = 0; j < _numNodesY - 1; j++)
           {
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce, breakLengthFactor));
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce, breakLengthFactor));
           }
         }
       break;
       
       case SHEAR:
       
         for(int i = 0; i < _numNodesX; i++)
         {
           for(int j = 0; j < _numNodesY; j++)
           {
             if(j == 0 && i < _numNodesX - 1) 
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce,breakLengthFactor ));
             else if(j == _numNodesY && i <_numNodesX - 1) 
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd, false, maxForce,breakLengthFactor ));
             else if(i < _numNodesX - 1 && j < _numNodesY - 1) 
             {
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd, false, maxForce,breakLengthFactor ));
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce,breakLengthFactor ));
             }
           }
         }
       break;
       
       case STRUCTURAL_AND_SHEAR:
         for(int i = 0; i <= _numNodesX - 1; i++)
         {
           for(int j = 0; j < _numNodesY - 1; j++)
           {
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce, breakLengthFactor));
             if(i < _numNodesX -1)
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce, breakLengthFactor));
           }
         }
         
         
         for(int i = 0; i < _numNodesX; i++)
         {
           
           for(int j = 0; j < _numNodesY; j++)
           {
             
             if(j == 0 && i < _numNodesX - 1) 
             
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce,breakLengthFactor ));
               
             else if(j == _numNodesY && i <_numNodesX - 1)
             
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd, false, maxForce,breakLengthFactor ));
               
             else if(i < _numNodesX - 1 && j < _numNodesY - 1) 
             {
               
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd, false, maxForce,breakLengthFactor ));
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce,breakLengthFactor ));
             
             }
           
           }
           
         }
         
       break;
       
       case STRUCTURAL_AND_BEND:
       
       
         for(int i = 0; i <= _numNodesX - 1; i++)
         {
           
           for(int j = 0; j < _numNodesY - 1; j++)
           {
             
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce, breakLengthFactor));
             
             if(i < _numNodesX -1)
             
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce, breakLengthFactor));
           
           }
           
         }
         
         
         for(int i = 0; i <= _numNodesX - 1; i++)
         {
           
           for(int j = 0; j < _numNodesY - 2; j++)
           {
             
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd, false, maxForce, breakLengthFactor));
             
             if(i < _numNodesX -2)
             
                _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd, false, maxForce, breakLengthFactor));
           
           }
           
         }
         
       break;
       
       case STRUCTURAL_AND_SHEAR_AND_BEND:
       
       
         for(int i = 0; i <= _numNodesX - 1; i++)
         {
           
           for(int j = 0; j < _numNodesY - 1; j++)
           {
             
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd, false, maxForce, breakLengthFactor));
             
             if(i < _numNodesX -1)
             
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd, false, maxForce, breakLengthFactor));
           
           }
           
         }
         
         
         for(int i = 0; i < _numNodesX; i++)
         {
           
           for(int j = 0; j < _numNodesY; j++)
           {
             
             if(j == 0 && i < _numNodesX - 1)
             
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce,breakLengthFactor ));
               
             else if(j == _numNodesY && i <_numNodesX - 1)
            
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd, false, maxForce,breakLengthFactor ));
               
             else if(i < _numNodesX - 1 && j < _numNodesY - 1)
             {
               
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd, false, maxForce,breakLengthFactor ));
               _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd, false, maxForce,breakLengthFactor ));
             
             }
             
           }
           
         }
         
         
         for(int i = 0; i <= _numNodesX - 1; i++)
         {
           
           for(int j = 0; j < _numNodesY - 2; j++)
           {
             
             _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd, false, maxForce, breakLengthFactor));
             
             if(i < _numNodesX -2)
             
                _springsSurface.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd, false, maxForce, breakLengthFactor));
           
           }
           
         }
         
       break;
       
     }  
     
  }

  void update(float simStep)
  {
    int i, j;

    for (i = 0; i < _numNodesX; i++)
      for (j = 0; j < _numNodesY; j++)
        if (_nodes[i][j] != null)
          _nodes[i][j].update(simStep);

    for (DampedSpring s : _springsSurface) 
    {
      s.update(simStep);
      s.applyForces();
    }

    for (DampedSpring s : _springsCollision.values()) 
    {
      s.update(simStep);
      s.applyForces();
    }
  }

  void avoidCollision(Ball b, float Ke, float Kd, float maxForce, float breakLengthFactor)
  {
    /* Este método debe evitar la colisión entre la esfera y la malla deformable. Para ello
       se deben crear muelles de colisión cuando se detecte una colisión. Estos muelles
       se almacenarán en el diccionario '_springsCollision'. Para evitar que se creen muelles 
       duplicados, el diccionario permite comprobar si un muelle ya existe previamente y 
       así usarlo en lugar de crear uno nuevo.
     */
     
     DampedSpring muelle;
     Particle part;
     PVector distancia = new PVector();
     
     for(int i = 0; i < _numNodesX -1; i++)
     {
       
       for(int j = 0; j < _numNodesY -1; j++)
       {
         
         part = _nodes[i][j];
         distancia = PVector.sub(part.getPosition(),b.getPosition());
         
         if(distancia.mag() <= b.getRadius()) //Si chocan
         {
           
           muelle = new DampedSpring(b, part, Ke, Kd, true, maxForce, breakLengthFactor);
           
           String id = Integer.toString(part.getId());
           
           if(!_springsCollision.containsKey(id))
             _springsCollision.put(id, muelle);
             
         }
         
         else
         {
           
           String id = Integer.toString(part.getId());
           if(_springsCollision.containsKey(id))
           
             _springsCollision.remove(id);
             
         }
         
       }
       
     }
     
  }

  void draw()
  {
    if (_isUnbreakable) 
       drawWithQuads();
    else
       drawWithSegments();
  }

  void drawWithQuads()
  {
    int i, j;
    
    fill(255);
    stroke(_color);

    for (j = 0; j < _numNodesY - 1; j++)
    {
      beginShape(QUAD_STRIP);
      for (i = 0; i < _numNodesX; i++)
      {
        if ((_nodes[i][j] != null) && (_nodes[i][j+1] != null))
        {
          PVector pos1 = _nodes[i][j].getPosition();
          PVector pos2 = _nodes[i][j+1].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }
  }

  void drawWithSegments()
  {
    stroke(_color);

    for (DampedSpring s : _springsSurface) 
    {
      if (!s.isBroken())
      {
        PVector pos1 = s.getParticle1().getPosition();
        PVector pos2 = s.getParticle2().getPosition();

        line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      }
    }
  }
}
