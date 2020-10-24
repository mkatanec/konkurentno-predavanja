## Prvi zadatak
1. Build projekta
1. unutar `out\production\fifthLecture` pokrenuti `build -t kp_five_one .`
1. Pokrenuti 2 node-a
    - `docker run -it --rm --name yd -h y.local kp_five_one -sname y`
    - `docker run -it --rm --name xd -h x.local --link yd:y kp_five_one -sname x`
1. Na jednom od nodova spojiti drugi
    - `P = spawn('y@y', api, server_loop, [maps:new()]).`
2. Poslati poruku na drugi ndoe
    - `P!{self(), dsk}.`
    
## Drugi zadatak
1. Build projekta
1. unutar `out\production\fifthLecture` pokrenuti `build -t kp_five_one .`
1. Pokrenuti 2 node-a
    - `docker run -it --rm --name yd -h y.local kp_five_one -sname y`
    - `docker run -it --rm --name xd -h x.local --link yd:y kp_five_one -sname x`
3. Globalno registrirati proces na `y`
    - `globalApi:start_global().`
3. Povezati `x` i `y`
    - `net_kernel:connect_node('y@y').`
4. Poslati na `y` s `x`
    - `globalApi:call_global(hdkj).`
    
## Treci zadatak
1. Build projekta
1. unutar `out\production\fifthLecture` pokrenuti `build -t kp_five_one .`
3. Globalno registrirati proces na `y`
    - `globalApi:start_global().`
1. Pokrenuti 2 node-a
    - `docker run -it --rm --name yd -h y.local kp_five_one -sname y`
    - `docker run -it --rm --name xd -h x.local --link yd:y kp_five_one -sname x`
4. Poslati na `y` s `x`
    - `globalApi:call_global(hdkj).`

## Fulani pokusaj
1. Build projekta
1. unutar `out\production\fifthLecture` pokrenuti `build -t kp_five_one .`
1. Pokrenuti 2 node-a
    - `docker run -it --rm --name yd -h y.local kp_five_one -sname y`
    - `docker run -it --rm --name xd -h y.local kp_five_one -sname x`
1. Pokrenuti hosta 
    - `docker run -it --rm --name xd -h x.local --link yd:y --link xd:x kp_five_one -sname x`
    - `balancer:run().`  
1. Pogodit balancer s 
    - `server!{self(), add, {"Mac", "Miller", [maps:new()]}}`
    - `server!{self(), replace, {"Mac", "Miller", [{"Netko", "Drug"}]}}`
    - `server!{self(), delete, {"Mac", "Miller"}}`
    - `server!{self(), find, {"Mac", "Miller"}}`