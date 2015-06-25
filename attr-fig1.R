### Figure 1 for attractiveness manuscript
### Author: S Bauldry
### Date: June 17, 2015

# Lattice graphics
library(lattice)

# parent education and latent personality
ped <- seq(0, 5)
per <- seq(-1, 1, .05)
grd1 <- expand.grid(ped = ped, per = per)
grd1$edu <- .28*grd1$ped + .53*grd1$per - .07*grd1$ped*grd1$per

ped <- seq(0, 5)
phy <- seq(-1, 1, .05)
grd2 <- expand.grid(ped = ped, phy = phy)
grd2$edu <- .20*grd2$ped + .25*grd2$phy - .06*grd2$ped*grd2$phy


left  <- wireframe( edu ~ ped * per, data = grd1, 
                    scales = list(arrows = F), 
                    xlab = list("parent education", rot = 26),
                    ylab = list("personality", rot = -35),
                    zlab = list("effect on education", rot = 92),
                    main = "Personality Attractiveness")

right <- wireframe( edu ~ ped * phy, data = grd2, 
                    scales = list(arrows = F), 
                    xlab = list("parent education", rot = 26),
                    ylab = list("physical", rot = -35),
                    zlab = list("effect on education", rot = 92),
                    main = "Physical Attractiveness")

print(left, split = c(1,1,2,1), more = T)
print(right, split = c(2,1,2,1))


