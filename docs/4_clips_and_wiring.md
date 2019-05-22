# Montaje y conexiones

# Requisitos
Todas las partes requeridas se encuentran aquí
![Partes requeridas](./images/clips_and_wiring_parts.jpg)

## Partes
*   1 Cuerpo de microscopio, con 3 ejes armados, un módulo óptico y la iluminación conectada.
*   2 [Tornillos M3x8mm con cabeza ](./parts/fixings/m3x8mm_caphead_screw.md)
*   [Muestras](./parts/printed/sample_clips.md)
*   [Raspberry Pi Zero W](./parts/electronics/raspberry_pi.md)

## Herramientas
*   llave allen de 2.5mm cabeza redondeada

# Instrucciones de construcción
## Paso 1
Conectá el cable LED al conector GPIO de la Raspberry Pi, a las líneas de 0v y 5v. Estos son los segundos y terceros pines de la parte superior del conector, en el borde exterior, pines número 4 y 6.

Enchufá la cámara al conector de la cámara como se describe en [Materiales de aprendizaje con raspberrypi ] (https://projects.raspberrypi.org/en/projects/getting-started-with-picamera) (el conector está al lado del puerto Ethernet , y los contactos en el cable están orientados hacia el puerto, es decir, están alejados de la pestaña del enchufe).
![Raspberry Pi GPIO pins](./images/LED_wiring.jpg)
![Raspberry Pi GPIO pins](./images/camera_wiring.jpg)

## Paso 2
Si estás utilizando un módulo de óptica alta, por ejemplo, Si estás utilizando un objetivo corregido del plan, es posible que deberías ajustar un [tubo ascendente de muestra](./parts/printed/sample_riser.md) entre el cuerpo del microscopio y el portaobjetos. Esto no es necesario si estás utilizando el módulo de óptica básica.

## Paso 3
Colocá el módulo óptico en el microscopio, se desliza desde la parte inferior como se muestra. El tornillo que sobresale del lado encaja en la ranura con forma de "ojo de cerradura" en el cuerpo del microscopio.
![Insertando el módulo de óptica](./images/insert_optics_module.jpg)

## Paso 4
Ajustá el tornillo para mantener el módulo óptico en su lugar. Puede alcanzar el tornillo con una llave hexagonal con extremo de bola, a través del orificio cerca del eje Z, como se muestra a continuación:
[Tighten the screw to secure the optics module](./images/screw_on_optics_module.jpg)

## Paso 5
Después de esto, solo quedan los clips de muestra para poner. El lugar exacto donde los coloque dependerá de las muestras que vayas a utilizar, pero en cualquier caso, simplemente presioná los tornillos M3 en los clips y luego en los orificios del porta objetos.
[](./images/sample_clips.jpg)

## Paso 6
El microscopio está completo!
Es posible que desee consultar la [documentación del módulo de cámara] (http://www.raspberrypi.org/documentation/usage/camera/) o [documentación de raspicam] (http://www.raspberrypi.org/documentation/usage/camera /raspicam/README.md) si necesitás una mano para configurar la cámara.
![](./images/microscope_complete_1.jpg)
![](./images/microscope_complete_2.jpg)
![](./images/microscope_complete_3.jpg)
![](./images/microscope_complete_4.jpg)
