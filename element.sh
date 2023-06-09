#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#Check to see if there is an argument
if [[ -z $1 ]]
then
echo "Please provide an element as an argument."

#Check to see if argument is a number
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")

  #Check to see if that atomic number is in the database
  if [[ -z $ATOMIC_NUMBER ]] 
  then 
  echo "I could not find that element in the database."

  
  else
  #Get element's type_id if name is in database
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

  #Print element info if atomic number is in database
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number=$1")
  PROPERTIES=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$1")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  echo $ELEMENT $PROPERTIES $TYPE | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL TYPE_ID BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

#Check to see if argument is name with 3 more or letters
elif [[ $1 =~ ^[A-Za-z][A-Za-z][A-Za-z]+$ ]]
then
  NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")

  #Check to see if name is in the database
  if [[ -z $NAME ]] 
  then 
  echo "I could not find that element in the database."

  else
  #Get element's atomic_number and type_id if name is in database
  ATOMIC_NUMBER_FROM_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER_FROM_NAME")


  #Print element info
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER_FROM_NAME")
  PROPERTIES=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER_FROM_NAME")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  echo $ELEMENT $PROPERTIES $TYPE | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL TYPE_ID BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

#Check to see if argument is a symbol with 1 or 2 letters
else 
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")

  #Check to see if symbol is in the database
  if [[ -z $SYMBOL ]] 
  then 
  echo "I could not find that element in the database."

  else
  #Get element's atomic_number and type_id if name is in database
  ATOMIC_NUMBER_FROM_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER_FROM_SYMBOL")

  #Print element info
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER_FROM_SYMBOL")
  PROPERTIES=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER_FROM_SYMBOL")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  echo $ELEMENT $PROPERTIES $TYPE | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL TYPE_ID BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT TYPE
    do
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
