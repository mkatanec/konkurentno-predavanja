Pokretanje

1. Build projekta
2. unutar `out\production\labExercise` pokrenuti `docker build -t homework .`
3. Pokrenuti 2 node-a
    - `docker run -it --rm --name hrd -h hr.local homework -sname hr`
    - `docker run -it --rm --name iod -h io.local homework -sname io`
    - `docker run -it --rm --name comd -h com.local homework -sname com`
    - `docker run -it --rm --name balancerd -h balancer.local --link hrd:hr --link iod:io --link comd:com homework -sname balancer`
4. Pozivi sekvencijalnih metoda
    - `balancer:add({"www.address.hr", "1.11.1.1."})`
    - `balancer:replace({"www.address.hr", "1.11.1.1."})`
    - `balancer:remove({"www.address.hr", "1.11.1.1."})`
    - `balancer:find("www.address.hr")`