##Vidar Petersson 2020
##Studsande X
##Kul att lära sig mer om objektorienterad programmering i Ruby :)

class Ball
    #Skapar och initierar attributer till objekten
    attr_accessor :direction, :position, :shape
    def initialize(grid)
        #Spelplanen tänks som ett rutnät med kordinater i x- och y-led. Element på index 0 respresenterar värden kopplade till x-led. ( [0,1] = (x,y) )
        @direction = rand(-1..1), rand(-1..1)
        @position = rand(1..grid[0].length-2), rand(1..grid.length-2)
        @shape = "X"
    end

    #Uppdaterar objektets position beroende på dess riktning
    def update
        @position[0] += @direction[0]
        @position[1] += @direction[1]
    end

    def check_collision(balls, grid)
        #Kollar kollision med andra objekt
        for i in 0..balls.length-1
            if balls[i] != self
                if @position[0] == balls[i].position[0] && @position[1] == balls[i].position[1]
                    @direction[0] = @direction[0] * -1
                    @direction[1] = @direction[1] * -1
                end
                if @position[0] + @direction[0] == balls[i].position[0] && @position[1] + @direction[1] == balls[i].position[1]
                    @direction[0] = @direction[0] * -1
                    @direction[1] = @direction[1] * -1
                end
            end
        end

        #Kollar kollision mot rutnätets väggar
        if (@position[0] >= grid[0].length-1 && @direction[0] != -1) || (@position[0] <= 0 && @direction[0] != 1)
            @direction[0] = @direction[0] * -1
        end
        if (@position[1] >= grid.length-1 && @direction[1] != -1) || (@position[1] <= 0 && @direction[1] != 1)
            @direction[1] = @direction[1] * -1
        end
    end
end

#Spelplanen nestår av en lista med listor som element (2D lista)
grid = Array.new(7) { "==============" }
balls = []

#Skapar en lista med objekten
for i in 0..2
    balls[i] = Ball.new(grid)
end

while true
    #Skriver ut riktning- och positiondata för enklare överblick och debugging
    for i in 0..balls.length-1
        p balls[i].direction
        p balls[i].position
    end

    #Uppdaterar det tomma rutnätet med objekten
    for i in 0..balls.length-1
        grid[balls[i].position[1]][balls[i].position[0]] = balls[i].shape
    end

    #Skriver ut och visar spelplanen i cmd
    puts grid
    sleep(0.2)
    #Skapar ett nytt rutnät, skriver över det gamla
    system("cls")
    grid = Array.new(7) { "==============" }

    #Kollar kollision med metoden check_collission
    for i in 0..balls.length-1
        balls[i].check_collision(balls, grid)
    end

    #Uppdaterar objektens positioner med metoden update
    for i in 0..balls.length-1
        balls[i].update
    end
end

##Problem: Flera instanser kan stänga in objekt som gör att de går Out of Bounds
##TODO: På grund av spelets natur sker det ibland vissa skumma kollisioner. Om 2 objekt är påväg mot samma ruta kommer de i en bildruta vara på samma koordinater. Finns ingen direkt lösning utan att öka upplösningen på spelplanen
##Idé: Kollisionerna kan omarbetas. Det är möjligt att vissa objekt inte rör sig i antingen ett eller två led. Programmet inverterar bara riktningen på de objekt som krockar. Vill man göra det mer realistiskt med rörelsemängd, borde stillastående objekt "knuffas" igång. Riktningarna efter kollisionerna kan även beräknas bättre med hänsyn till kollisionsvinkel etc. för att få mer naturliga kollisioner.  