# test-DrupalExtension

Entorno de test para DrupalExtension basado en Docker.

El objetivo es obtener un entorno en el que ejecutar los propios test de drupalExtension.

### En qué consiste

- imagen Docker MariaDB bitnami.
- imagen Docker drupal8 basada en bitnami.
  - instalación de behat + drupalExtension + dependencias en imagen drupal.
  - instalación de nodejs para zombie driver.
  - volumen compartido en ./drupal_data/drupalExtension en el situar drupalExtension.

### ¿Cómo funciona?

Construimos la imagen Docker:

```
docker build -t jose-carmona/test-drupalextension .
```

Copiamos el repositorio drupalExtension:

```
cp -R <ruta-que-sea>/drupalextension/* ./docker_data/drupalExtension/
```

Arrancamos Docker:

```
docker-compose up -d
```

Ejecutamos tests:

```
docker-compose exec drupal bash /test.sh
```

Si necesitas volver a lanzar los tests tras alguna modificación en el código:

```
cp -R <ruta-que-sea>/drupalextension/* ./docker_data/drupalExtension/
docker-compose exec drupal bash /test.sh
```

Si la modificación implica cambios en `fixtures` o en el módulo drupal:

```
cp -R <ruta-que-sea>/drupalextension/* ./docker_data/drupalExtension/
docker-compose exec drupal bash /install_drupalExtension.sh
docker-compose exec drupal bash /test.sh
```

### Problemas conocidos

- Sólo tests de drupal8 (no drupal7 o drupal6)
- Zombie driver no funciona adecuadamente
