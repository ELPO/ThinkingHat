Guía para probar las builds:

1. Requisitos:
-Movil android con una version actualizada del Sistema Operativo (si no sabes si tu movil esta actualizado es que probablemente lo esté)
-Ordenador de cualquier tipo
-Cable (normalmente usb) para conectar el movil al ordenador
-Borrar cualquier versión antigua que tuvieseis en el móvil

2. Conectar el Movil al ordenador en modo de transferencia de archivos (Media Transfer Protocol).
Este paso depende enteramente de vestro móvil. Cuando conectas el móvil al ordenador dependiendo del fabricante y modelo pueden pasar varias cosas,
puede simplemente cargarse la batería, pueden instalarse drivers etc. El objetivo es que al conectarlo veamos en la sección de mi pc 
(donde aparecen los discos duros) la unidad correspondiente al móvil y que al clicarla se abra mostrando todas las carpetas internas.
Si alguna vez habéis movido archivos (por ejemplo fotos) entre el movil y el ordenador, es exactamente eso. Si no, lo más sencillo es buscar en google
"Transferencia archivos android 'Modelo del movil'"

3. Mover la build correspondiente (el Archivo .apk) a vuestro móvil, por ejemplo a la carpeta 'Downloads'

4. En vuestro móvil ir a la carpeta donde hubiéseis colocado el .apk y pulsarle, el cual debería instalar y abrir la app que ya quedaría 
en vuestro movil junto al resto de aplicaciones.


Guía para importar problemas:

1. Requisitos:
-Una herramienta para ver los archivos de applicación de Android. Lo mas fácil es tener instalado el Android Studio.
-Haber corrido la applicación al menos una vez.

2. Conectar el Movil al ordenador en modo de transferencia de archivos (Media Transfer Protocol).

3. Abrir el Android Studio. Ir a View>Tool Windows>Device File Explorer
Una explorador de archivos del móvil deberá haberse abierto.

4. Navegar hasta data>data>org.qtproject.example.ThinkingHat>files
Deberá haber un archivo llamado 'problemData.json' Le damos r-click>Open y debería aparecer el contenido. 
El archivo no puede editarse directamente sobre el móvil, lo que tenemos que hacer es crear en cualquier sitio de nuestro sistema operativo usando nuestro editor favorito un 
archivo llamado 'problemData.json' editarlo cuanto queramos (ver problemDataGuia.json) y finalmente sobre la carpeta data>data>org.qtproject.example.ThinkingHat>files del Device File Explorer hacer r-click>Upload
seleccionando el 'problemData.json' que hemos creado/editado en nuestro so. Esto pegará nuestro 'problemData.json' sobre el 'problemData.json' del móvil.

5. Desenganchar el movil. La app debería cargar ahora los problemas de nuestro 'problemData.json'.
