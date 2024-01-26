--pico-8 cartridge // http://www.pico-8.com
--version 41
--__lua__
-- cooperative la revanche
-- code pour les ateliers creation de jeux video

function _init()
  
player = {}
  -- position sur l'れたcran
  player.x = 32 -- position en x du joueur (ici au milieu de l'ecran)
  player.y = 32  -- position en y du joueur (ici au milieu de l'ecran)
  -- largeur et hauteur du personnage pour les collisions notamment
  player.l =  8 -- largeur du joueur en pixels ou en tiles (ici 8 pixels) 
  player.h =  8 -- hauteur du joueur en pixels ou en tiles (ici 8 pixels)
  -- direction en x et en y en fonction du mouvement
  player.dx = 0
  player.dy = 0
  player.friction = 0.5 -- friction de l'air pour que le personnage s'arrれちte si on appuie pas sur les boutons
  -- vitesse de dれたplacement du personnage
  player.vit = 2
  -- saut du personnage
  player.saut = 8 -- hauteur du saut (valeur positive)
  player.isgrounded = false -- interrupteur qui permet de savoir si le personnage touche le sol, false = le personnage ne touche pas le sol, true = le personnage touche le sol
  -- animations du personnage
  player.spr = 1-- sprite de base du joueur (ici le numero 1 de l'editeur de sprite )
  player.god = false -- interrupteur qui flip le sprite sur l'axe vertical, si god = false alors le sprite apparaれなtra れき l'れたcran tel qu'il est dessinれた dans l'れたditeur de sptite, god = false il sera invers&
  player.anim = "nothing"-- animation en cours d'utilisation
  player.nothing =  {f=1,st=1,sz=1,var=0,spd=1/15}-- animation pour la marche
  player.walk =  {f=2,st=2,sz=2,var=0,spd=1/8}-- animation pour la marche
  player.jump =  {f=4,st=4,sz=2,var=0,spd=1/8}-- animation pour le saut
  -- gestion du personnage (selon le gamplay)
  player.life = 1 -- points de vie du personnage au debut du jeu
  player.munitions = 1-- munitions du personnage

--changement
player2 = {}
  -- position sur l'れたcran
  player2.x = 56  -- position en x du joueur (ici au milieu de l'ecran)
  player2.y = 56  -- position en y du joueur (ici au milieu de l'ecran)
  -- largeur et hauteur du personnage pour les collisions notamment
  player2.l =  8 -- largeur du joueur en pixels ou en tiles (ici 8 pixels) 
  player2.h =  8 -- hauteur du joueur en pixels ou en tiles (ici 8 pixels)
  -- direction en x et en y en fonction du mouvement
  player2.dx = 0
  player2.dy = 0
  player2.friction = 0.5 -- friction de l'air pour que le personnage s'arrれちte si on appuie pas sur les boutons
  -- vitesse de dれたplacement du personnage
  player2.vit = 2
  -- saut du personnage
  player2.saut = 8 -- hauteur du saut (valeur positive)
  player2.isgrounded = false -- interrupteur qui permet de savoir si le personnage touche le sol, false = le personnage ne touche pas le sol, true = le personnage touche le sol
  -- animations du personnage
  player2.spr = 1-- sprite de base du joueur (ici le numero 1 de l'editeur de sprite )
  player2.god = false -- interrupteur qui flip le sprite sur l'axe vertical, si god = false alors le sprite apparaれなtra れき l'れたcran tel qu'il est dessinれた dans l'れたditeur de sptite, god = false il sera invers&
  player2.anim = "nothing"-- animation en cours d'utilisation
  player2.nothing =  {f=17,st=17,sz=1,var=0,spd=1/15}-- animation pour la marche
  player2.walk =  {f=18,st=18,sz=2,var=0,spd=1/8}-- animation pour la marche
  player2.jump =  {f=20,st=21,sz=2,var=0,spd=1/8}-- animation pour le saut
  -- gestion du personnage (selon le gamplay)
  player2.life = 1 -- points de vie du personnage au debut du jeu
  player2.munitions = 1-- munitions du personnage
  
  gravite = 0.5 -- valeur de gravitれた qui sera appliquれた en permanence au joueur, plus elle sera れたlevれたe et plus le joueur descendra vite vers le sol
  
  -- les tableaux ou variables ou fonctions nれたcessaires au lancement du programme
  diamants = {}
  enemis = {}
  placer_des_diamants(1,0,31,0,31)
  placer_des_enemis(2,0,31,0,31)
  desintegration = {}

  -- lancement de la musique du jeu
  music(0)
end 


function _update()
  
  move_player() -- le dれたplacement de player
  move_player2() -- le dれたplacement de player2 --changement
  choix_animation_player() -- choix des animations de player
  collision_player_diamants() -- gestion des collisions entre des diamants et player
  update_enemis()
  collision_player_enemis()

  

end




function _draw() -- la fonction affichera les れたlれたments les uns sur les autres en fonction de l'ordre d'れたcriture dans la fonction
  cls() -- nettoie l'れたcran, efface tout les れたlれたments affichれたs en dれたbut de cycle (rafraichissement)
  map() -- affiche la carte de l'れたditeur de carte de la tile 0,0 れき la tile 15,15 par dれたfaut
  
  --draw_player() -- fonction qui dessine le sprite de player
  draw_player_animation() -- fonction qui dessine et anime le sprite
  draw_diamants()
  draw_desintegration()
  draw_enemis()
  -- gestion de la camera, toujours a la fin de _draw()
  --update_camera_ecran() -- gere la camera et passe d'ecran れき ecran 
  update_camera_joueur(128,128) -- gere la camera et place le joueur au milieu de l'れたcran 
  draw_ui()
end 

function arrete_le_deplacement(player) -- stoppe le dれたplacement --ch angement
  if player.dx>0 then -- si le joueur va vers la droite
    player.dx-=player.friction -- on baisse progressivement la vitesse
  if player.dx<=0 then player.dx = 0 end -- pour arriver a zero
  elseif player.dx<0 then -- si le joueur va vers la gauche
    player.dx+=player.friction -- on ajoute a la vitesse pour
    if player.dx>=0 then player.dx = 0 end -- la ramener a zero
  end -- arrれちte de le dれたplacement en x
end

-- fontions pour un jeu de plateformes

--player1 --changement
function move_player()
 
  arrete_le_deplacement(player) --changement
  
  if btn(0) then 
    player.dx = -player.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btn(1) then 
    player.dx = player.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 
  
  if btn(4) and player.isgrounded then 
    player.dy -= player.saut -- lorsqu'on appuie sur la touche c du clavier on ajoute la valeur du saut au dれたplacement vers le haut (en nれたgatif)
  end 
   collision_map(player) 
end

--player2 --changement
function move_player2()
 
  arrete_le_deplacement(player2) 
  
  if btnp(0, 1) then 
    player2.dx = -player2.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player2.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btnp(1, 1) then 
    player2.dx = player2.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player2.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 
  
  if btnp(4, 1) and player2.isgrounded then 
    player2.dy -= player2.saut -- lorsqu'on appuie sur la touche c du clavier on ajoute la valeur du saut au dれたplacement vers le haut (en nれたgatif)
  end 
   collision_map(player2) 
end
  
 function collision_map(a) 
  -- les collisions sur la map
  -- les tuiles solides ont le flag 0
  
  -- verification des collisions en x
   a.x += a.dx -- on applique la direction en x a la position du joueur
   
  local collision_horizontale = mget((a.x+8)/8,(a.y+4)/8) -- on va vれたrifier la tile a droite du joueur
  if a.dx > 0 then -- si player va vers la droite
    if fget(collision_horizontale,0)  then -- si la tile est solide a droite de player 
      a.x = flr((a.x)/8)*8 -- on remet player a gauche de la tile
      a.dx = 0 -- on stoppe tout deplacement en x
    end
  end

  local  collision_horizontale = mget((a.x)/8,(a.y+4)/8) -- on va vれたrifier la tile a gauche du joueur
  if a.dx < 0 then -- si player va vers la gauche
    if fget(collision_horizontale,0) then -- si la tile est solide a gauche player
        a.x = flr((a.x+8)/8)*8 -- on remet player a droite de la tiles
        a.dx = 0 -- stop tout deplacement en x
    end
  end
  
   -- verification des collisions en y
   a.dy += gravite -- on applique sur la direction en y du player la gravite 
   if a.dy > 8 then a.dy = 8 end -- on bloque la vitesse de chute du personnage pour れたviter de traverser les murs si on chute de trop haut
   a.y += a.dy -- on ajoute la valeur dy au deplacement en y du joueur 

   local vertical_collision = mget((a.x+4)/8,(a.y+8)/8) -- verifie la tile en dessous de player

    a.isgrounded = false -- de base player n'est pas au sol

  if a.dy >= 0 then -- si player est en chute libre (y positif)
    if fget(vertical_collision,0) then -- si la tile est solide en dessous de player
     a.y = flr((a.y)/8)*8 -- on remet player en haut de la tiles
      a.dy = 0 -- on stop tout deplacement en y
      a.isgrounded = true -- on dit que c'est possible de sauter a nouveau car on touche le dol
    end
  end

  vertical_collision = mget((a.x+4)/8,(a.y)/8) -- verifie la tile au dessus de player

  if a.dy <= 0 then -- si player saute (y negatif)
    if fget(vertical_collision,0) then
      a.y = flr((a.y+8)/8)*8 -- on remet player en dessous de la tiles
      a.dy = 0 -- stop tout deplacement en y
    end
  end
end 

function draw_player() -- dessine juste le sprite sans animation 
  spr(player.spr,player.x,player.y,player.l/8,player.h/8,player.god) 
  spr(player2.spr,player2.x,player2.y,player2.l/8,player2.h/8,player2.god) --changement 
  
  -- fonction spr affiche les sprites de l'れたditeur pico 8 
  -- pour les arguments de la fonction 
  -- le numれたro du sprite, la position en x, la position en y, le nombre de tiles れき afficher en x, le nombre de tiles en y et le sens inversれた ou pas
end

-- animation 
function animation(a,l)
  -- premier argument de la fonction : a (nom du tableau)
  -- a ==> correspondant au tableau que doit lire la fonction
  -- par exemple le nom de l'objet et l'animation choisie 
  -- ici player.marche = {f=33,st=33,sz=4,var=0,spd=1/8}
  -- f = qui sera lue pour l'animation en cours, 
  -- st =  frame de dれたpart, 
  -- sz =  le nombre de frames de l'animation,
  -- var = une variable qui va varier de 0 れき 1, 
  -- spd =  c'est la vitesse, plus c'est proche de 1 plus れせa va vite
  -- et ensuite deuxiれそme argument l : largeur du sprite れき animer
  -- l ==> correspondant au nombre de tiles que prend un sprite ==> 1 pour un 8 px, 2 pour un 16 px, 4 pour un 32 px
  -- exemple : spr(animation(player.marche,2),player.x,player.y,2,2,player.god)
  a.var += a.spd
  if a.var>1 then
    a.var = 0
    a.f=a.f+l
    if a.f==(a.st+(a.sz*l)) then a.f=a.st end
  end
  return(a.f)
end

function anim_objet(a) -- fonction qui va determiner quelle animation choisir / quel tableau choisir dans le player pour jouer l'animation
  if (a.anim=="walk") then
    return animation(a.walk,1)
  elseif (a.anim=="nothing") then
    return animation(a.nothing,1)
  elseif (a.anim=="jump") then
    return animation(a.jump,1)
  end
end

function choix_animation_player() -- fonction qui va determiner l'animation れき choisir en fonction des actions du joueur 
  if abs(player.dy)!=0 then player.anim = "jump" 
    else 
    if abs(player.dx)!=0 then player.anim = "walk"
    else
      player.anim = "nothing"
    end
  end

  --changement
  if abs(player2.dy)!=0 then player2.anim = "jump" 
    else 
    if abs(player2.dx)!=0 then player2.anim = "walk"
    else
      player2.anim = "nothing"
    end
  end
end


function draw_player_animation() -- dessine le sprite avec animation

  spr(anim_objet(player),player.x,player.y,1,1,player.god)
  spr(anim_objet(player2),player2.x,player2.y,1,1,player2.god) --changement

end



--------------------------------------------------------------------------------------------
-- l'ui (user interface) du jeu
-- si on a une fonction de camera
function draw_ui() -- a appeler dans _draw() apres la gestion de la camera
  rectfill(1+camx,1+camy,126+camx,7+camy,1)
  print("diamants a trouver",2+camx,2+camy,9) 
  spr(7,100+camx,camy)
  print(": "..#diamants,112+camx,2+camy,9)
end 




-- fonctions graphiques & effets

--------------------------------------------------------------------------------------------
-- faire une trainee derriere un objet
-- en _init : trainees = {}
function make_trainee(x,y) -- a utiliser quand on veut crれたer une trainれたe en x et y
  local trainee = {}
    trainee.x = x -- position de dれたpart en x
    trainee.y = y -- position de dれたpart en y
    trainee.col = 8 -- la couleur de dれたpart de la trainれたe
    trainee.col2 = 9 -- couleur intermediaire
    trainee.col3 = 10 --couleur finale avant disparition
    trainee.life = 60 -- la durれたe de vie en frame
    trainee.r = 3-- le rayon de dれたpart
  add(trainees, trainee)
end

function draw_trainee() -- a appeler dans _draw()
  for t in all(trainees) do
      t.life -= 1 --rれたuit la durれたe de vie
      t.r -= rnd(1) -- rれたduit le rayon
      if t.life >= 45 then -- selon la vie, la couleur change
        t.col = t.col
      elseif t.life < 45 and t.life > 20 then
        t.col = t.col2
      elseif t.life <= 20 then
        t.col = t.col3
      end
    if t.life <= 0 then -- si la vie de la trainれたe est infれたrieure れき 0, la trainれたe est dれたtruite
      del(trainees, t)
    end
    circ(t.x, t.y, t.r, t.col) -- fait un cercle pour chaque trainれたe
    
  end
end

--------------------------------------------------------------------------------------------
-- faire des particules 
-- en _init : particules = {}
function make_particules(nb,x,y) -- a appeler pour faire des particules
  while(nb>0) do
    part = {}
      part.x = x
      part.y = y
      part.col = 11 -- couleur des particules
      part.dx = rnd(2)-1 -- vitesse & direction en x comprise en -1 et 1
      part.dy = rnd(2)-1 -- idem pour y
      part.f = 0 -- frame de dれたpart de la particule
      part.maxf = 30 -- frame de fin, utilisれたe pour dれたtruire la particule
    add(particules,part)
    nb -= 1
  end
end

function draw_particules()
  for part in all(particules) do
    pset(part.x,part.y,part.col)
    part.x += part.dx
    part.y += part.dy
    part.f += 1
    if(part.f>part.maxf) then
      del(particules,part)
    end
  end
end

---- camera --------------------------------------------------------------------------------
function update_camera_ecran() -- la camera est fixe et bouge si player va sur un autre tableau
  camx = flr(player.x/128)
  camy = flr(player.y/128)
  camera(camx*128,camy*128)
end

function update_camera_joueur(camx_max,camy_max) -- la camera suit toujours player
  -- camx_max,camy_max : en pixel, la limite de la camera
  camx=mid(0,flr(player.x-64),camx_max)
  camy=mid(0,flr(player.y-64),camy_max)
  camera(camx,camy)
end


--------------------------------------------------------------------------------------------
-- faire des screenshakes 
-- a declarer en _init()
  scr = {}
      scr.x = 0
      scr.y = 0
      scr.shake = 0
      scr.intensity = 4

  function screenshake(nb,intensity) -- a appeler pour faire un screenshake
    scr.shake = nb -- definit la duree
    scr.intensity = intensity -- definit l'intensite
  end

  function update_camera() -- a appeler dans _update()
    if scr.shake > 0 then
      scr.x = (rnd(2)-1)*scr.intensity
      scr.y = (rnd(2)-1)*scr.intensity
      scr.shake -= 1
    else
      scr.x,scr.y = 0,0 -- reboot x et y
    end
    camera(scr.x,scr.y)
  end

--------------------------------------------------------------------------------------------
-- surligner un sprite
-- s = sprite れき surligner
-- x,y = position du sprite
-- h,l = hauteur et largeur du sprite
-- god = gauche ou droite
-- col = couleur du surlignage
function highlight(s,x,y,h,l,god,col)
  for i=1,15 do
    pal(i,col)
  end
  spr(s,x+1,y,h,l,god)
  spr(s,x-1,y,h,l,god)
  spr(s,x,y+1,h,l,god)
  spr(s,x,y-1 ,h,l,god)
  pal()
  spr(s,x,y,h,l,god)
end


--------------------------------------------------------------------------------------------
-- faire clignoter un sprite
-- a declarer en _init() : timer_general = 0 
-- a appeler dans update() :  timer_general += 1 if (timer_general>300) timer_general = 0
-- s = sprite qu'on veut faire clignoter
-- x,y = position x et y du sprite
-- h,l = hauteur et largeur du sprite
-- god = gauche ou droite
-- col = couleur du clignotement
-- vit = vitesse/drequence du clignotement

function clignotement(s,x,y,h,l,god,col,vit)
  if timer_general%vit == 0
  then
    for i=1,15 do
      pal(i,col)
    end
      spr(s,x+1,y,h,l,god)
      spr(s,x-1,y,h,l,god)
      spr(s,x,y+1,h,l,god)
      spr(s,x,y-1,h,l,god)
      pal()
  else
    spr(s,x,y,h,l,god)
    pal()
  end
end


--------------------------------------------------------------------------------------------
-- faire de la pluie ou de la neige sur un ecran de jeu
-- a declarer en _init() : rain = {}
  
function make_rain(x,y)
  local goutte = {}
    goutte.x = x
    goutte.y = y
    goutte.l = 2 -- longueur de la goutte sur l'axe y
    goutte.life = 70 -- duree de vie de la goutte
    goutte.vit = rnd({4,5}) -- vitesse de chute de la goutte
  add(rain,goutte)
end

function update_rain() -- a appeler dans _update()
  local a = 2.5 -- frequence de la pluie (0 - 3.9)
  local b = rnd({8,12,14,16,24}) -- densite de la pluie
  for i = 0,130,b do -- cree des gouttes sur l'axe x, entre 0 et 130
    if rnd(4)>=a then
      make_rain(i,-10)
    end
  end
  for r in all(rain) do -- fait tomber la pluie
    r.y += r.vit -- chute de la pluie
    r.x += rnd({-0.5,0,0.5}) -- deplace legerement les gouttes sur l'axe x
    r.life -= 1
    if r.life <=0  then
      del(rain,r)
    end
    -- fait disparaitre la pluie si elle touche une tuile solide sur la map
    local collision_verticale = mget(r.x/8,r.y/8)
    if fget(collision_verticale,0) then
      -- ici, il est possible d'ajouter des particules
      del(rain,r)
    end

  end

end

function draw_rain() -- a appeler dans _draw()
  for r in all(rain) do
   pset(r.x,r.y,6)
   pset(r.x,r.y+1,13)
 end
end

--------------------------------------------------------------------------------------------
-- desintegrer un sprite
-- a declarer en _init() : desintegration = {}
-- x,y = position de la desintegration
-- l,h = hauteur et largeur du sprite
function make_desintegration(x,y,l,h) -- a appeler pour faire une desintegration
  for tmpx = x,x+l-1 do
    for tmpy = y,y+h-1 do 
        d = {}
        d.c = pget(tmpx,tmpy)
        d.x = tmpx
        d.y = tmpy
        d.dx = (rnd(2)-1)*2
        d.dy = (rnd(2)-1)*2
        d.time = 0
      add (desintegration,d) 
    end
  end
end

function draw_desintegration() -- a appeler dans _draw()
  for d in all(desintegration) do
    d.time += 1
    if (d.c == 0) del(desintegration,d) 
    rectfill(d.x,d.y,d.x+rnd({0,1,2}),d.y+rnd({0,1,2}),d.c)
    d.x +=d.dx
    d.y +=d.dy
    if (d.time > 60) del(desintegration,d)
  end
end

    
--------------------------------------------------------------------------------------------   
-- collision entre 2 objets
-- fonction de collision entre deux objets a & b 
-- c permet de choisir la grosseur de la boite de collision 
-- exemple si il s'agit d'une collision entre deux carrれたs de 8 px 
-- si on met c = 2 alors la collision fonctionnera si il y a contact 
-- entre les deux carrれたs de 4 px au lieu de 8 px
function collision(a,b,c) 
  if a.x+c > b.x+b.l-c
    or a.y+c > b.y+b.h-c
    or a.x+a.h-c < b.x+c
    or a.y+a.l-c < b.y+c then
      return false -- si une de ces conditions est vraie alors il n'y a pas collision
  else
      return true -- sinon il y a collision
  end
end

    
    
    
-- les objets et ennemis du jeu
--------------------------------------------------------------------------------------------
---------------------- enemis --------------------------------------------------------------
    
function faire_un_enemi(x,y) -- fonction pour fabriquer un enemi
  local enemi = {}
    enemi.x = x  -- position en x
    enemi.y = y -- position en y
    enemi.dx = 0  -- direction en x 
    enemi.dy = 0 -- direction en y 
    enemi.isgrounded = false -- est ce qu'il est sur le sol?
    enemi.saut = 8 -- hauteur du saut 
    enemi.vit = rnd({1,2,0.5}) -- vitesse de deplacement ici au hazard en trois valeurs
    enemi.bascule = rnd({30,60,90,120,150}) -- moment oれみ les enemis vont changer de direction ici au hazard entre 5 valeurs
    enemi.god = false -- voir player
    enemi.timer = 0 -- timer interne a chaque enemi pour declencher des trucs
    enemi.l = 8 -- largeur de l'objet
    enemi.h = 8 -- hauteur de l'objet
    enemi.spr = 32 -- pour essayer avant de faire des animations
    enemi.anim = "walk" -- animation 
    enemi.walk =  {f=32,st=32,sz=2,var=0,spd=1/8} -- frame en cours, frame de depart, taille de l'animation et vitesse  
  add(enemis,enemi)
end
    
-- placer les enemis sur la map
-- flag : le numれたro du flag
-- x_min,x_max : en tiles, la zone de la map sur laquelle la fonction va agir
-- y_min,y_max : idem, en tiles
function placer_des_enemis(flag,x_min,x_max,y_min,y_max) -- a appeler en _init() ou pas
  for i = x_min, x_max do -- scan la map en x
    for j = y_min, y_max do -- scan la map en y
      local sprite = mget(i,j) -- regarde quel est le flag de la tiles en i,j
      if fget(sprite,flag) then -- si il correspond avec le flag demandれた alors
        faire_un_enemi(i*8,j*8) -- on appel la fonction de crれたation d'objet
        mset(i,j,0) -- on remplace la tile par une tile vide ou autre chose si on veut
      end
    end
  end
end

    
function update_enemis() -- 
  for e in all(enemis) do 
    if e.dx>0 then e.god = false 
    elseif e.dx<=0 then e.god = true
    end
    e.timer+=1
    e.dx=e.vit
    if e.isgrounded then e.dy -= e.saut end
    if e.timer%e.bascule == 0 then e.vit = - e.vit end
    if e.timer>599 then e.timer = 0 end
    collision_map(e) 
  end
  
end
    
function draw_enemis()
  for e in all(enemis) do 
    spr(anim_objet(e),e.x,e.y,1,1,e.god) -- si on a fait des animations
    --spr(o.spr,o.x,o.y) -- si on veut juste le sprite
  end
end

-- player eclate les enemis mais ...............
function collision_player_enemis()
  for e in all(enemis) do 
      if collision(player,e,1) then 
        make_desintegration(e.x,e.y,e.l,e.h)
        sfx(6) -- joue un son quand un enemi est touche
        del(enemis,e) -- enleve cet enemi du tableau enemi
        faire_un_enemi(rnd(128),rnd(128))sfx(5) -- ajoute 1 enemi
        faire_un_enemi(rnd(128),rnd(128))sfx(5) -- ajoute 1 enemi
        faire_un_enemi(rnd(128),rnd(128))sfx(5) -- ajoute 1 enemi
        -- on peut ajouter d'autres effets comme player.life-=1
      end
  end
end 



--------------------------------------------------------------------------------------------
-- creer des objets a ramasser sur la map
-- a declarer en _init() : objets={} -- ne pas oublier de creer le tableau

function faire_un_diamant(x,y)
  local diamant = {}
    diamant.x = x 
    diamant.y = y
    diamant.l = 8 -- largeur 
    diamant.h = 8 -- hauteur 
    diamant.spr = 7 -- pour essayer avant de faire des animations
    diamant.anim = "nothing"
    diamant.nothing =  {f=7,st=7,sz=2,var=0,spd=1/8} -- frame en cours, frame de depart, taille de l'animation et vitesse  
  add(diamants,diamant)
end

    
function draw_diamants() -- a appeler en _draw()
  for d in all(diamants) do 
    spr(anim_objet(d),d.x,d.y,1,1) -- si on a fait des animations
    --spr(d.spr,d.x,d.y) -- si on veut juste le sprite
  end 
end

-- placer les objets sur la map
-- flag : le numれたro du flag
-- x_min,x_max : en tiles, la zone de la map sur laquelle la fonction va agir
-- y_min,y_max : idem, en tiles
function placer_des_diamants(flag,x_min,x_max,y_min,y_max) -- a appeler en _init() ou pas
  for i = x_min, x_max do -- scan la map en x
    for j = y_min, y_max do -- scan la map en y
      local sprite = mget(i,j) -- regarde quel est le flag de la tiles en i,j
      if fget(sprite,flag) then -- si il correspond avec le flag demandれた alors
        faire_un_diamant(i*8,j*8) -- on appel la fonction de crれたation de diamants
        mset(i,j,0) -- on remplace la tile par une tile vide ou autre chose si on veut
      end
    end
  end
end

    
-- player ramasse des diamants
function collision_player_diamants()
  for d in all(diamants) do 
      if collision(player,d,1) then 
        make_desintegration(d.x,d.y,d.l,d.h)
        sfx(4) -- joue un son quand un diamant est touche
        del(diamants,d)
        -- on peut ajouter d'autres effets comme player.life+=1
      end
  end
end 