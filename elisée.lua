-- pico-8 cartridge // http://www.pico-8.com
-- version 41
-- __lua__
-- cooperative la revanche
-- code pour les ateliers creation de jeux video

function _init() -- nouveau
  game_state = "game" -- nouveau
  level = 4
  boot()
end

function boot() -- nouveau
timer_general = 0 -- nouveau

game_state = "game" -- nouveau
  wait_timer = 0 -- nouveau

  
  
player = {}
  -- position sur l'れたcran
  player.x = 8  -- position en x du joueur (ici au milieu de l'ecran)
  player.y = 48  -- position en y du joueur (ici au milieu de l'ecran)
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
  player.saut = 5 -- hauteur du saut (valeur positive)
  player.isgrounded = false -- interrupteur qui permet de savoir si le personnage touche le sol, false = le personnage ne touche pas le sol, true = le personnage touche le sol
  -- animations du personnage
  player.god = false -- interrupteur qui flip le sprite sur l'axe vertical, si god = false alors le sprite apparaれなtra れき l'れたcran tel qu'il est dessinれた dans l'れたditeur de sptite, god = false il sera invers&
  player.anim = "nothing"-- animation en cours d'utilisation
  player.nothing =  {f=1,st=1,sz=1,var=0,spd=1/15}-- animation pour la marche
  player.walk =  {f=2,st=2,sz=2,var=0,spd=1/8}-- animation pour la marche
  player.jump =  {f=4,st=4,sz=2,var=0,spd=1/8}-- animation pour le saut
  player.death =  {f=6,st=6,sz=1,var=0,spd=1/8}-- animation pour la mort
  -- gestion du personnage (selon le gamplay)
  player.dead = false
  player.fart = false  
  player.cooldown_fart = 60
  player.btn_left = 0
  player.btn_right = 0
  player.btn_up = 0-- Elisée's niveau
  player.btn_down = 0-- Elisée's niveau
  player.btn_jump = 0
  player.ending = false
--changement
player2 = {}
  -- position sur l'れたcran
  player2.x = 8  -- position en x du joueur (ici au milieu de l'ecran)
  player2.y = 112  -- position en y du joueur (ici au milieu de l'ecran)
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
  player2.saut = 5 -- hauteur du saut (valeur positive)
  player2.isgrounded = false -- interrupteur qui permet de savoir si le personnage touche le sol, false = le personnage ne touche pas le sol, true = le personnage touche le sol
  -- animations du personnage
  player2.god = false -- interrupteur qui flip le sprite sur l'axe vertical, si god = false alors le sprite apparaれなtra れき l'れたcran tel qu'il est dessinれた dans l'れたditeur de sptite, god = false il sera invers&
  player2.anim = "nothing"-- animation en cours d'utilisation
  player2.nothing =  {f=17,st=17,sz=1,var=0,spd=1/15}-- animation pour la marche
  player2.walk =  {f=18,st=18,sz=2,var=0,spd=1/8}-- animation pour la marche
  player2.jump =  {f=20,st=20,sz=2,var=0,spd=1/8}-- animation pour le saut
  player2.death =  {f=22,st=22,sz=1,var=0,spd=1/8}-- animation pour la mort
  -- gestion du personnage (selon le gamplay)
  player2.dead = false
  player2.fart = false
  player2.cooldown_fart = 60
  player2.btn_left = 1
  player2.btn_right = 1
  player2.btn_up = 1-- Elisée's niveau
  player2.btn_down = 1-- Elisée's niveau
  player2.btn_jump = 1
  player2.ending = false


  gravite = 0.5 -- valeur de gravitれた qui sera appliquれた en permanence au joueur, plus elle sera れたlevれたe et plus le joueur descendra vite vers le sol
  
  -- les tableaux ou variables ou fonctions nれたcessaires au lancement du programme
  boutons = {}
  piques = {}
  scie_circulaires = {} 
-- faire_une_scie(48,48,1,true)
  --placer_des_piques(6,14,5)
  desintegration = {}
  particules = {}
  prouts = {}
  spawn_level()
  -- lancement de la musique du jeu
  --music(0)
  changementDesCommandes = false -- Elisée's niveau
end 


function _update() -- nouveau 
  timer_general+=1
  if (timer_general>2999) timer_general=0
    choix_animation_player(player) -- choix des animations de player
  choix_animation_player(player2) -- nouveau
  if (game_state == "game") update_game()
  if (game_state == "gameover") update_gameover()
end

--=========================================Start ELisée's part=======================================================

function update_game()
  if changementDesCommandes then -- Elisée's niveau
    move_playerELisee()
    move_player2ELisee()
  else 
    move_player()
    move_player2()
  end
  -- move_player() -- le dれたplacement de player
  -- move_player2() -- le dれたplacement de player2 --changement
  collision_player_boutons(player) -- gestion des collisions entre des diamants et player
  collision_player_boutons(player2)
  update_boutons()
  collision_player_piques()
  update_scies()
  fart(player)
  fart(player2)
  update_prouts()
  ending()
end

function move_playerELisee()

  arrete_le_deplacement(player) 
  
  if btn(0,player.btn_left) and not player.fart then 
    player.dx = -player.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btn(1,player.btn_right) and not player.fart then 
    player.dx = player.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 

  if btn(2,player.btn_up) and not player.fart then 
    player.dy = -player.vit 
    player.god = true
  end
  
  if btn(3,player.btn_down) and not player.fart then 
    player.dy = player.vit
    player.god = false 
  end 
  
  -- if btn(4,player.btn_jump) and player.isgrounded and not player.fart then 
  --   player.dy -= player.saut -- lorsqu'on appuie sur la touche c du clavier on ajoute la valeur du saut au dれたplacement vers le haut (en nれたgatif)
  -- end 
  if btn(5, 0) and not player2.fart and not player.fart then 
    player2.fart = true
  end 
  collision_map(player) 
end

function move_player2ELisee()

  arrete_le_deplacement(player2) 
  
  if btn(0, player2.btn_left) and not player2.fart then 
    player2.dx = -player2.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player2.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btn(1, player2.btn_right) and not player2.fart then 
    player2.dx = player2.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player2.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 
  if btn(2,player2.btn_up) and not player2.fart then 
    player2.dy = -player2.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player2.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btn(3,player2.btn_down) and not player2.fart then 
    player2.dy = player2.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player2.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 
  
  -- if btn(4, player2.btn_jump) and player2.isgrounded and not player2.fart then 
  --   player2.dy -= player2.saut -- lorsqu'on appuie sur la touche c du clavier on ajoute la valeur du saut au dれたplacement vers le haut (en nれたgatif)
  -- end 
  if btn(5, 1) and not player.fart and not player2.fart then 
    player.fart = true
  end 
  collision_map(player2) 
end



--=========================================End ELisée's part=======================================================



function update_gameover() -- nouveau 
wait_timer+=1

  if player.dead then 
    player.dx=0
    player.dy+=1
    make_particules(3,player.x+4,player.y+6,8)
    collision_map(player)
    if wait_timer>60 and btnp(4,0) then
    gamestate="game"
    wait_timer = 0
    --camera()
    boot()
  end
  end
  if player2.dead then  
    player2.dx = 0
    player2.dy+=1
    make_particules(3,player2.x+4,player2.y+6,8)
    collision_map(player2)
    if wait_timer>60 and btnp(4,1) then
    gamestate="game"
    wait_timer = 0
    --camera()
    boot()
  end
  end
end

function _draw() -- nouveau
  cls() -- nettoie l'れたcran, efface tout les れたlれたments affichれたs en dれたbut de cycle (rafraichissement)
  draw_game()
  if wait_timer>30 then 
    rectfill(camx*128,(camy*128)+63,(camx*128)+127,(camy*128)+71,0)
    print("press c/🅾️ to start again",(camx*128)+15,(camy*128)+65,14)
  end
  print("camx = "..camx*128,(camx*128)+10,(camy*128)+10,10)
  print("camy = "..camy*128,(camx*128)+10,(camy*128)+20,10)
  print("level = "..level,(camx*128)+10,(camy*128)+30,10)
end



function draw_game() -- la fonction affichera les れたlれたments les uns sur les autres en fonction de l'ordre d'れたcriture dans la fonction
  map() -- affiche la carte de l'れたditeur de carte de la tile 0,0 れき la tile 15,15 par dれたfaut
  draw_boutons()
  
  --draw_desintegration()
  draw_piques()
  draw_scie_circulaire()
  update_camera_ecran() -- gere la camera et passe d'ecran れき ecran 
  draw_particules()
  draw_player_animation() -- fonction qui dessine et anime le sprite
  draw_prouts()
  --draw_ui()
end 

function fart(a)
if a.fart then  
  if not a.god then
    faire_un_prout(a.x-4,a.y+5)
  elseif a.god then  
    faire_un_prout(a.x+12,a.y+5)
  end
  a.cooldown_fart-=1
  if a.cooldown_fart<=0 then  
    a.cooldown_fart = 30
    a.fart = false
  end
end
end

function open_porte_player1()
  for i = (camx*16),(camx*16)+15 do
    for j = (camy*16),(camy*16)+15 do
      if fget(mget(i,j),1) and fget(mget(i,j),3) then
        -- si porte pl1 fermれたe
        mset(i,j,36)
      end
    end
  end
end

function open_porte_player2()
  for i = (camx*16),(camx*16)+15 do
    for j = (camy*16),(camy*16)+15 do
      if fget(mget(i,j),2) and fget(mget(i,j),3) then
        -- si porte pl2 fermれたe
        mset(i,j,52)
      end
    end
  end
end

function ending()
  if fget(mget((player.x)/8,(player.y+4)/8),1)
  and fget(mget((player.x)/8,(player.y+4)/8),4) then
    player.ending = true
  else
    player.ending = false
  end
  if fget(mget((player2.x)/8,(player2.y+4)/8),2)
  and fget(mget((player2.x)/8,(player2.y+4)/8),4) then
    player2.ending = true
  else
    player2.ending = false
  end
  if player.ending and player2.ending then
    player.ending = false
    player2.ending = false
    level+=1
    spawn_level()
  end
end

function spawn_level()
    reload(0x1000, 0x1000, 0x2000)
  if level == 1 then 
    player.x = 1*8
    player.y = 6*8
    player2.x = 1*8
    player2.y = 14*8
    faire_un_bouton(14,3,101) -- arguments : x,y,id
  elseif level == 2 then 
    player.x = 17*8
    player.y = 6*8
    player2.x = 17*8
    player2.y = 14*8
    faire_un_bouton(30,3,201) -- arguments : x,y,id
  elseif level == 3 then 
    player.x = 17*8*(level-1)
    player.y = 6*8
    player2.x = 17*8*(level-1)
    player2.y = 14*8

    btn()

    faire_un_bouton(46,3,1001) -- arguments : x,y,id

  elseif level == 4 then
    player.x = 17*8*(level-1) -2*8 --deux bloc plus à gauche que d'habitude
    player.y = 6*8
    -- player.x = 59*8
    -- player.y = 4*8
    player2.x = 17*8*(level-1) -2*8 --deux bloc plus à gauche que d'habitude
    player2.y = 14*8
    -- player2.x = 55*8 --deux bloc plus à gauche que d'habitude
    -- player2.y = 04*8
    faire_un_bouton(50,04,2001)
    faire_un_bouton(51,10,2002)
    faire_un_bouton(55,02,2003)
    faire_un_bouton(60,05,2004) -- arguments : x,y,id
    faire_un_bouton(53,14,2005) -- arguments : x,y,id
    faire_un_bouton(61,08,2006) -- arguments : x,y,id
    faire_un_bouton(62,07,2007) -- arguments : x,y,id
    placer_des_piques(58,10,1)
    placer_des_piques(56,12,1)
  end
end







function arrete_le_deplacement(a) -- stoppe le dれたplacement
  if a.dx>0 then -- si le joueur va vers la droite
    a.dx-=a.friction -- on baisse progressivement la vitesse
  if a.dx<=0 then a.dx = 0 end -- pour arriver a zero
  elseif a.dx<0 then -- si le joueur va vers la gauche
    a.dx+=a.friction -- on ajoute a la vitesse pour
    if a.dx>=0 then a.dx = 0 end -- la ramener a zero
  end -- arrれちte de le dれたplacement en x
end

-- fontions pour un jeu de plateformes

function move_player()

  arrete_le_deplacement(player) 
  
  if btn(0,player.btn_left) and not player.fart then 
    player.dx = -player.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btn(1,player.btn_right) and not player.fart then 
    player.dx = player.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 
  
  if btn(4,player.btn_jump) and player.isgrounded and not player.fart then 
    player.dy -= player.saut -- lorsqu'on appuie sur la touche c du clavier on ajoute la valeur du saut au dれたplacement vers le haut (en nれたgatif)
  end 
  if btn(5, 0) and not player2.fart and not player.fart then 
    player2.fart = true
  end 
  collision_map(player) 
end

function move_player2()

  arrete_le_deplacement(player2) 
  
  if btn(0, player2.btn_left) and not player2.fart then 
    player2.dx = -player2.vit -- lorsqu'on appuie sur la touche gauche du clavier on ajoute la vitesse au dれたplacement vers la gauche (en nれたgatif)
    player2.god = true -- le sprite est dessinれた vers la droite donc quand on appuie vers la gauche il faut l'orienter vers la gauche
  end 
  
  if btn(1, player2.btn_right) and not player2.fart then 
    player2.dx = player2.vit -- lorsqu'on appuie sur la touche droite du clavier on ajoute la vitesse au dれたplacement vers la droite (en positif)
    player2.god = false -- le sprite est dessinれた vers la droite donc quand on appuie vers la droite il faut lui laisser cette orientation
  end 
  
  if btn(4, player2.btn_jump) and player2.isgrounded and not player2.fart then 
    player2.dy -= player2.saut -- lorsqu'on appuie sur la touche c du clavier on ajoute la valeur du saut au dれたplacement vers le haut (en nれたgatif)
  end 
  if btn(5, 1) and not player.fart and not player2.fart then 
    player.fart = true
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
  if a.dy > 7 then a.dy = 7 end -- on bloque la vitesse de chute du personnage pour れたviter de traverser les murs si on chute de trop haut
  a.y += a.dy -- on ajoute la valeur dy au deplacement en y du joueur 

  local vertical_collision = mget((a.x+4)/8,(a.y+8)/8) -- verifie la tile en dessous de player
--+2 & +6 doubler
    a.isgrounded = false -- de base player n'est pas au sol

    --or fget position 2
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
  elseif (a.anim == "death") then  
    return animation(a.death,1)
  end
end

function choix_animation_player(a) -- nouveau 
  if a.dead then a.anim = "death"  
    else
    if abs(a.dy)!=0 then a.anim = "jump" 
      else 
      if abs(a.dx)!=0 then a.anim = "walk"
      else
        a.anim = "nothing"
      end
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


function teleportation_players()
  local x1 = player.x
  local y1 = player.y
  local x2 = player2.x
  local y2 = player2.y
  player.x = x2
  player.y = y2
  player2.x = x1
  player2.y = y1
end

function inversion_controles(left,right,jump) -- true ou false
  local p1_left = player.btn_left
  local p1_right = player.btn_right
  local p1_jump = player.btn_jump

  local p2_left = player2.btn_left
  local p2_right = player2.btn_right
  local p2_jump = player2.btn_jump

  if left then
    player.btn_left = p2_left
    player2.btn_left = p1_left
  end
  if right then
    player.btn_right = p2_right
    player2.btn_right = p1_right
  end
  if jump then
    player.btn_jump = p2_jump
    player2.btn_jump = p1_jump
  end
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
function make_particules(nb,x,y,col) -- a appeler pour faire des particules
  while(nb>0) do
    part = {}
      part.x = x
      part.y = y
      part.col = col -- couleur des particules
      part.dx = rnd(2)-1 -- vitesse & direction en x comprise en -1 et 1
      part.dy = rnd(2)-1 -- idem pour y
      part.f = 0 -- frame de dれたpart de la particule
      part.maxf = 120 -- frame de fin, utilisれたe pour dれたtruire la particule
    add(particules,part)
    nb -= 1
  end
end

function draw_particules()
  for part in all(particules) do
    pset(part.x,part.y,part.col)
    
    local collision_part_bas=mget(part.x/8,part.y/8)
    if fget(collision_part_bas,0) then
      part.dx = 0
      part.dy = 0
      part.f  = 0
    end
    part.x += 2*part.dx
    part.y += 2*part.dy
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
--==la scie==--

function faire_une_scie(pos_x, pos_y, vitesse, direction)
local scie_circulaire = {}
  scie_circulaire.x = pos_x*8  -- position en x au dれたbut de son animation
  scie_circulaire.y = pos_y*8 -- position en y  au dれたbut de son animation
  scie_circulaire.vit = vitesse -- vitesse de deplacement ici au hazard en trois valeurs
  scie_circulaire.god = false -- voir player
  scie_circulaire.direction = direction
  scie_circulaire.go_left = true
  scie_circulaire.go_up = true
  scie_circulaire.timer = 0 -- timer interne a chaque enemi pour declencher des trucs
  scie_circulaire.l = 8 -- largeur de l'objet
  scie_circulaire.h = 8 -- hauteur de l'objet
  scie_circulaire.anim = "walk" -- animation
  scie_circulaire.walk =  {f=24,st=24,sz=2,var=0,spd=1/8} -- frame en cours, frame de depart, taille de l'animation et vitesse
add(scie_circulaires,scie_circulaire)
end

function draw_scie_circulaire()
for s in all(scie_circulaires) do
spr(anim_objet(s),s.x,s.y,1,1,s.god)
end
end

function update_scies()
for s in all(scie_circulaires) do

--make_trainee(s.x, s.y)

if s.direction == 1 then
  
  local right_flag = fget(mget(flr((s.x+s.l)/8),flr(s.y/8)),0)
  if right_flag == true then s.go_left=true end
  local left_flag = fget(mget(flr((s.x-s.vit)/8),flr(s.y/8)),0)
  if left_flag == true then s.go_left=false end

  if s.go_left == false then
    s.x+=s.vit
  elseif s.go_left == true then
    s.x-=s.vit
  end
elseif s.direction == 2 then
  local up_flag = fget(mget(flr(s.x/8),flr((s.y-s.vit)/8)),0)
  if up_flag == true then s.god=true end
  local down_flag = fget(mget(flr(s.x/8),flr((s.y+s.h)/8)),0)
  if down_flag == true then s.god=false end

  if s.god == false then
    s.y-=s.vit
  elseif s.god == true then
    s.y+=s.vit
  end
  elseif s.direction == 3 then

    local right_flag = fget(mget(flr((s.x+s.l)/8),flr(s.y/8)),0)
    if right_flag == true then s.go_left=true end
    local left_flag = fget(mget(flr((s.x-s.vit)/8),flr(s.y/8)),0)
    if left_flag == true then s.go_left=false end

    if s.go_left == false then
      s.x+=s.vit
    elseif s.go_left == true then
      s.x-=s.vit
    end
    local up_flag = fget(mget(flr(s.x/8),flr((s.y-s.vit)/8)),0)
    if up_flag == true then s.go_up=false end
    local down_flag = fget(mget(flr(s.x/8),flr((s.y+s.h)/8)),0)
    if down_flag == true then s.go_up=true end

    if s.go_up == true then
      s.y-=s.vit
    elseif s.go_up == false then
      s.y+=s.vit
    end
end

if collision(player,s,1) then
  make_desintegration(s.x,s.y,s.l,s.h)
    player.dead = true
  game_state = "gameover"
  -- sfx(6) -- joue un son quand un enemi est touche
end
if collision(player2,s,1) then
  make_desintegration(s.x,s.y,s.l,s.h)
    player2.dead = true
  game_state = "gameover"
  -- sfx(6) -- joue un son quand un enemi est touche
end

end

end





--------------------------------------------------------------------------------------------
---------------------- pique --------------------------------------------------------------
    
function faire_un_pique(x,y) -- fonction pour fabriquer un enemi
  local pique = {}
    pique.x = x  -- position en x
    pique.y = y -- position en y
    pique.l = 8 -- largeur de l'objet
    pique.h = 8 -- hauteur de l'objet
    pique.flip = false
    pique.anim = "walk" -- animation 
    pique.walk =  {f=32,st=32,sz=2,var=0,spd=1/4} -- frame en cours, frame de depart, taille de l'animation et vitesse  
  add(piques,pique)
end

function placer_des_piques(x,y,nb) -- coordonnれたes de la tiles
  local a = 0 
    for i=1,nb do
      faire_un_pique((x+a)*8,y*8)
      --mset(x+a,y,0)
      a+=1
    end
  end

        
function draw_piques()
  for p in all(piques) do 
    spr(anim_objet(p),p.x,p.y) -- si on a fait des animations
    --spr(o.spr,o.x,o.y) -- si on veut juste le sprite
  end
end

function collision_player_piques()
  for p in all(piques) do 
    if collision(player,p,2) then 
      player.dead = true
      game_state = "gameover"

      --make_desintegration(player.x,player.y,player.l,player.h)
      --sfx(6) -- joue un son quand un enemi est touche
    end
    if collision(player2,p,2) then 
      player2.dead = true
      game_state = "gameover"

      --make_desintegration(player2.x,player2.y,player2.l,player2.h)
      --sfx(6) -- joue un son quand un enemi est touche
    end
  end
end 



--------------------------------------------------------------------------------------------
-- creer des objets a ramasser sur la map
-- a declarer en _init() : objets={} -- ne pas oublier de creer le tableau


function faire_un_bouton(x,y,id) --yflip flip vertical (boolean) 
  local bouton = {}
    bouton.id = id
    bouton.x = x*8 
    bouton.y = y*8
    bouton.l = 8 -- largeur 
    bouton.h = 8 -- hauteur 
    bouton.active = false
    bouton.input = false
    bouton.spr = 7 -- pour essayer avant de faire des animations
  add(boutons,bouton)
end

    
function draw_boutons() -- a appeler en _draw()
  for b in all(boutons) do 
    spr(b.spr,b.x,b.y,1,1,false,b.yFlip) -- si on a fait des animations
    print(b.id,b.x,b.y-2,10)
    print(b.input,b.x,b.y-12,11)

    --spr(d.spr,d.x,d.y) -- si on veut juste le sprite
  end 
end

function update_boutons()
  for b in all(boutons) do 
    if b.active then 
      b.spr = 8 
      update_action_bouton(b)
      b.input = true --changement
    else
      b.spr = 7
    end
  end
end

function update_action_bouton(b)
  --=======lvl 1 =======--
  if (b.id == 101) then
    if not b.input then 
      faire_un_bouton(1,11,102)
    end
  end
  if (b.id == 102) then
    if not b.input then 
      faire_un_bouton(1,4,103)
      open_porte_player1()
    end
  end
  if (b.id == 103) then
    if not b.input then 
      open_porte_player2()
    end
  end
  --=======lvl 2 =======--
  if (b.id == 201) then
    if not b.input then 
      faire_un_bouton(17,11,202)
      placer_des_piques(19,11,1)

    end
  end
  if (b.id == 202) then
    if not b.input then  
      faire_un_bouton(17,4,203)
      placer_des_piques(21,6,3)
      open_porte_player1()
    end
  end
  if (b.id == 203) then
    if not b.input then 
      music(0)
      open_porte_player2()
    end
  end
  --=======lvl Élisée Elisee 1=======--
  if (b.id == 1001) then
    if not b.input then 
      faire_un_bouton(33,08,1002, false)
      mettredudecor(16,33, 09, 1, "h")
      faire_une_scie(57,01,1,1)
      faire_une_scie(53,07,1,1)
      faire_une_scie(40,08,1,3)
      faire_une_scie(40,10,1,3)
      placer_des_piques(43,06,1)
      changementDesCommandes = true
    end
  end
  if (b.id == 1002) then
    if not b.input then  
      faire_un_bouton(17,4,1003,true)
      
      open_porte_player1()
      open_porte_player2()
    end
  end
  --=======lvl Élisée Elisee 2=======--
  if (b.id == 2001) then
    if not b.input then 
      -- mettredudecor(16,33, 09, 1, "h")
      -- faire_un_bouton(50,04,2003)
      faire_une_scie(51,01,1,1)
      
      -- faire_une_scie(40,08,1,3)
      -- faire_une_scie(40,10,1,3)
      -- placer_des_piques(42,06,2)
      -- changementDesCommandes = true
    end
  end
  if (b.id == 2002) then
    if not b.input then  
      faire_une_scie(53,08,1,2)
    end
  end
  if (b.id == 2003) then
    if not b.input then  
      faire_un_bouton(17,4,2005)
      faire_une_scie(53,08,1,2)
    end
  end
  if (b.id == 2004) then
    if not b.input then  
      mettredudecor(0, 54, 06, 1, 'h')
      
      -- open_porte_player1()
      -- open_porte_player2()
    end
  end
  
  if (b.id == 2006) then
    if not b.input then  
      mettredudecor(0, 62, 14, 1, "h")
      placer_des_piques(62, 14, 1)
      open_porte_player1()
    end
  end
  if (b.id == 2007) then
    if not b.input then  
      open_porte_player2()
    end
  end
end




    
function collision_player_boutons(p)
  for b in all(boutons) do 
    if not b.active then
      if collision(p,b,1) then 
        b.active = true
        --make_desintegration(d.x,d.y,d.l,d.h)
        sfx(4) -- joue un son quand un diamant est touche
        
        -- on peut ajouter d'autres effets comme player.life+=1
      end
    end
  end
end 
------------------------------------------murs plateformes------
function mettredudecor(s,x,y,nb,sens) -- sens = h(orizontal) ou v(ertical) --- x et y en tiles
  local a = 0 
  if sens == "h" then
    for i=1,nb do
      mset(x+a,y,s)
      a+=1
    end
  elseif sens == "v" then 
    for i=1,nb do
      mset(x,y+a,s)
      a+=1
    end
  end
end



      
---------------------------- prout ----------------
function faire_un_prout(x,y)
  local prout = {}
    prout.x=x
    prout.y=y
    prout.r= rnd(3) 
    prout.col= rnd({11,3})
    --cloud.prout = rnd({0,0,0,0,1})
    prout.life = 20
  add(prouts,prout)
end

function update_prouts()
  --raining_timer+=1
  --if (raining_timer>600) raining_timer=0
  for p in all(prouts) do 
    p.x+=rnd({-1,-0.5,0,0.5,1})
    p.y+=rnd({-1,-0.5,0,0.5,1})
    p.life-=1
    if p.life<=0 then
      del(prouts,p)
    end
  end
end

function draw_prouts()
  --local prout = rnd({0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1})
  for p in all(prouts) do

    --if (c.prout==1) fillp()░ 
    --fillp(░)
    --rectfill(c.x,c.y,c.x+c.r,c.y+c.r,c.col)
    circfill(p.x,p.y,p.r,p.col)
  -- fillp()
  end
end