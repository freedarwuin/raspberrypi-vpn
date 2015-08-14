#!/bin/bash 
 
# Default Variable Declarations 
DEFAULT="Default.txt" 
FILEEXT=".ovpn" 
CRT=".crt" 
KEY=".3des.key" 
CA="ca.crt" 
TA="ta.key" 
 
#Ask for a Client name 
echo "Por favor ingrese un nombre de cliente existente:"
read NAME 
 
 
#1st Verify that client’s Public Key Exists 
if [ ! -f $NAME$CRT ]; then 
 echo "[ERROR]: No se encontró el certificado de clave pública del cliente: $NAME$CRT"
 exit 
fi 
echo "Certificado del cliente encontrado: $NAME$CR"
 
 
#Then, verify that there is a private key for that client 
if [ ! -f $NAME$KEY ]; then 
 echo "[ERROR]: No se encontró la clave privada del cliente 3des: $NAME$KEY"
 exit 
fi 
echo "Clave privada del cliente encontrada: $NAME$KEY"
 
#Confirm the CA public key exists 
if [ ! -f $CA ]; then 
 echo "[ERROR]: No se encontró la clave pública de CA: $CA"
 exit 
fi 
echo "Clave pública de CA encontrada: $CA"
 
#Confirm the tls-auth ta key file exists 
if [ ! -f $TA ]; then 
 echo "[ERROR]: No se encontró la clave tls-auth: $TA"
 exit 
fi 
echo "Clave privada tls-auth encontrada: $TA"
 
#Ready to make a new .opvn file - Start by populating with the 
#default file 
cat $DEFAULT > $NAME$FILEEXT 
 
#Now, append the CA Public Cert 
echo "<ca>" >> $NAME$FILEEXT 
cat $CA >> $NAME$FILEEXT 
echo "</ca>" >> $NAME$FILEEXT
 
#Next append the client Public Cert 
echo "<cert>" >> $NAME$FILEEXT 
cat $NAME$CRT | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> $NAME$FILEEXT 
echo "</cert>" >> $NAME$FILEEXT 
 
#Then, append the client Private Key 
echo "<key>" >> $NAME$FILEEXT 
cat $NAME$KEY >> $NAME$FILEEXT 
echo "</key>" >> $NAME$FILEEXT 
 
#Finally, append the TA Private Key 
echo "<tls-auth>" >> $NAME$FILEEXT 
cat $TA >> $NAME$FILEEXT 
echo "</tls-auth>" >> $NAME$FILEEXT 
 
echo "Hecho! $NAME$FILEEXT Creado exitosamente."
