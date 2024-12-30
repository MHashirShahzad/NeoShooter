# Importing the required modules
import pygame
import os
import sys
pygame.font.init()
pygame.mixer.init()

os.environ['SDL_VIDEO_CENTERED'] = '1' # You have to call this before pygame.init()
pygame.init()
info = pygame.display.Info() # You have to call this before pygame.display.set_mode()

# Constant width , height and creating window and setting its name
WIDTH, HEIGHT = info.current_w, info.current_h
WIN = pygame.display.set_mode((WIDTH - 10 , HEIGHT - 10), pygame.FULLSCREEN)
pygame.display.set_caption("Two Player Game")

# Constants
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

HEALTH_FONT = pygame.font.SysFont("comicsans", 40)
WINNER_FONT = pygame.font.SysFont("comicsans", 40)

FPS = 60
SPACESHIP_WIDTH, SPACESHIP_HEIGHT = 55, 40

YELLOW_HIT = pygame.USEREVENT + 1
RED_HIT = pygame.USEREVENT + 2

YELLOW_SPACESHIP_IMAGE = pygame.image.load(
    os.path.join(
        "Assets","spaceship_yellow.png"))

YELLOW_SPACESHIP = pygame.transform.rotate(
    pygame.transform.scale(
    YELLOW_SPACESHIP_IMAGE, 
    (SPACESHIP_WIDTH, SPACESHIP_HEIGHT)),90)

RED_SPACESHIP_IMAGE = pygame.image.load(
       os.path.join(
         "Assets","spaceship_red.png"))

RED_SPACESHIP = pygame.transform.rotate(
    pygame.transform.scale(
    RED_SPACESHIP_IMAGE, 
    (SPACESHIP_WIDTH, SPACESHIP_HEIGHT)), 270)

SPACE = pygame.transform.scale(pygame.image.load(
    os.path.join( "Assets", "space.png")), (WIDTH, HEIGHT))

def draw_winner(text):
    DEAD_SOUND.play()
    draw_text = WINNER_FONT.render(text, 1, WHITE) 
    WIN.blit(draw_text, (WIDTH/2 - draw_text.get_width() /
                         2, HEIGHT/2 - draw_text.get_height()/2))
    pygame.display.update()
    pygame.time.delay(5000)


def red_handle_movement(keys_pressed, red):
    if keys_pressed[pygame.K_LEFT] and red.x - 1 > BORDER.x: # on left pressed move left
        red.x -= VELOCITY
        
    if keys_pressed[pygame.K_RIGHT] and red.x + 1 + red.width < WIDTH - 10: # on right pressed move right
        red.x += VELOCITY

    if keys_pressed[pygame.K_UP] and red.y - 1 > 0: # on up pressed move up
        red.y -= VELOCITY
        
    if keys_pressed[pygame.K_DOWN] and red.y + 1 + red.width < BORDER.x : #on down pressed move down
        red.y += VELOCITY

def yellow_handle_movement(keys_pressed, yellow):
    if keys_pressed[pygame.K_a] and yellow.x - 1 > 0: # on a pressed move left
        yellow.x -= VELOCITY
        
    if keys_pressed[pygame.K_d] and yellow.x + 1 + yellow.width < BORDER.x: # on d pressed move right
        yellow.x += VELOCITY

    if keys_pressed[pygame.K_w] and yellow.y - 1 > 0: # on w pressed move up
        yellow.y -= VELOCITY
        
    if keys_pressed[pygame.K_s] and yellow.y + 1 + yellow.width < BORDER.x: #on s pressed move down
        yellow.y += VELOCITY

def handle_bullets(yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, red_bullets,red_slow_bullets, red_fast_bullets, yellow, red):
    for bullet in yellow_bullets:
        bullet.x += BULLET_VELOCITY
        if red.colliderect(bullet):
            pygame.event.post(pygame.event.Event(RED_HIT))
            yellow_bullets.remove(bullet)
        elif bullet.x > WIDTH:
            yellow_bullets.remove(bullet)
    for slow_bullet in yellow_slow_bullets:
        slow_bullet.x += SLOW_BULLET_VELOCITY
        if red.colliderect(slow_bullet):
            pygame.event.post(pygame.event.Event(RED_HIT))
            yellow_slow_bullets.remove(slow_bullet)
        elif slow_bullet.x > WIDTH:
            yellow_slow_bullets.remove(slow_bullet)
    for fast_bullet in yellow_fast_bullets:
        fast_bullet.x += FAST_BULLET_VELOCITY
        if red.colliderect(fast_bullet):
            pygame.event.post(pygame.event.Event(RED_HIT))
            yellow_fast_bullets.remove(fast_bullet)
        elif fast_bullet.x > WIDTH:
            yellow_fast_bullets.remove(fast_bullet)
    
    for bullet in red_bullets:
        bullet.x -= BULLET_VELOCITY
        if yellow.colliderect(bullet):
            pygame.event.post(pygame.event.Event(YELLOW_HIT))
            red_bullets.remove(bullet)
        elif bullet.x < 0:
            red_bullets.remove(bullet)
    for slow_bullet in red_slow_bullets:
        slow_bullet.x -= SLOW_BULLET_VELOCITY
        if yellow.colliderect(slow_bullet):
            pygame.event.post(pygame.event.Event(YELLOW_HIT))
            red_slow_bullets.remove(slow_bullet)
        elif slow_bullet.x < 0:
            red_slow_bullets.remove(slow_bullet)
    for fast_bullet in red_fast_bullets:
        fast_bullet.x -= FAST_BULLET_VELOCITY
        if yellow.colliderect(fast_bullet):
            pygame.event.post(pygame.event.Event(YELLOW_HIT))
            red_fast_bullets.remove(fast_bullet)
        elif fast_bullet.x < 0:
            red_fast_bullets.remove(fast_bullet)

def draw_window(yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, red_bullets,red_slow_bullets, red_fast_bullets, yellow, red, red_health, yellow_health):
    WIN.blit(SPACE,(0, 0))
    pygame.draw.rect(WIN, BLACK, BORDER)

    red_health_text = HEALTH_FONT.render("Health :"+ str(red_health), 1, RED)
    yellow_health_text = HEALTH_FONT.render("Health:" + str(yellow_health), 1, YELLOW)
    WIN.blit(red_health_text, (WIDTH - red_health_text.get_width() - 10, 10))
    WIN.blit(yellow_health_text, (10, 10))

    WIN.blit(YELLOW_SPACESHIP, (yellow.x, yellow.y))
    WIN.blit(RED_SPACESHIP, (red.x, red.y))

    for bullet in red_bullets:
        pygame.draw.rect(WIN, RED, bullet)
    for slow_bullet in red_slow_bullets:
        pygame.draw.rect(WIN, (247, 45, 45), slow_bullet)
    for fast_bullet in red_fast_bullets:
        pygame.draw.rect(WIN, (252, 126, 126), fast_bullet)

    for bullet in yellow_bullets:
        pygame.draw.rect(WIN, YELLOW, bullet)
    for slow_bullet in yellow_slow_bullets:
        pygame.draw.rect(WIN, (252, 252, 53), slow_bullet)
    for fast_bullet in yellow_fast_bullets:
        pygame.draw.rect(WIN, (227, 252, 126), fast_bullet)
    pygame.display.update()

def main():
    red = pygame.Rect(
    900, 400, SPACESHIP_WIDTH, SPACESHIP_HEIGHT)
    yellow = pygame.Rect(
    200, 100, SPACESHIP_WIDTH, SPACESHIP_HEIGHT)

    
    red_bullets = []
    red_slow_bullets = []
    red_fast_bullets = []
    yellow_bullets = []
    yellow_slow_bullets = []
    yellow_fast_bullets = []
    red_health = 10
    yellow_health = 10

    winner_text = ""

    clock = pygame.time.Clock()
    #run state to keep the game runnimg
    run = True
    while run:
        clock.tick(FPS)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False
                pygame.quit()
            
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    run = False
                    pygame.quit()
                if event.key == pygame.K_f and len(yellow_bullets) < 3:
                    bullet = pygame.Rect(
                        yellow.x + yellow.width, yellow.y + yellow.height//2 - 2, 15, 10 )
                    yellow_bullets.append(bullet)
                    BULLET_FIRE_SOUND.play()
                if event.key == pygame.K_g and len(yellow_slow_bullets) < 3:
                    slow_bullet = pygame.Rect(
                        yellow.x + yellow.width, yellow.y + yellow.height//2 - 2, 30, 25 )
                    yellow_slow_bullets.append(slow_bullet)
                    BULLET_FIRE_SOUND.play()
                if event.key == pygame.K_h and len(yellow_fast_bullets) < 1:
                    fast_bullet = pygame.Rect(
                        yellow.x + yellow.width, yellow.y + yellow.height//2 - 2, 10, 10 )
                    yellow_fast_bullets.append(fast_bullet)
                    BULLET_FIRE_SOUND.play()

                if event.key == pygame.K_KP1 and len(red_bullets) < 3:
                    bullet = pygame.Rect(
                        red.x , red.y + red.height//2 - 2, 15, 10 )
                    red_bullets.append(bullet)
                    BULLET_FIRE_SOUND.play()
                if event.key == pygame.K_KP2 and len(red_slow_bullets) < 3:
                    slow_bullet = pygame.Rect(
                        red.x , red.y + red.height//2 - 2, 30, 25 )
                    red_slow_bullets.append(slow_bullet)
                    BULLET_FIRE_SOUND.play()
                if event.key == pygame.K_KP3 and len(red_fast_bullets) < 1:
                    fast_bullet = pygame.Rect(
                        red.x , red.y + red.height//2 - 2, 10, 10 )
                    red_fast_bullets.append(fast_bullet)
                    BULLET_FIRE_SOUND.play()
            
            if event.type == RED_HIT:
                red_health -= 1
                BULLET_HIT_SOUND.play()

            if event.type == YELLOW_HIT:
                yellow_health -= 1
                BULLET_HIT_SOUND.play()

        if red_health <= 0:
            winner_text = "YELLOW Wins!"
        
        if yellow_health <= 0:
            winner_text = "RED Wins"
        
        if winner_text != "":
            draw_winner(winner_text)
            break
        
        keys_pressed = pygame.key.get_pressed()

        yellow_handle_movement(keys_pressed, yellow)
        red_handle_movement(keys_pressed, red)

        handle_bullets(
            yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, red_bullets,red_slow_bullets, red_fast_bullets, yellow, red)
        draw_window(
            yellow_bullets, yellow_slow_bullets, yellow_fast_bullets, red_bullets,red_slow_bullets, red_fast_bullets, yellow, red, red_health, yellow_health)
    main()

if __name__ == "__main__":
    main()