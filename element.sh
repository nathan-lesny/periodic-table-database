#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align 
-c"


if [[ $1 ]]
then
  re='^[0-9]+$'
  if [[ $1 =~ $re ]]
  then
  ATOMIC_NUM="$($PSQL "SELECT atomic_number FROM properties WHERE 
atomic_number=$1")"
  fi
  if [[ -z $ATOMIC_NUM ]]
  then
    ATOMIC_NUM="$($PSQL "SELECT atomic_number FROM elements WHERE 
symbol='$1'")"
    if [[ -z $ATOMIC_NUM ]]
    then
      ATOMIC_NUM="$($PSQL "SELECT atomic_number FROM elements WHERE 
name='$1'")"
      if [[ -z $ATOMIC_NUM ]]
      then
        echo -e "I could not find that element in the database."
        exit
      fi
    fi
fi
  ATOM_NAME="$($PSQL"SELECT name FROM elements WHERE 
atomic_number=$ATOMIC_NUM")"
  ATOM_SYMBOL="$($PSQL"SELECT symbol FROM elements WHERE 
atomic_number=$ATOMIC_NUM")"
  ATOMIC_MASS="$($PSQL"SELECT atomic_mass FROM properties WHERE 
atomic_number=$ATOMIC_NUM")"
  MELTING_POINT="$($PSQL"SELECT melting_point_celsius FROM properties 
WHERE atomic_number=$ATOMIC_NUM")"
  TYPE="$($PSQL"SELECT type FROM types INNER JOIN properties 
USING(type_id) WHERE atomic_number=$ATOMIC_NUM")"
  BOILING_POINT="$($PSQL"SELECT boiling_point_celsius FROM properties 
WHERE atomic_number=$ATOMIC_NUM")"

  echo -e "The element with atomic number $ATOMIC_NUM is $ATOM_NAME 
($ATOM_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOM_NAME 
has a melting point of $MELTING_POINT celsius and a boiling point of 
$BOILING_POINT celsius."
else
  echo -e "Please provide an element as an argument."
fi

