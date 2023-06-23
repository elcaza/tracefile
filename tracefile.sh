#!/usr/bin/env bash

if [ "$#" -ne 1 ]; 
    then echo "Use: $0 file"
    exit
fi

FILE=$1
OUTPUT="./output"

# Prueba si el archivo termina con un salto de línea
function file_ends_with_newline() {
    [[ $(tail -c1 "$1" | wc -l) -gt 0 ]]
}

# Función para realizar un traceroute asincrono
function trace_async {
    host=$1
    date > $OUTPUT/traceroute_$host.txt
    traceroute $host | tee -a $OUTPUT/traceroute_$host.txt &
}

# Probando si el archivo termina con un salto de línea
if ! file_ends_with_newline $FILE
then
    echo "" >> $FILE
    echo "Añadiendo un salto de línea al archivo" 
fi

# Creando la carpeta output en caso de que no exista
mkdir $OUTPUT 2> /dev/null

# Ejecución de traceroute asincrono
cat $FILE | (while read host; do trace_async $host; done) 