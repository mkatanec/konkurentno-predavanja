Pokretanje

1. Build projekta
1. unutar `out\production\labExercise` pokrenuti `docker build -t lab-exercise .`
1. Pokrenuti 2 node-a
    - `docker run -it --rm --name findd -h find.local lab-exercise -sname find`
    - `docker run -it --rm --name addd -h add.local lab-exercise -sname add`
    - `docker run -it --rm --name deleted -h delete.local lab-exercise -sname delete`
    - `docker run -it --rm --name balancerd -h balancer.local --link findd:find --link addd:add --link deleted:delete lab-exercise -sname balancer`
1. ROKAJ!
    - `balancer:add(1)`
    - `balancer:remove(1)`
    - `balancer:find(1)`