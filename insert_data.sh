#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    TEAM_NAME1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM_NAME1 ]]
    then
      INSERT_TEAM_NAME1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_NAME1 == "INSERT 0 1" ]]
      then
        echo Inserted Team $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    TEAM_NAME2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_NAME2 ]]
    then
      INSERT_TEAM_NAME2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME2 == "INSERT 0 1" ]]
      then
        echo Inserted Team $OPPONENT
      fi
    fi
  fi

  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "Match added: $YEAR, '$ROUND', $WINNER vs $OPPONENT, final score $WINNER_GOALS : $OPPONENT_GOALS"
    fi
  fi
done