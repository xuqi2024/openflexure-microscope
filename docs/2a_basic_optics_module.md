# Módulo de Óptica básico
La opción más simple para la óptica del microscopio es usar una lente de una webcam. Este es un viejo truco de los fotógrafos, donde una lente de gran angular se gira hacia atrás y se usa como una lente macro, por lo que el lado que habría apuntado al sensor de la cámara ahora apunta a la muestra. Debido a que las webcam tienen píxeles muy pequeños, usar una webcam en reversa es un buen objetivo de microscopio. Esta versión del módulo óptico convierte a la cámara de la Raspberry Pi en un microscopio con un campo de visión de aproximadamente 400um y una resolución de aproximadamente 2um.

# Requisitos
Necesitarás las partes descritas aquí
![Partes requeridas](./images/basic_optics_module_parts.jpg)

## Parts
*   1 [Plataforma de camara](./parts/printed/camera_platform.md)
*   1 [Tubo extensor de lente](./parts/printed/lens_spacer.md)
*   1 [Modulo de cámara raspberry pi](./parts/electronics/raspberry_pi_camera.md) (idealmente v2, aunque v1 también debería funcionar): puede sustituir una cámara web de 6 LED por una solución aún más económica.
*   1 [Tuerca de acero M3 ](./parts/fixings/m3_steel_nut.md)
*   1 [Tornillo M3x10mm con cabeza](./parts/fixings/m3x8mm_caphead_screw.md)
*   2 [Tornillos M2x6mm con cabeza](./parts/fixings/m2x6mm_caphead_screw.md)

## Herramientas requeridas
*   1 llave allen de 2.5mm
*   1 llave allen de 1.5mm
*   1 bisturí o cuchillo artesanal (opcional)
*   1 Herramienta de extracción de lentes (Opcional para imprimir)
*   1 printed [board gripper](./parts/printed_tools/picamera_2_tools.md)

# Instrucciones de Ensamblaje
## Paso 1
Primero, tene a mano todas las herramientas y piezas necesarias: las piezas de plástico del módulo óptico (el espaciador de la lente y la plataforma de la cámara), el módulo de la cámara de Raspberry Pi, las herramientas para quitar la lente de la cámara, dos tornillos M2 para asegurar la cámara. Dependiendo de la calidad de impresión, es posible que también necesite una cuchilla afilada o algo de cinta.
 
NOTA: las herramientas de extracción de la lente, la pinza de la placa y el módulo óptico son específicos de la cámara que está utilizando. Esta versión de las instrucciones es para la versión 2 de la placa de la cámara, la versión 1 del módulo de la cámara de Rasbperry Pi también funcionará, pero tendrá que quitar la lente con pinzas u otra cosa. La versión 2 del módulo de la cámara se envía con una herramienta de extracción de lentes incluida, que es un disco blanco de plástico con un orificio en el centro. Esto es mejor que la herramienta de eliminación de lentes impresas, si está disponible.

Si estás utilizando la cámara web USB de 6 LED (aproximadamente £ 3 en eBay o AliExpress), deberás saltarte algunos de estos pasos y también desmontar la carcasa de plástico para extraer la placa de circuito de la cámara. Simplemente podes desenroscar la lente de la cámara web y pegarla con cinta adhesiva o pegarla al revés, que estría fijada en la placa del circuito. Hay una plataforma de cámara STL para la cámara de 6 LED en la compilación, en este caso, sustituila por la parte de la plataforma de la cámara de Raspberry Pi.

## Paso 2
Necesitamos quitar la lente de la cámara. Para hacer esto, necesitás las dos herramientas de plástico (la pinza de la placa y el removedor de lentes) así como el módulo de la cámara. Es mejor asegurarse de haber completado los pasos hasta este punto antes de retirar la lente, para minimizar la cantidad de tiempo que el sensor está expuesto al aire y al polvo.

> **Advertencia!!** La placa de la cámara es sensible a la estática. Tomá las precauciones antiestáticas habituales (idealmente usá una pulsera antiestática conectada a tierra, pero al menos asegúrese de tocar un objeto con conexión a tierra, como un tubo de metal, antes de trabajar con el módulo de la cámara).

## Paso 3
Remover el film protector de la lente

![Quitando el film protector de la lente](./images/picam2_film_removal.jpg)

## Paso 4
Hay un pequeño cable de cinta que conecta la cámara al PCB que es muy fácil de romper. Hay una plantilla de plástico cuadrada que se coloca sobre la cámara y el PCB (la "pinza de la placa de la cámara"), que impide que la cámara se retuerza y dañe el cable de cinta. Ajustá esto sobre la cámara como se muestra. Tené en cuenta que la parte para la versión v2 de la placa de la cámara encajará en cierto modo en la versión v1, pero tenes que ser un poco más cuidadoso, ya que no es el ajuste perfecto.

![Grip de la placa](./images/picam2_board_gripper_1.jpg)
![Tomá la cámara para evitar daños en el cable](./images/picam2_board_gripper_2.jpg)

## Paso 5
A continuación, desenroscá la lente del módulo de la cámara. Utilizá la herramienta de plástico para agarrar el módulo de la lente. Esta es una pequeña parte circular con cuatro puntas que se ajustan a la lente de la placa de la cámara (solo en la versión 2) como se muestra. Para retirar la lente, empujá la herramienta de extracción sobre la lente (solo la parte superior, con las pequeñas bridas de plástico) y girala en sentido antihorario para retirarla.
 
La herramienta impresa solo funciona si las puntas apuntan en sentido contrario a las agujas del reloj, así que asegurate de que sea la forma correcta. Es importante usar la pinza para sujetar el chip de la cámara en su lugar y evitar dañar el delicado cable. Después de haber quitado la lente, comprobá que el cable de cinta negro o naranja que conecta el módulo de la cámara (el cuadrado negro de plástico del que desenroscó la lente) todavía está conectado al PCB. Volvé a insertarlo empujándolo con un dedo si es necesario.

Una vez que hayas retirado la lente, asegurate de colocar la cámara boca abajo sobre el escritorio, o coloque un trozo de cinta sobre el soporte cuadrado negro para lentes; Esto ayudará a evitar que el polvo se acumule en el sensor, que es extremadamente difícil de limpiar.
![Remover la lente](./images/picam2_lens_removal.jpg)

## Paso 6
Antes de ensamblar las piezas en el soporte, asegurate de que esté libre de polvo soplando un poco de aire a través de él, y verifique que no haya cuerdas de plástico en el orificio central a través del soporte.

## Paso 7
A continuación, colocá la lente en el tubo de extensión de plástico. La lente debe entrar con el lado que estaba al lado del sensor de la cámara en la parte superior, y el lado que estaba mirando hacia afuera (el que tiene un pequeño orificio en el plástico negro) hacia el tubo de extensión. Esto solo debería ajustarse a presión, pero puede requerir un poco de fuerza o requerir una capa de cinta alrededor de la lente para que se ajuste bien (según la impresora). Si envolvés la cinta alrededor de la lente, cortá cualquier cinta que sobresalga sobre la lente con un bisturí o una cuchilla afilada.

![La Lente en el tubo de extensión](./images/insert_camera_lens.jpg)
![](./images/lens_insertion_2.jpg)
![](./images/lens_insertion_3.jpg)

## Paso 8
Colocá el tubo de extensión en la placa de la cámara, luego colocá la placa de la cámara y el tubo de extensión en la plataforma de la cámara. Atornillalo en su lugar con dos tornillos M2, que pasan a través del tubo de extensión y la placa de la cámara, y en la plataforma. Podrías usar dos tornillos M2 más, si están disponibles, para fortalecer más la unión.

![](./images/mount_to_camera_platform.jpg)

## Paso 9
Deslizá una tuerca en la "trampa" de la tuerca en el lado de la plataforma de la cámara. Probablemente esto no necesite una herramienta, pero podrías usar una llave hexagonal de 2.5 mm para empujarla.

![](./images/slide_in_nut_camera_platform.jpg)

## Paso 10
Atornilla el tornillo M3 en la tuerca, así se pega en la plataforma de la cámara...
![](./images/camera_platform_mounting_screw.jpg)

## Paso 11
Felicitaciones, armaste el módulo óptico!
