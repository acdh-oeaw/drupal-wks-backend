# Information
For creating and populating Drupal instance.

We do have a default Dockerfile and docker-compose (currently work in progress) that is derived as a fork.

The website port is hard coded on 5000.

# Workflow for creating a Drupal on k8s-cluster
* Create a fork and work in it
* Set the secrets in the production environment
* Adapt the starter.yaml and change the `APP_name`
* Adapt the `composer/composer.json` or move it (see secton move Drupal)
* Create the namespace on rancher
* Activate the actions in the settings
* Push and deploy, wait for the action to be run successful
* Create a persistent storage for the files and map to the files-directory (todo: add it to the values.yaml of the autodeply)
* Chown the files-directory to www-data

# Move Drupal
If you move an old Drupal:
* Copy the files into the persistent storage files-directory
* Update the composer.json to Drupal 10 (set the used modules/themes to a Drupal 10 compliant version) in the `composer`-directory in the repo
* Move the custom modules and themes to `custom`-directory in the repo

# Secrets to set
(when using the ACDH-CH starter worklfow add `K8S_SECRET_` at the beginning)
| Name | Variable/Secret | Value |
| ------ | ------ | ------ |
| `DBHOST` | Variable | Database host name - text |
| `DBNAME` | Variable | Database name - text |
| `DBPORT` | Variable | Database port - text |
| `DBPREFIX` | Variable | Database prefix - text |
| `DBUSER` | Variable | Database user - text |
| `DRUPALTRUSTEDHOST` | Variable | Trusted host settings for Drupal (set to your domain) - specific JSON, e.g. `'^mydomain\.at$', '^.+\.mydomain\.at$',` |
| `DBPSWD` | Secret | Database password - text |
| `DRUPALHASH` | Secret | Drupal hash to identify website - text |

# Import configuration
Config is used to upgrade Drupal websites. Always run a `drush cex` on the development instance and push it, so that changes are synced with the production instance. Don't do changes in the production instance! The config-directory is outside the web-environment.

For the basic instance, configs are not used, but the forks will use it. When merging the fork be aware that changes in config and custom may be overwritten (depending on the timeline). For the default-repo it is important, to leave the directories config and custom as they are, otherwise there may be problems when merging changes from drupal-default to the forks.

