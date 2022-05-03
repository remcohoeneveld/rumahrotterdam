#!/bin/bash

# Project parameters.
PROJECT="therumahrotterdam"

# Determine environment.
if [ "$1" = "prod" ]; then
  ALIAS="@prod"
  DOCROOT="/home/deb105849/domains/therumahrotterdam.nl/httpdocs/"
  echo "Deploying to production environment."
  HOST=deb105849@therumahrotterdam.nl
else
  echo 'use parameter prod'
  exit 0
fi

# Better safe then sorry.
read -p "Are you sure you want to release to $1? [y/n]: " yn
if [ "$yn" = "n" ]
	then echo "aborting"; exit;
fi
read -p "Does the database need updating? [y/n]: " yn
if [ "$yn" = "n" ]
then
  skip_database=1;
else
  skip_database=0;
fi

CUR=`pwd`
SYNC=$HOST:$DOCROOT
DRUSH=vendor/bin/drush
PARAMETERS=""

if [ "$skip_database" = "0" ]; then
  # Backup the database.
  echo "Starting database updating process."

  BACKUP_TIME=`date +"%Y%m%d_%H"`
  BACKUP=backup-$1-$BACKUP_TIME.sql

  # Keep old database.
  echo "Backing up current database in $BACKUP."
  $DRUSH $PARAMETERS $ALIAS cr
  $DRUSH $PARAMETERS $ALIAS sql-dump --result-file=../$BACKUP --gzip
  $DRUSH rsync $ALIAS:../$BACKUP.gz @self:../$BACKUP.gz -y
  $DRUSH $ALIAS ssh rm ../$BACKUP.gz
  if [ ! -f $BACKUP.gz ]; then
    echo "No backup created..."
    exit
  fi
fi

# Sync config.
read -p "Set $1 in maintenance mode while syncing and applying changes? [y/n]: " maintenance_mode
if [ "$maintenance_mode" = "y" ]; then
  $DRUSH $PARAMETERS $ALIAS sset system.maintenance_mode 1 -y
  echo "Putting in maintenance mode."
fi

echo "Starting synchronising files with $1."
rsync -aOgpzr --delete --exclude-from 'deploy_exclude.txt' --links --no-perms --no-owner --no-group ./ $SYNC/
echo "Finished synchronising."

# Apply changes.
if [ "$skip_database" = "0" ]; then
  echo "Apply changes at $ALIAS."
  $DRUSH $PARAMETERS $ALIAS cr
  $DRUSH $PARAMETERS $ALIAS updb
  $DRUSH $PARAMETERS $ALIAS cim sync
  $DRUSH $PARAMETERS $ALIAS cr
fi

# Do environment specific tasks.
if [ "$1" = "prod" ]; then
  # Example.
  $DRUSH $PARAMETERS $ALIAS sset system.maintenance_mode 1
fi

# Disable maintenance mode.
if [ "$maintenance_mode" = "y" ]; then
  $DRUSH $PARAMETERS $ALIAS sset system.maintenance_mode 1
fi

echo "Done. Providing login:"
$DRUSH $PARAMETERS $ALIAS uli --no-browser
