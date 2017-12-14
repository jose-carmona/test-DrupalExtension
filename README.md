# test-DrupalExtension
Entorno de test basado en Docker para DrupalExtension

### ¿Cómo funciona?

- Construimos la máquina Docker

docker build -t jose-carmona/test-drupalextension .

docker-compose up -d

docker-compose exec drupal bash /test.sh
