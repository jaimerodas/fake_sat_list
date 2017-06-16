# Examen para candidatos de backend

## Instalación

Sólo lo probé con Ruby v2.4, pero probablemente jala en 2.3. Una vez clonado el
repo a tu local, instalas las gemas con:

```bash
bundle install
```

y corres en modo development con:

```
ruby fake_sat_list.rb
```

ahora accesa a [localhost:4567](http://localhost:4567)

Para correrlo en modo producción, checa la configuración en [/config/puma.rb](/config/puma.rb) y lo corres con 

```bash
puma -e production
```

Yo lo tengo así y puse un nginx en frente. Hasta ahora ha jalado bien.
