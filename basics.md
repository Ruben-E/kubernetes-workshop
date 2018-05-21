# Basics
De beginselen van Kubernetes.

*Als je voor een pod of service poorten moet kiezen: alle applicaties draaien staandaard op 8080!*

## Doelen
1. Een pod starten in ons cluster
2. De pod bereikbaar maken via een service
3. Pod omzetten naar een deployment
4. Readyness en liveness probes toevoegen
5. Resilience testen van deployment
6. Pods laten communiceren met elkaar

### 1. Pod starten
We beginnen met het starten met een losse pod. Een losse pod wordt niet veel gebruikt. We zullen later zien waarom :). Dit biedt echter wel een mooie opstap naar een deployment.

We willen een pod starten met een playground applicatie.

Maak een .yaml bestand met een pod definitie: 
 - 1 container: `rubenernst/kubernetes-playground:1.0.1`.
 - label: `app=playground`
 - specificeer poort 8080

Start de pod
 
### 2. Expose pod
Nu de pod actief is in het cluster, willen we deze bereikbaar maken via internet. Dit doen we door middel van een service.

Maak een .yaml bestand met een service definitie:
 - type: `loadbalancer`
 - configureer de poorten (8080)
 
Bezoek de service en kijk of je bij de pod kan komen: `http://<ip>:<poort>/actuator/info`

Hints:
 - Denk aan de selector (`app=playground`)
 - IP via `kubectl get service`
 
### 3. Migreer de pod definitie naar een deployment
Een Pod alleen wordt niet veel gebruikt. Het wordt namelijk niet goed (genoeg) beheerd: bij een crash van een node wordt geen nieuwe opgestart. Daarom zijn er ReplicationControllers. En die worden weer beheerd door een deployment i.v.m. rolling updates.
  
Definineer een .yaml of .json file met een deployment voor onze playground applicatie. Zet aantal replicas op drie. Voeg weer selector `app=openvalue` toe. Verwijder de service niet door de selector worden deze nieuwe pods automatisch aan de service gekoppeld.

Check of load balancing werkt door de app te bezoeken op `/actuator/info`. De hostname zou moeten wijzigen bij een aantal refreshes.

Hints:
 - Verwijder eerst de pod (`kubectl delete -f <file>` of `kubectl delete pod <name>`)
 
### 4. Readyness en liveness probes 
Kubernetes heeft uitstekende ondersteuning voor healthchecks. Als een pod unhealthy wordt (voor een bepaalde tijd), kan deze automatisch worden herstart.
Onze playground applicatie heeft ook een ingebouwde healthcheck: `/actuator/health`.

Configureer dit endpoint voor readyness en liveness probes. De applicatie start ongeveer in 10-15 seconden. Hou hier rekening mee bij het configureren van de parameters.

Check bij opstarten wat er veranderd aan de `READY` kolom bij `kubectl get pods`.

Hints:
 - Bij een `CrashLoopBackOff` staan de parameters te strak :).
 - `kubectl get pods --watch` om veranderingen aan pods direct te zien
 - `kubectl describe pod <id>` om events van een pod te zien
 
### 5. Resilience testen van deployment
Tijd om de liveness probes te testen :).

Roep endpoint `/actuator/unhealthy` aan op 1 van de pods via de service.
Check wat kubernetes doet met de pods (`kubectl get pods --watch`)

Onze pods zijn onderdeel van een deployment met een vast aantal replicas. Delete een pod eens handmatig en kijk wat kubernetes vervolgens doet met de pods.
  
### 6. Communicatie tussen pods
Tot nu toe hebben waren de pods standalone, maar vaak heb je communicatie naar iets anders nodig: een database, andere service, eventbus etc.

Dit gaan wij ook doen! Er zijn twee docker images beschikbaar: `rubenernst/kubernetes-user-service:1.0.0` en `rubenernst/kubernetes-user-service-proxy:1.0.0`. Zoals de naam aangeeft, is de laatste een proxy voor de eerste. 

Zet twee deployments op. De laatste (proxy) moet HTTP requests doorsturen naar de eerste (user-service). Een gebruikelijke manier om het endpoint van een service aan een andere service door te geven, zijn environment variabelen. De environment variabele voor de proxy zijn `USER_SERVICE_HOST` en `USER_SERVICE_PORT`. 

Test of de proxy werkt door deze in de browser aan te roepen.

Hints:
 - Services (ook interne) :)
