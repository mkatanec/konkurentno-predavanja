## Pokretanje drugog labosa

1. Build projekta
2. Pokrenuti aplikaciju `application:start(dns).`
3. Pomocu observera provjeriti da li je aplikacija stvarno pokrenuta `observer:start().`
4. Pozvati metode za dodavanje, brisanje, izmjenu i pronalazak (podrazni su `hr`, `io` i `com` tld-ovi
    - dodavanje `balancer_serv:add({"www.nes.hr", "1.1.1.1."}).`
    - brisanje `balancer_serv:delete({"www.nes.hr", "1.1.1.1."}).`
    - izmjena `balancer_serv:delete({"www.nes.hr", "1.1.1.2."}).`
    - pronalazak `balancer_serv:delete("www.nes.hr").`