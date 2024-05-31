For populating the Drupal test instance

We do have a default Dockerfile and docker-compose which is integrated as submodule

workflow
* Create a fork
* set the secrets in the production environment
* adapt the starter.yaml and change the APP_name
* push and deploy
* create a persistend storage for the files (todo: add it to the values.yaml of the autodeply)
* chown the files to www-data
