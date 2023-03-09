#!/bin/bash

echo "Bootstrap:"
echo "tmlsavedirectory=$TML_SAVE_DIRECTORY"
echo "world_file_name=$WORLD_FILENAME"
echo "logpath=/terraria-server/tModLoader-Logs/"

WORLD_PATH="$TML_SAVE_DIRECTORY/Worlds/$WORLD_FILENAME"

if [ ! -f "$TML_SAVE_DIRECTORY/$CONFIG_FILENAME" ]; then
    echo "Server configuration not found, running with default server configuration."
    echo "Please ensure your desired $CONFIG_FILENAME file is volumed into docker: -v <path_to_config_file>:/$TML_SAVE_DIRECTORY"
    cp ./serverconfig-default.txt $TML_SAVE_DIRECTORY/$CONFIG_FILENAME
fi

if [ -z "$WORLD_FILENAME" ]; then
  echo "No world file specified in environment WORLD_FILENAME."
  if [ -z "$@" ]; then
    echo "Running server setup..."
  else
    echo "Running server with command flags: $@"
  fi
  exec dotnet tModLoader.dll -server -tmlsavedirectory "$TML_SAVE_DIRECTORY" -config "$TML_SAVE_DIRECTORY/$CONFIG_FILENAME" "$@"
else
  echo "Environment WORLD_FILENAME specified"
  if [ -f "$WORLD_PATH" ]; then
    echo "Loading to world $WORLD_FILENAME..."
    exec dotnet tModLoader.dll -server -tmlsavedirectory "$TML_SAVE_DIRECTORY" -config "$TML_SAVE_DIRECTORY/$CONFIG_FILENAME" -world "$WORLD_PATH" "$@"
  else
    echo "Unable to locate $WORLD_PATH."
    echo "Please make sure your world file is volumed into docker: -v <path_to_world_file>:$WORLDPATH"
    exit 1
  fi
fi

