# Construyendo la ilumnación
El microscopio generalmente funciona al observar la luz que ha pasado a través de la muestra, por lo que necesitamos iluminar la muestra desde arriba. Esta sección facilita el ensamblaje del brazo de iluminación.

# Requimientos
## Partes
*   1 [Pieza de ilumiación](./parts/printed/illumination_dovetail.md)
*   1 [brazo unidor](./parts/printed/condenser.md)
*   1 [5mm LED](./parts/electronics/white_led.md) Idelamente, uno Blanco de alta luminosidad
*   2 [Tornillos de cabeza hueca M3x8](./parts/fixings/m3x8mm_caphead_screw.md)
*   2 [Arandelas M3](./parts/fixings/m3_washer.md)
*   1 [Lentes para el unidor](./parts/optics/condenser_lens.md) (opcional)

## Herramientas
* llave allen de 2.5mm
* [Herramienta para unidor de Lentes](./parts/printed_tools/lens_tool.md) (Si se está usando..)

# Instrucciones De construcción
## Paso 1
Para construir el condensador, necesitaras las dos partes del brazo de montaje, dos tornillos M3 y arandelas, el LED y el cable. Si estás utilizando una lente de condensador, también necesitarás la herramienta de inserción de lente impresa para colocar la lente en el soporte.

## Paso 2
*Esto es un paso opcional. Si estás usando el unidor de lentes, pasá al paso 3*
Colocá la lente del unidor en la herramienta de inserción (con el lado plano hacia abajo) y presioná la carcasa del brazo unidor hacia abajo. Tenga cuidado de mantenerlo vertical. Es posible que tengas que presionar bastante fuerte. Al igual que con la lente de tubo en el módulo óptico, verificá que esté plana y empujá nuevamente si es necesario.
![El brazo unidor](./images/insert_condenser.jpg)
![](./images/condenser_lens_1.jpg)
![](./images/condenser_lens_2.jpg)

## Paso 3
Inserte el LED en la carcasa del condensador. Debe ajustarse y mantenerse en su lugar. Puede pegarse o pegarse si no se queda.
[](./images/insert_led.jpg)

## Paso 4
Armá el cable para el LED, si aún no tenés uno soldado. Solo necesitás poder encenderlo. Por lo general, lo hacés soldando el LED a una resistencia (aproximadamente 80 ohm), y luego conectamos aproximadamente 20 cm de cable con rizos hembra en el extremo. Esto se puede conectar fácilmente al pin GPIO de 5 v de Raspberry Pi.

## Paso 5
Colocá la cola de iluminación en la plataforma del cuerpo del microscopio y asegúrela en su lugar con los dos tornillos M3. Usá una arandela entre el tornillo y la cola de iluminación. Los orificios en el microscopio deben ser del tamaño correcto para el tornillo M3, pero es posible que tengas que usar un poco de fuerza para colocar los tornillos. Tené cuidado de dejar de girar los tornillos tan pronto como la cola de iluminacíon esté bien montada, de lo contrario podrías dañar los hilos.

![Montando la plataforma de iluminación](./images/mount_illumination_dovetail.jpg)

## Paso 6
Enganchá la parte horizontal del brazo unidor en la cola de soporte vertical.
![Conectando el brazo ](./images/slide_on_condenser.jpg)

## Paso 7
Pasá cuidadosamente el cable para el LED a través de la brecha entre el condensador y la cola del soporte vertical, y luego colocalo junto al módulo de óptica en la parte inferior del microscopio. No lo pase a través del orificio en el centro del escenario plano, páselo entre el escenario y la cola de milano.

## Paso 8
Montaste la iluminación, bien ahí.
