#!/bin/bash

# connect to database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# FULL JOIN
FULL_JOIN="SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number FULL JOIN types ON properties.type_id = types.type_id"

# not found function
NOT_FOUND() {
  echo "I could not find that element in the database."
}

# MESSAGE FUNCTION
MESSAGE() {
  if [[ -z $INFO ]]
  then
    NOT_FOUND
  else
    echo $INFO | while read ATOM_NUM BAR NAME BAR SYMBOL BAR TYPE BAR ATOM_MASS BAR M_POINT BAR B_POINT
    do
      echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOM_MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
    done
  fi
}

# if no argument, print standard message
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."

# if argument
else
  # if argument is valid atomic number, print information about the element
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    INFO=$($PSQL "$FULL_JOIN WHERE elements.atomic_number = $1")
    MESSAGE
    
  # if argument is symbol, print information about the element
  elif [[ $1 =~ ^[A-Z][a-z]{0,1}$ ]]
  then
    INFO=$($PSQL"$FULL_JOIN WHERE elements.symbol = '$1'")
    MESSAGE

  # if argument is element name, print information about it
  elif [[ $1 =~ ^[A-Za-z]{3,}$ ]]
  then
    INFO=$($PSQL"$FULL_JOIN WHERE elements.name = '$1'")
    MESSAGE

  # if argument is not valid
  else
    NOT_FOUND
  fi
fi
