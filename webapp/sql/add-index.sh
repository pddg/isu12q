#!/bin/sh

for db in ${HOME}/initial_data/*.db; do
  echo "Start: $db"
  sqlite3 ${db} <<EOF
CREATE INDEX idx_competition_id ON player_score(competition_id);
CREATE INDEX idx_player_id ON player_score(player_id);
EOF
  echo "End: $db"
done
