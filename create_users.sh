#!/bin/bash

# avslutas om en kommand är fel
set -e 

# Detta kontrollerar om skriptet körs som root

if [ "$EUID" -ne 0 ]; then
echo "ERROR: Detta skript måste köras som root."
exit 1
fi

# Detta kontrollerar om minst ett användarnamn anges, annars avslutas programmet om så inte är fallet
if [ "$#" -lt 1 ]; then
echo "Änvändning: $0 Användarnamn1 Användarnamn2 ..."
exit 1
fi

#Här loopar den genom alla användarnamn som skickas som argument
for username in "$@"; do

# here where we create user with home directory if it dosent exist
if id "$username" &>/dev/null; then
echo "Användare $username finns redan, hoppar över..."
continue
fi

useradd -m "$username"
done

# Definierar hemkatalogen
for username in "$@"; do
home_dir="/home/$username"

# De tre nödvändiga mapparna skapas här
mkdir -p "$home_dir/Documents"
mkdir -p "$home_dir/Downloads"
mkdir -p "$home_dir/Work"


# skapar en välkomstfil och placerar den i användarens hemkatalog
welcome_file="$home_dir/welcome.txt"

echo "Välkommen $username!" > "$welcome_file"
echo "Här är de nurvarande användarna i systemet: " >> "$welcome_file"
cut -d: -f1 /etc/passwd >> "$welcome_file"

# Sätter ägerskap till användaren
chown -R "$username:$username" "$home_dir"
chmod -R 700 "$home_dir"

echo "Användare $username skapades framgångsrikt."

done

echo "Klart."