# Ensamble del motor
El microscopio OpenFlexure puede ser motorizado, para permitir ejecutar experimentos automatizados. Para hacer esto, deberá ajustar los motores paso a paso a los ejes X, Y y Z.

# Requisitos
Necesitará las partes que se muestran en la siguiente imagen:
![Parts required for this step](./images/motors_parts.jpg)

## Partes
* 1 Microscopio, con actuadores ya montados.
* [Pequeños engranajes impresos](./ parts / printed / small_gears.md)
* 3 [28BYJ-48 micro motores paso a paso reductores](./ parts / electronics / stepper_motors.md)
* 6 [Tornillos de cabeza de botón M4x6mm](./ parts / fixings / m4x6mm_buttonhead_screw.md)
* 1 [Caja de la placa del motor](./ parts / printed / motor_driver_case.md)
* 1 [Placa de controlador de motor](./ parts / electronics / motor_driver.md)
* 1 cable mini USB corto
* 2 pequeños sujetacables

## Herramientas
* 1 llave allen de 2,5 mm
* Cinta aislante de 3cm.


# Instrucciones para construcción
## Paso 1
Primero, colocá los engranajes en los motores. Los engranajes están impresos con un fondo circular; colocalos sobre la mesa, con el lado circular hacia abajo. Deben quedar ajustados al eje del motor; si no lo están, ponele un poquito de cinta aislante, con el lado pegado hacia arriba, encima del engranaje, como se muestra.

![Motor y engranaje, terminados](./images/motors_tape.jpg)

## Paso 2
Ahora, colocá el engranaje (y la cinta) en el eje del motor; con el engranaje en la mesa, presioná el eje en el orificio. NB: debe alinear los lados planos del eje con el orificio, no es circular.

![Motor con eje completo](./images/motors_gear.jpg)

## Paso 3
Repetí los pasos 1 y 2 para los tres motores.

## Paso 4
Ajustá cada uno de los tres motores en el cuerpo del microscopio con dos tornillos M4. Es posible que este paso sea más fácil si ajustás primero los orificios en el cuerpo del microscopio. Los tornillos deben estar bien ajustados, de lo contrario el motor se tambaleará.

![Motor ajustado en el cuerpo del microscopio](./images/motors_mount.jpg)

## Paso 5
Ajuste el cable mini USB a la placa del motor y coloque la placa del motor en la caja como se muestra.

![La placa del motor, en su caja](./images/motors_board_in_base.jpg)

## Paso 6
Conecte los cables de los motores a la placa del motor como se muestra.

![Motores conectados al controlador](./images/motors_wiring.jpg)

## Paso 7
Finalmente, colocá el microscopio en la parte superior de la caja del tablero del motor y ordená el cableado utilizando las precintos. Puede fijar de forma más segura la placa del motor al microscopio con tornillos M3 en las esquinas, pero es posible que tengas que esperar hasta que lo haya probado en caso de que necesite cambiar el cableado.
![El Microscopio completo con los motores](./images/motors_assembled.jpg)

## Paso 8
Muy bien!!! Colocaste los motores. Ahora hay que cargar el firmware del controlador del motor utilizando el IDE de Arduino. Actualmente, el [firmware reside en github] (https://github.com/rwb27/openflexure_nano_motor_controller).
