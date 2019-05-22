# Imprimiendo las partes plásticas
Primero, deberás imprimir u obtener las piezas impresas en 3D. Se han diseñado con cierto cuidado para imprimir de manera confiable en la mayoría de las impresoras de estilo RepRap, sin material de soporte. Es importante leer las notas antes, ya que hay varias versiones de los archivos STL para elegir, por lo que no es una buena idea elegir todas las partes de la carpeta. Las partes impresas se describen en sus propias páginas, con detalles de cómo escoger la versión de esa parte, para las partes con múltiples versiones. Una lista completa de enlaces está en la parte inferior.

## Ajustes de Impresora 3D
Normalmente imprimo con un tamaño de capa de 0.24 mm en mi Ormerod, que toma 10 horas para el cuerpo principal. La "baja" calidad en un Ultimaker 2 (capas de 0.15 mm) produce resultados similares en aproximadamente 10 horas. Nuestra Prusa i3 Mk3 toma un tiempo similar usando capas de 0.2mm, o capas de 0.3mm si queremos ir aún más rápido (8 horas o menos).

>** Advertencia: ** El microscopio está diseñado para imprimir sin material de soporte. Si utilizás material de soporte, necesitarás una gran cantidad de limpieza y podrías dañar las piezas.

Todas las piezas están diseñadas para imprimir sin material de soporte o capa de adhesión. Si utilizás una capa de adherencia, muchas de las partes móviles se volverán inútiles con un borde (especialmente en el cuerpo principal), y requerirán mucho trabajo con una cuchilla manual para clasificarlas. Si bien no hay partes sueltas que realmente necesiten soporte, hay algunos salvatajes; Puede ser una buena idea imprimir primero el archivo `` just_leg_test.stl`` para asegurarse de que la impresora pueda imprimirlos. Hay algunas versiones del cuerpo principal que incluyen un borde horneado en el archivo STL, consulte [`` main_body.scad``] (../ openscad / main_body.scad). Esta ala hace un mejor trabajo de no ensuciar el mecanismo que la mayoría de los rebanadores, y es una buena opción si la pieza no se adhiere sin un borde. La mayoría de las otras partes se pueden limpiar después de imprimirlas con un ala, por lo que es posible que debas utilizar una, especialmente para las partes más pequeñas, como los clips de muestra.

Si su impresora tiene una cama de tamaño estándar (180 mm x 180 mm debería estar bien), entonces debería ser posible imprimir el microscopio completo de una sola vez. Hace esto si estás usando una máquina que está bien calibrada y es confiable. Sin embargo, yo encuentro que a menudo es más confiable imprimir en lotes (ya que las partes pequeñas en el borde de la cama de impresión pueden desprenderse y hacer que falle). Yo recomendaria:

* Lote 1: módulo de microscopio, iluminación y óptica (esta es la impresión más larga, con objetos más altos)
* Lote 2: Pies, engranajes, cubierta de cámara, agarrador de tablero de cámara, removedor de lente de cámara, elevador de engranaje

Hay un archivo de prueba que imprime una sola pata del microscopio: `` just_leg_test.stl``. Vale la pena imprimir esto primero para comprobar que la configuración sea correcta.

El módulo óptico necesita imprimir con algunos detalles finos, por lo que la cola de soprte se adapta muy bien al escenario. Una buena manera de asegurarse de esto es imprimirlo al mismo tiempo que otras partes, ya sea imprimir más de un módulo óptico a la vez o imprimirlo al mismo tiempo que el cuerpo del microscopio. Esto ralentiza el tiempo para cada capa, y significa que el plástico puede enfriarse más completamente antes de que se deposite la capa en la parte superior, lo que resulta en una pieza de mayor calidad. El módulo óptico se imprime mejor en negro para reducir la luz dispersa dentro del tubo, aunque aún funcionaría en otros colores.

## Estructuras estándar del microscopio.
La lista de partes a continuación es bastante extensa y trata de explicar todas las distintas opciones. Sin embargo, si solo querés crear una versión "normal" del microscopio, hay dos versiones que recomendaríamos:

### Microscopio basado en WebCam
La versión básica del microscopio usa una lente de cámara web en lugar de un objetivo de microscopio: aún se obtiene una etapa de traducción de muestra / enfoque realmente agradable, pero con opciones básicas. Esta versión es ideal para el uso de la escuela o los hobbies, tiene una resolución de aproximadamente 2um o mejor y es la más barata de construir. Esta es la versión que usualmente construimos en los talleres. Para cada microscopio, deberás imprimir una copia de cada uno de los siguientes archivos:

* `` actuator_assembly_tools.stl``
* `` picamera_2_gripper.stl``
* [opcional] `` picamera_2_lens_gripper.stl`` (solo es necesario si su cámara no viene con una herramienta para quitar la lente)
* `` main_body_LS65.stl``.
* `` feet.stl``
* `` gears.stl``
* `` illumination_dovetail.stl``
* `` condenser.stl``
* `` sample_clips.stl``
* `` camera_platform_picamera_2_LS65.stl``
* `` lens_spacer_picamera_2_pilens_LS65.stl``
* `` microscope_stand.stl`` (o `` back_foot.stl``)

Esto necesitará las tuercas, tornillos, etc. descritos a continuación, además de una computadora Raspberry Pi (cualquier modelo funcionará) y el módulo de la cámara Raspberry Pi. No se requieren otros bits ópticos, excepto un LED para la iluminación. Si desea montar la Raspberry Pi debajo del microscopio (nuestra opción preferida), imprima `` microscope_stand.stl`` en su lugar. Si su Raspberry Pi ya está en un estuche, debe imprimir `` back_foot.stl`` para que el microscopio quede plano sobre una mesa. Los módulos de cámara más nuevos incluyen una herramienta circular blanca para desenroscar la lente. Si no tiene uno, deberá imprimir la pinza de la lente (marcada como opcional).

### Microscopio De alta resolución
La versión del microscopio utilizado para la investigación científica o médica generalmente requiere una lente de objetivo convencional. La mayoría de las piezas son iguales, pero la óptica y el soporte de muestra son diferentes. Necesitará una copia de cada uno de los siguientes archivos:

* ``actuator_assembly_tools.stl``
* ``lens_tool.stl``
* ``picamera_2_gripper.stl``
* [optional] ``picamera_2_lens_gripper.stl`` (solo es necesario si tu cámara no viene con una herramienta para quitar la lente)
* ``main_body_LS65-M.stl``.
* ``feet.stl``
* ``gears.stl``
* ``illumination_dovetail.stl``
* ``condenser.stl``
* ``sample_clips.stl``
* ``optics_picamera_2_rms_f50d13_LS65.stl``
* ``microscope_stand.stl``
* ``sample_riser_LS10.stl`` (Suponiendo que tengas un objetivo de microscopio con una distancia parfocal de 45 mm)

** Para operación motorizada también necesitarás **
* ``small_gears.stl``
* ``motor_driver_case.stl``

Además, necesitarás:
* Un objetivo RMS roscado, con lentes finitas conjugadas. Estos se pueden obtener de, por ejemplo, AliExpress. Dependiendo de si es de 35 mm o 45 mm desde la "punta" de la lente a la muestra, puede que necesite o no la tarjeta vertical de muestra. Casi siempre usamos lentes corregidos de "plan" de 45 mm, que requieren el elevador.
* una lente acromática de longitud focal de 12,7 mm de diámetro y 50 mm, p. ej. ThorLabs ac127-050-a o equivalente genérico.
* una lente PMMA de 13 mm de diámetro y 5 mm de longitud focal para el condensador (se vende como lentes LED a granel)
* tres motores paso a paso 28BYJ-48 y un controlador [sangaboard] (https://github.com/rwb27/openflexure_nano_motor_controller/), u otro dispositivo electrónico adecuado.

## Partes Impresas
La mejor manera de obtener estos archivos es desde el último [lanzamiento] (https://gitlab.com/openflexure/openflexure-microscope/tags), o desde los archivos asociados con un compromiso en particular en GitLab.com.

**Plastic tools:**
* [herramientas de inserción de bandas y tuercas](./ parts / printed_tools / actuator_assembly_tools.md) `` actuator_assembly_tools.stl``
* [herramienta para insertar](./ parts / printed_tools / lens_tool.md) la lente de condensador de 13 mm de diámetro y / o la lente de tubo: `` lens_tool.stl``
* [plantilla para sujetar la placa de la cámara](./ parts / printed_tools / picamera_2_tools.md) mientras desenroscas la lente `` picamera_2_gripper.stl``
* [opcional] [herramienta para desenroscar la lente de la cámara](./ parts / printed_tools / picamera_2_tools.md) (solo es necesaria si su cámara no vino con una) `` picamera_2_lens_gripper.stl``

** Componentes: **
* [cuerpo del microscopio](./ parts / printed / main_body.md): `` main_body_ <tamaño del escenario> <helera> [-M] .stl``.
* 3 [pies](./partes/impresos /pies.md): `` feet.stl`` o `` feet_tall.stl`` (contiene los 3)
* 3 [engranajes grandes](./ parts / printed / gears.md): `` gears.stl`` (contiene los 3)
* iluminación:
 - [cola de milano vertical](./ parts / printed / illumination_dovetail.md): `` illumination_dovetail.stl``
 - [brazo del condensador](./ parts / printed / condenser.md): `` condenser.stl``
* 2 [clips de muestra](./ parts / printed / sample_clips.md): `` sample_clips.stl`` (contiene ambos)
* módulo de óptica(necesita una de las dos opciones a continuación):
 - estilo antiguo [módulo óptico](./ parts / printed / optics_module_casing.md) (una parte, mejor con objetivos RMS): `` optics_ <camera> _ <lens> _ <stage stage> <height> .stl` `
 - Módulo óptico de estilo plataforma (dos partes, mejor con lentes de webcam):
  * [plataforma de la cámara](./ parts / printed / camera_platform.md): `` camera_platform_ <camera> _ <tamaño del escenario> <height> .stl``
  * [espaciador de lente](./ parts / printed / lens_spacer.md): `` lens_spacer_ <camera> _ <lens> _ <stage_size> <height> .stl``
* [opcional] cubierta de la cámara: `` picamera_2_cover.stl``
* [opcional] 3 [engranajes pequeños](./ parts / printed / small_gears.md) para motores: `` small_gears.stl`` (contiene los 3)
* [opcional] [riser para la muestra](./ parts / printed / sample_riser.md): `` sample_riser_ <tamaño de etapa> <grosor> .stl``
* [opcional] soporte de diapositivas que funciona mejor si se usa aceite de inmersión: `` slide_riser_LS10.stl``
* [opcional] [base para contener una Raspberry Pi](./ parts / printed / microscope_stand.md): `` microscope_stand.stl``
* [opcional] [base para mantener el controlador del motor](./ parts / printed / motor_driver_case.md) (encaja debajo de la base que contiene la Pi): `` motor_driver_case.stl``
* [opcional] [pie trasero](./ parts / printed / back_foot.md), en caso de que no estés utilizando el soporte del microscopio: `` back_foot.stl``


En los nombres de archivo anteriores, donde hay varias versiones, los parámetros se incluyen entre paréntesis <>:
* `` <stage size> `` selecciona el tamaño de la plataforma, pero actualmente solo se admite `` LS``.
* `` <height> `` es la altura desde la parte inferior del cuerpo principal a la parte superior del escenario en mm, actualmente ya sea `` 65`` o `` 75``.
* Por lo general, los dos parámetros anteriores aparecen uno junto al otro, por lo que verás `` LS65``. Prácticamente yo solo uso `` 65`` como estándar, y si estoy usando un objetivo (que es la norma) agrego un elevador de 10 mm.
* `` <camera> `` es la cámara que está usando, ya sea `` picamera_2`` para el módulo de cámara Raspberry Pi v2, `` c270`` para Logitech C270, o `` m12`` para una cámara con una Montura de lente M12 a rosca.
* `` <lens> `` es la lente que estás utilizando, ya sea `` pilens``, `` c270_lens`` o `` m12_lens`` si está usando la lente que viene con su cámara. Para usar una lente objetiva de rosca RMS conjugada finita, tenes que especificar `` rms_f50d13`` (para una lente de tubo de 12,7 mm de diámetro focal, distancia focal de 50 mm, por ejemplo, ThorLabs ac127-050-a). También podes especificar `` rms_f40d16`` (para usar una lente de tubo Comar, longitud focal 40 mm, diámetro 16 mm) pero esto está obsoleto porque las imágenes no fueron tan buenas.
* `` <thickness> `` es el grosor de una plataforma, la cantidad que se agrega a la altura. Por lo general, se utiliza un elevador de 10 mm con un cuerpo de 65 mm para permitir el uso de un objetivo de distancia parfocal de 45 mm, actualmente solo se recomienda LS10.
Los bits opcionales de los nombres de archivo están entre corchetes arriba:
* `` -M`` en el nombre del cuerpo significa que tiene terminales de motor para permitir que se instalen los motores paso a paso 28BYJ-48
* `` _tall`` en la iluminación o en los pies significa que el cuerpo se sienta a 26 mm del suelo en lugar de 15 mm, para dejar espacio para los módulos de cámara más grandes. Esto solo es útil si no estás utilizando el soporte del microscopio.

Actualmente, hay dos versiones recomendadas del cuerpo; `` LS65`` y `` LS65-M``. La única diferencia es que la versión `` -M`` puede equiparse con motores. Para construir la versión de alta resolución del microscopio, use la columna de muestra de 10 mm de espesor `` sample_riser_LS10.stl``, y `` optics_picamera_2_rms_f50d13_LS65.stl``. Para compilar la versión de baja resolución, no use el riser de muestra, y en su lugar use `` camera_platform_picamera_2_LS65.stl`` y `` lens_spacer_picamera_2_pilens_LS65.stl``. En ambos casos, es mejor imprimir el soporte del microscopio y usar los pies de altura estándar.

## Limpieza de partes impresas
Si imprimiste las partes vos, comenzá abriendo los tres orificios en el cuerpo del microscopio con un taladro como se muestra. Asegurate de ir todo el camino a través. Si no tenes un taladro, podes improvisar atornillando completamente un tornillo M3, luego girándolo a la fuerza con un destornillador o con la tuerca suministrada. Además, quitá las cuerdas sueltas de plástico de la parte inferior de la etapa de la muestra, utilizando un par de alicates. El último paso no debería ser necesario si tu máquina está bien calibrada para "imprimir puentes".
![Opening out the holes for the actuators](./images/main_body_drill.jpg)

También hay vínculos entre la carcasa de la columna del actuador y la columna del actuador central que sujeta la tuerca de latón, que deben romperse, como se describe más adelante en las instrucciones. También puede haber ataduras cortas entre los dos pares de patas más delgadas y la "pared" que corre alrededor del microscopio, que también deben cortarse con un cuchillo. La estructura de "escalera" entre cada par de patas también está ahí solo para soporte durante la impresión; no hace daño dejarla en su lugar, pero si cortás los "peldaños", permitirá que la plataforma se mueva un poco más libremente.

Una vez que tenga sus piezas impresas, puede comenzar [ensamblando los actuadores](./ 1_actuator_assembly.md).
