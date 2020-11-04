Pokretanje

1. Build projekta
1. unutar `out\production\labExercise` pokrenuti `docker build -t homework .`
1. Pokrenuti 2 node-a
    - `docker run -it --rm --name hrd -h hr.local homework -sname hr`
    - `docker run -it --rm --name iod -h io.local homework -sname io`
    - `docker run -it --rm --name comd -h com.local homework -sname com`
    - `docker run -it --rm --name balancerd -h balancer.local --link hrd:hr --link iod:io --link comd:com homework -sname balancer`
1. ROKAJ!
    - `balancer:add(1)`
    - `balancer:remove(1)`
    - `balancer:find(1)`