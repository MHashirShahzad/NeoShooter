# Importing the required modules
import pygame
import os
import sys
import random
import math
from pygame.locals import *
pygame.font.init()
pygame.mixer.init()

# get info width height
os.environ['SDL_VIDEO_CENTERED'] = '1' # You have to call this before pygame.init()
pygame.init()
info = pygame.display.Info() # You have to call this before pygame.display.set_mode()
clock = pygame.time.Clock()
pygame.mouse.set_cursor((8,8),(0,0),(0,0,0,0,0,0,0,0),(0,0,0,0,0,0,0,0))
# Constant width , height and creating window and setting its name
WIDTH, HEIGHT = info.current_w, info.current_h
WIN = pygame.display.set_mode((WIDTH - 10 , HEIGHT - 10), pygame.FULLSCREEN)
pygame.display.set_caption("Two Player Game")\


# Velocitys/ Speeds
VELOCITY = 15
BULLET_VELOCITY = 20
SLOW_BULLET_VELOCITY = 10
FAST_BULLET_VELOCITY = 30
MAX_BULLETS = 3

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
YELLOW = (255,255,0)
RED = (255, 0 , 0)

# Border
BORDER = pygame.Rect(WIDTH//2, 0, 10, HEIGHT)


# Sounds
BULLET_HIT_SOUND =  pygame.mixer.Sound(
    os.path.join( "Assets", "Damage.wav"))
BULLET_FIRE_SOUND = pygame.mixer.Sound(
    os.path.join( "Assets", "Pew.mp3"))
DEAD_SOUND = pygame.mixer.Sound(
    os.path.join( "Assets", "Ded.mp3"))
SHIELD_SOUND = pygame.mixer.Sound(
    os.path.join("Assets", "shield-4.mp3"))
BG_MUSIC =  pygame.mixer.Sound(
    os.path.join("Assets", "Bg_music.mp3"))

# Text Fonts
HEALTH_FONT = pygame.font.SysFont("comicsans", 40)
WINNER_FONT = pygame.font.SysFont("comicsans", 40)

# FPS
FPS = 60

# Custom Events
YELLOW_HIT = pygame.USEREVENT + 1
RED_HIT = pygame.USEREVENT + 2
RED_SHIELD_HIT = pygame.USEREVENT + 3
YELLOW_SHIELD_HIT = pygame.USEREVENT + 4
PARTICLE_EVENT = pygame.USEREVENT + 5


# Space ships
SPACESHIP_WIDTH, SPACESHIP_HEIGHT = 55, 40
# yellow spaceship
YELLOW_SPACESHIP_IMAGE = pygame.image.load(
    os.path.join(
        "Assets","spaceship_yellow.png"))
YELLOW_SPACESHIP = pygame.transform.rotate(
    pygame.transform.scale(
    YELLOW_SPACESHIP_IMAGE, 
    (SPACESHIP_WIDTH, SPACESHIP_HEIGHT)),90)

# red spaceship
RED_SPACESHIP_IMAGE = pygame.image.load(
       os.path.join(
         "Assets","spaceship_red.png"))
RED_SPACESHIP = pygame.transform.rotate(
    pygame.transform.scale(
    RED_SPACESHIP_IMAGE, 
    (SPACESHIP_WIDTH, SPACESHIP_HEIGHT)), 270)


# Bg image
SPACE = pygame.image.load(
    os.path.join( "Assets", "bg_01.png")).convert()

SPACE_WIDTH = SPACE.get_width()
scroll = 0
tiles = math.ceil(WIDTH / SPACE_WIDTH) + 1
# trail_particles
# have [location, velocity, timer]
trail_particles = []
particles = []

def draw_winner(text):
    DEAD_SOUND.play()
    draw_text = WINNER_FONT.render(text, 1, WHITE) 
    WIN.blit(draw_text, (WIDTH/2 - draw_text.get_width() /
                         2, HEIGHT/2 - draw_text.get_height()/2))
    pygame.display.update()
    pygame.time.delay(5000)

# red movement
def red_handle_movement(keys_pressed, red):
    if keys_pressed[pygame.K_LEFT] and red.x - 1 > BORDER.x: # on left pressed move left
        red.x -= VELOCITY
        
    if keys_pressed[pygame.K_RIGHT] and red.x + 1 + red.width < WIDTH - 10: # on right pressed move right
        red.x += VELOCITY

    if keys_pressed[pygame.K_UP] and red.y - 1 > 0: # on up pressed move up
        red.y -= VELOCITY
        
    if keys_pressed[pygame.K_DOWN] and red.y + 1 + red.width < HEIGHT: #on down pressed move down
        red.y += VELOCITY

# yellow movement
def yellow_handle_movement(keys_pressed, yellow):
    if keys_pressed[pygame.K_a] and yellow.x - 1 > 0: # on a pressed move left
        yellow.x -= VELOCITY
        
    if keys_pressed[pygame.K_d] and yellow.x + 1 + yellow.width < BORDER.x: # on d pressed move right
        yellow.x += VELOCITY

    if keys_pressed[pygame.K_w] and yellow.y - 1 > 0: # on w pressed move up
        yellow.y -= VELOCITY
        
    if keys_pressed[pygame.K_s] and yellow.y + 1 + yellow.width < HEIGHT: #on s pressed move down
        yellow.y += VELOCITY

# bullets
def handle_bullets(yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, yellow_shields,
            red_bullets,red_slow_bullets, red_fast_bullets,  red_shields,
            yellow, red):
    
    for yellow_shield in yellow_shields:
        pass
    for red_shield in red_shields:
        pass

    # yellow bullets
    for bullet in yellow_bullets:
        bullet.x += BULLET_VELOCITY
        if red.colliderect(bullet):
            pygame.event.post(pygame.event.Event(RED_HIT))
            yellow_bullets.remove(bullet)
        try:
            if isinstance(red_shield, pygame.Rect):
                if red_shield.colliderect(bullet):
                    pygame.event.post(pygame.event.Event(RED_SHIELD_HIT))
                    yellow_bullets.remove(bullet)
        except:
            pass
        try:
            if isinstance(yellow_shield, pygame.Rect):
                if yellow_shield.colliderect(bullet):
                    yellow_bullets.remove(bullet)
        except:
            pass
        if bullet.x > WIDTH:
            yellow_bullets.remove(bullet)

    for slow_bullet in yellow_slow_bullets:
        slow_bullet.x += SLOW_BULLET_VELOCITY
        if red.colliderect(slow_bullet):
            pygame.event.post(pygame.event.Event(RED_HIT))
            yellow_slow_bullets.remove(slow_bullet)
        try:
            if isinstance(red_shield, pygame.Rect):
                if red_shield.colliderect(slow_bullet):
                    pygame.event.post(pygame.event.Event(RED_SHIELD_HIT))
                    yellow_slow_bullets.remove(slow_bullet)
        except:
            pass
        try:
            if isinstance(yellow_shield, pygame.Rect):
                if yellow_shield.colliderect(slow_bullet):
                    yellow_slow_bullets.remove(slow_bullet)
        except:
            pass
        if slow_bullet.x > WIDTH:
            yellow_slow_bullets.remove(slow_bullet)
    
    for fast_bullet in yellow_fast_bullets:
        fast_bullet.x += FAST_BULLET_VELOCITY
        if red.colliderect(fast_bullet):
            pygame.event.post(pygame.event.Event(RED_HIT))
            yellow_fast_bullets.remove(fast_bullet)
        try:
            if isinstance(red_shield, pygame.Rect):
                if red_shield.colliderect(fast_bullet):
                    pygame.event.post(pygame.event.Event(RED_SHIELD_HIT))
                    yellow_fast_bullets.remove(fast_bullet)
        except:
            pass
        try:
            if isinstance(yellow_shield, pygame.Rect):
                if yellow_shield.colliderect(fast_bullet):
                    yellow_fast_bullets.remove(fast_bullet)
        except:
            pass
        if fast_bullet.x > WIDTH:
            yellow_fast_bullets.remove(fast_bullet)
        
    # red bullets
    for bullet in red_bullets:
        bullet.x -= BULLET_VELOCITY
        if yellow.colliderect(bullet):
            pygame.event.post(pygame.event.Event(YELLOW_HIT))
            red_bullets.remove(bullet)
        try:
            if isinstance(yellow_shield, pygame.Rect):
                if yellow_shield.colliderect(bullet):
                    pygame.event.post(pygame.event.Event(YELLOW_SHIELD_HIT))
                    red_bullets.remove(bullet)
        except:
            pass
        try:
            if isinstance(red_shield, pygame.Rect):
                if red_shield.colliderect(bullet):
                    red_bullets.remove(bullet)
        except:
            pass
        if bullet.x < 0:
            red_bullets.remove(bullet)

    for slow_bullet in red_slow_bullets:
        slow_bullet.x -= SLOW_BULLET_VELOCITY
        if yellow.colliderect(slow_bullet):
            pygame.event.post(pygame.event.Event(YELLOW_HIT))
            red_slow_bullets.remove(slow_bullet)
        try:
            if isinstance(yellow_shield, pygame.Rect):
                if yellow_shield.colliderect(slow_bullet):
                    pygame.event.post(pygame.event.Event(YELLOW_SHIELD_HIT))
                    red_slow_bullets.remove(slow_bullet)
        except:
            pass
        try:
            if isinstance(red_shield, pygame.Rect):
                if red_shield.colliderect(slow_bullet):
                    red_slow_bullets.remove(slow_bullet)
        except:
            pass
        if slow_bullet.x < 0:
            red_slow_bullets.remove(slow_bullet)

    for fast_bullet in red_fast_bullets:
        fast_bullet.x -= FAST_BULLET_VELOCITY
        if yellow.colliderect(fast_bullet):
            pygame.event.post(pygame.event.Event(YELLOW_HIT))
            red_fast_bullets.remove(fast_bullet)
        try:
            if isinstance(yellow_shield, pygame.Rect):
                if yellow_shield.colliderect(fast_bullet):
                    pygame.event.post(pygame.event.Event(YELLOW_SHIELD_HIT))
                    red_fast_bullets.remove(fast_bullet)
        except:
            pass
        try:
            if isinstance(red_shield, pygame.Rect):
                if red_shield.colliderect(fast_bullet):
                    red_fast_bullets.remove(fast_bullet)
        except:
            pass
        if fast_bullet.x < 0:
            red_fast_bullets.remove(fast_bullet)

def draw_particles(trail_particles, particles):
    start_ticks=pygame.time.get_ticks()
    #particles have [location, velocity, timer, color] where 0 = loc, 1 = vel, 2 = timer, 3 = color
    for particle in trail_particles:
        particle[0][1] += particle[1][0] 
        particle[0][0] += particle[1][1]
        particle[2] -= 0.1 
        pygame.draw.circle(WIN, particle[3], particle[0], particle[2])
    if particle[2] <= 0:
        trail_particles.remove(particle)

    for particle in particles:
        particle[0][0] += particle[1][0] 
        particle[0][0] += particle[1][1]
        particle[0][1] += particle[1][1] 
        particle[0][0] += particle[1][1]
        particle[2] -= 0.1 
        pygame.draw.circle(WIN, particle[3], particle[0], particle[2])
        seconds=(pygame.time.get_ticks()-start_ticks)/1000    
        if seconds>1:
            particles.remove(particle)
    
# draw
def draw_window( yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, yellow_shields,
            red_bullets,red_slow_bullets, red_fast_bullets, red_shields,
            yellow, red, red_health, yellow_health, red_shields_health, yellow_shield_health, display_fps):
    # back ground
    global scroll
    for i in range(0, tiles):
        WIN.blit(SPACE,(i * SPACE_WIDTH + scroll, 0))
        

    
    # scroll background
    scroll -= 5

    # reset scroll
    if abs(scroll) > SPACE_WIDTH:
        scroll = 0

    pygame.draw.rect(WIN, BLACK, BORDER)

    # trail_particles have [location, velocity, timer, color] where 0 = loc, 1 = vel, 2 = timer
    trail_particles.append([[yellow.x , yellow.y + yellow.width/2], [random.randint(0,20)/ 10 -1, - 2], random.randint(4, 6), (255,255,0)])
    trail_particles.append([[red.x + red.height, red.y + red.width/2], [random.randint(-20, 0)/ 10 +1, + 2], random.randint(4, 6), (255, 0, 0)])


    draw_particles(trail_particles, particles)

    red_health_text = HEALTH_FONT.render("Health :"+ str(red_health), 1, RED)
    yellow_health_text = HEALTH_FONT.render("Health:" + str(yellow_health), 1, YELLOW)
    fps_text = HEALTH_FONT.render("FPS:" + str(display_fps), 1, WHITE)
    WIN.blit(red_health_text, (WIDTH - red_health_text.get_width() - 10, 10))
    WIN.blit(yellow_health_text, (10, 10))
    WIN.blit(fps_text, (WIDTH//2 - fps_text.get_width()// 2, 10))

    WIN.blit(YELLOW_SPACESHIP, (yellow.x, yellow.y))
    WIN.blit(RED_SPACESHIP, (red.x, red.y))

    for bullet in red_bullets:
        pygame.draw.rect(WIN, RED, bullet)
    for slow_bullet in red_slow_bullets:
        pygame.draw.rect(WIN, (247, 45, 45), slow_bullet)
    for fast_bullet in red_fast_bullets:
        pygame.draw.rect(WIN, (252, 126, 126), fast_bullet)
    for shield in red_shields:
        pygame.draw.rect(WIN, RED, shield)

    for bullet in yellow_bullets:
        pygame.draw.rect(WIN, YELLOW, bullet)
    for slow_bullet in yellow_slow_bullets:
        pygame.draw.rect(WIN, (252, 252, 53), slow_bullet)
    for fast_bullet in yellow_fast_bullets:
        pygame.draw.rect(WIN, (227, 252, 126), fast_bullet)
    for shield in yellow_shields:
        pygame.draw.rect(WIN, YELLOW, shield)
        
    pygame.display.update()

# Draw Winner
def main():
    BG_MUSIC.play()
    red = pygame.Rect(900, 400, SPACESHIP_WIDTH, SPACESHIP_HEIGHT) # red spawn location
    yellow = pygame.Rect(200, 100, SPACESHIP_WIDTH, SPACESHIP_HEIGHT) # yellow spawn location
    # red bullets
    red_bullets = []
    red_slow_bullets = []
    red_fast_bullets = []
    red_shields = []

    # yellow bullets
    yellow_bullets = []
    yellow_slow_bullets = []
    yellow_fast_bullets = []
    yellow_shields = []

    # shield healths
    red_shield_health = 5
    yellow_shield_health = 5

    # spaceship healths
    red_health = 10
    yellow_health = 10
    
    winner_text = ""

    #run state to keep the game runnimg
    run = True
    while run:
        clock.tick(FPS)
        display_fps = int(clock.get_fps())
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False
                pygame.quit()
            
            if event.type == pygame.KEYDOWN:
                # key down = pressed
                if event.key == pygame.K_ESCAPE:
                    # escape = game ded
                    run = False
                    pygame.quit()
                # yellow bullets
                if event.key == pygame.K_f and len(yellow_bullets) < 3:
                    bullet = pygame.Rect(
                        yellow.x + yellow.width//2, yellow.y + yellow.height//2 , 15, 10 )
                    yellow_bullets.append(bullet)
                    BULLET_FIRE_SOUND.play()
                    

                if event.key == pygame.K_g and len(yellow_slow_bullets) < 3:
                    slow_bullet = pygame.Rect(
                        yellow.x + yellow.width//2 , yellow.y + yellow.height//2 , 30, 25 )
                    yellow_slow_bullets.append(slow_bullet)
                    BULLET_FIRE_SOUND.play()

                if event.key == pygame.K_h and len(yellow_fast_bullets) < 2:
                    fast_bullet = pygame.Rect(
                        yellow.x + yellow.width//2, yellow.y + yellow.height//2 , 10, 10 )
                    yellow_fast_bullets.append(fast_bullet)
                    #particles.append([[yellow.x + yellow.width,yellow.y + yellow.height//2 - 2,], [random.randint(0,20)/ 10 -1, - 2], random.randint(4, 6), (255,255,0)])
                    BULLET_FIRE_SOUND.play()

                if event.key == pygame.K_t and len(yellow_shields) < 1:
                    yellow_shield = pygame.Rect(
                        yellow.x + yellow.width + 10, yellow.y + yellow.height//2 - 40, 15, 100)
                    yellow_shields.append(yellow_shield)
                    particles.append([[yellow.x + yellow.width,yellow.y + yellow.height//2 - 2,], [random.randint(0,20)/ 10 -1, - 2], random.randint(8, 10), (255,255,0)])
                    SHIELD_SOUND.play()
                    
                
                # red bullets
                if event.key == pygame.K_KP1 and len(red_bullets) < 3:
                    bullet = pygame.Rect(
                        red.x - red.width + 50, red.y + red.height//2 , 15, 10 )
                    red_bullets.append(bullet)
                    BULLET_FIRE_SOUND.play()

                if event.key == pygame.K_KP2 and len(red_slow_bullets) < 3:
                    slow_bullet = pygame.Rect(
                        red.x - red.width + 30, red.y + red.height//2 , 30, 25 )
                    red_slow_bullets.append(slow_bullet)
                    BULLET_FIRE_SOUND.play()

                if event.key == pygame.K_KP3 and len(red_fast_bullets) < 2:
                    fast_bullet = pygame.Rect(
                        red.x - red.width + 50 , red.y + red.height//2 , 10, 10 )
                    red_fast_bullets.append(fast_bullet)
                    BULLET_FIRE_SOUND.play()
                
                if event.key == pygame.K_KP0 and len(red_shields) < 1:
                    red_shield = pygame.Rect(
                        red.x - red.width + 10, red.y + red.height//2 - 40, 15, 100)
                    red_shields.append(red_shield)
                    SHIELD_SOUND.play()

            if event.type == RED_HIT:
                red_health -= 1
                BULLET_HIT_SOUND.play()

            if event.type == YELLOW_HIT:
                yellow_health -= 1
                BULLET_HIT_SOUND.play()

            if event.type == YELLOW_SHIELD_HIT:
                yellow_shield_health -= 1
                BULLET_HIT_SOUND.play()
            
            if event.type == RED_SHIELD_HIT:
                red_shield_health -= 1
                BULLET_HIT_SOUND.play()

        if red_health <= 0:
            winner_text = "YELLOW Wins!"
        
        if yellow_health <= 0:
            winner_text = "RED Wins"
        
        if red_shield_health == 0:
            red_shields.remove(red_shield)
            red_shield_health = 5
        
        if yellow_shield_health == 0:
            yellow_shields.remove(yellow_shield)
            yellow_shield_health = 5
        
        if winner_text != "":
            draw_winner(winner_text)
            break
        
        keys_pressed = pygame.key.get_pressed()


        yellow_handle_movement(keys_pressed, yellow)
        red_handle_movement(keys_pressed, red)
        handle_bullets(
            yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, yellow_shields,
            red_bullets,red_slow_bullets, red_fast_bullets, red_shields, 
            yellow, red)
        
        draw_window(
             yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, yellow_shields,
            red_bullets,red_slow_bullets, red_fast_bullets, red_shields,
            yellow, red, red_health, yellow_health, red_shield_health, yellow_shield_health, display_fps)
    main()

if __name__ == "__main__":
    main()