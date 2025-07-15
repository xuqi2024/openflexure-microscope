# 打印塑料零件

首先，您需要打印或获取3D打印零件。这些零件经过精心设计，可以在大多数RepRap风格的打印机上可靠打印，使用常规PLA线材且无需支撑材料。重要的是要先阅读说明，因为有多个版本的STL文件可供选择，所以只是选择文件夹中的所有零件并不是一个好主意。打印零件在各自的页面中描述，对于有多个版本的零件，详细说明了如何选择该零件的版本。

获取这些文件的最佳方式是从[显微镜STL配置器]页面。

[显微镜STL配置器]: https://microscope-stls.openflexure.org

## 显微镜的标准构建

如果您只想构建标准版本的显微镜，请检查并打印"基于网络摄像头的显微镜"或"高分辨率显微镜"部分中的文件。如果您要定制显微镜，本页底部有所有可用零件的更广泛列表。

### 基于网络摄像头的显微镜

显微镜的基础版本使用网络摄像头镜头而不是显微镜物镜 - 您仍然可以获得非常好的对焦/样品平移载物台，但使用基础选项。这个版本非常适合学校或业余使用，分辨率约为2微米或更好，是最便宜的构建方案。这是我们通常在研讨会上构建的版本。对于每台显微镜，您需要打印以下每个文件的一份：

**塑料工具：**

* [弹性带和螺母插入工具，带弹性带工具架](./parts/printed_tools/actuator_assembly_tools.md) `actuator_assembly_tools.stl`
* [可选] `picamera_2_lens_gripper.stl`（仅在您的相机没有附带移除镜头工具时需要）

**组件：**

* [显微镜本体](./parts/printed/main_body.md)：`main_body_LS65-M.stl` 或 `main_body_LS65-M_brim.stl`。
* 3个[支脚](./parts/printed/feet.md)：`feet.stl` 或 `feet_tall.stl`（包含全部3个）
* 3个[大齿轮](./parts/printed/gears.md)：`gears.stl`（包含全部3个）
* 照明系统：
  * [垂直燕尾槽](./parts/printed/illumination_dovetail.md)：`illumination_dovetail.stl`
  * [聚光镜臂](./parts/printed/condenser.md)：`condenser.stl`
* 2个[样品夹具](./parts/printed/sample_clips.md)：`sample_clips.stl`（包含两个）
* 平台式光学模块（两部分，最适合网络摄像头镜头）：
  * [相机平台](./parts/printed/camera_platform.md)：`camera_platform_<camera>_<stage size><height>.stl`
  * [镜头间隔器](./parts/printed/lens_spacer.md)：`lens_spacer_<camera>_<lens>_<stage_size><height>.stl` - **用黑色材料打印！**
* [显微镜支架](./parts/printed/microscope_stand.md)或后支脚
  * `microscope_stand_no_pi_.stl` 或 `microscope_stand-30.stl`（容纳树莓派）或 `back_foot.stl`

这需要[材料清单页面](./0_bill_of_materials_zh.md)中描述的螺母、螺栓等，加上一个相机模块（例如树莓派相机），以及可选的树莓派。除了用于照明的LED外，不需要其他光学器件。

如果您想在显微镜下面安装树莓派（我们的首选选项），请打印`microscope_stand.stl`。如果您的树莓派已经装在外壳中，您应该打印`back_foot.stl`，这样显微镜就能平放在桌子上。较新的树莓派相机模块包含一个白色圆形工具用于拧下镜头。如果您没有，您需要打印镜头夹具（标记为可选）。

### 高分辨率显微镜

用于科学或医学研究的显微镜版本通常需要传统的物镜镜头。大部分零件是相同的，但光学系统和样品安装是不同的。您需要以下每个文件的一份：

**塑料工具：**

* [弹性带和螺母插入工具，带弹性带工具架](./parts/printed_tools/actuator_assembly_tools.md) `actuator_assembly_tools.stl`
* [插入工具](./parts/printed_tools/lens_tool.md)用于13mm直径聚光镜和/或管镜：`lens_tool.stl`
* [可选] `picamera_2_lens_gripper.stl`（仅在您的相机没有附带移除镜头工具时需要）

**组件：**

* [显微镜本体](./parts/printed/main_body.md)（兼容分光镜）：`main_body_LS65-M-BS.stl` 或 `main_body_LS65-M-BS_brim.stl`。
* 3个[支脚](./parts/printed/feet.md)：`feet.stl` 或 `feet_tall.stl`（包含全部3个）
* 3个[大齿轮](./parts/printed/gears.md)：`gears.stl`（包含全部3个）
* 照明系统：
  * [垂直燕尾槽](./parts/printed/illumination_dovetail.md)：`illumination_dovetail.stl`
  * [聚光镜臂](./parts/printed/condenser.md)：`condenser.stl`
* 2个[样品夹具](./parts/printed/sample_clips.md)：`sample_clips.stl`（包含两个）
* [光学模块](./parts/printed/optics_module_casing.md)：
  * `optics_picamera_2_rms_f50d13.stl`（透射照明）**用黑色材料打印！**
  * `optics_picamera_2_rms_f50d13_beamsplitter.stl`（反射照明）**用黑色材料打印！**
* [显微镜支架](./parts/printed/microscope_stand.md)：`microscope_stand-30.stl` 或 `microscope_stand-30-BS.stl`（支持反射照明）
* [样品升高器](./parts/printed/sample_riser.md)：`sample_riser_LS10.stl`（假设您有45mm齐焦距离的显微镜物镜）

**对于电机化操作，您还需要：**

* 3个[小齿轮](./parts/printed/small_gears.md)用于电机：`small_gears.stl`（包含全部3个）
* [容纳电机驱动器的底座](./parts/printed/motor_driver_case.md)（安装在容纳树莓派的底座下面）：`motor_driver_case.stl`

**对于反射照明，您还需要：**

* [滤光立方体](./parts/printed/fl_cube.md)：`fl_cube.stl`
* [反射照明器](./parts/printed/reflection_illuminator.md)：`reflection_illuminator.stl`

**另外，您需要：**

* 一个RMS螺纹、有限共轭[物镜镜头](parts/optics/objective.md)。这些可以从阿里巴巴等地获得。根据从镜头的"肩部"到样品是35mm还是45mm，您可能需要也可能不需要样品升高器。我们几乎总是使用45mm"平场"校正镜头，确实需要升高器。
* 一个12.7mm直径、50mm焦距[消色差透镜](parts/optics/tube_lens.md)，例如ThorLabs ac127-050-a或通用等效产品。
* 一个13mm直径、5mm焦距PMMA平凸透镜用于[聚光镜](parts/optics/condenser_lens.md)（作为LED透镜批量销售）
* [电机](./parts/electronics/stepper_motors.md)和[电机驱动电子设备](6_motor_controllers_zh.md)

## 打印设置

我通常使用PLA线材打印，层高0.2mm，在Prusa i3 MK3或Ultimaker 2+上打印，主体需要10小时。Ultimaker 2上的"低"质量（0.15mm层）在大约12小时内产生类似的结果。如果我们想要更快（8小时或更少），有时在Prusa上使用0.3mm层 - 这在Ultimaker上不可靠。您应该能够使用几乎任何熔融长丝制造打印机（即任何使用PLA线材的打印机）。

> **警告：** 显微镜设计为无支撑材料打印。如果您使用支撑材料，它将需要大量清理，并且您很可能损坏零件。

主体设计为无支撑材料或粘附层打印。如果您确实使用粘附层，许多移动部件可能因主体上的边缘而变得无用。可以用工艺刀去除边缘，但在这样做时很容易损坏机制。请参阅下面我们的"智能边缘"，它应该更好地粘附到打印床，同时也更容易去除。这种边缘比大多数切片器更好地不妨碍机制，如果零件没有边缘就不会粘附，这是一个好选项 - 请参阅下一节。对于大多数其他零件，打印后可以清理边缘，所以您可能希望使用边缘，特别是对于像样品夹具这样的较小零件。

没有真正需要支撑的悬臂零件，但有一些桥接；最好先打印`just_leg_test.stl`文件，以确保您的打印机可以打印它们。使用支撑材料可能是一个问题，因为它会出现在难以去除的地方，您在去除时很可能损坏机制。

如果您的打印机有标准尺寸的床（180mmx180mm应该可以），那么应该可以一次性打印完整的显微镜，除了容纳电子设备的底座。如果我使用的是校准良好且可靠的机器，我会这样做。但是，我发现分批打印通常更可靠（因为打印床边缘的小零件可能会脱离并导致失败）。如果我需要使用边缘，我们通常使用"智能边缘"单独打印主体，并在单独的运行中打印其他小零件。我建议：

有一个测试文件打印显微镜的单个支腿 - `just_leg_test.stl`。首先打印这个来检查您的设置是否正常是值得的。

光学模块需要打印一些精细细节，这样燕尾槽能很好地与载物台啮合。确保这一点的好方法是与其他零件同时打印 - 要么一次打印多个光学模块，要么与显微镜本体同时打印。这会减慢每层的时间，意味着塑料在上层沉积之前可以更完全地冷却，从而产生更高质量的零件。光学模块最好用黑色打印，以减少管内的杂散光 - 尽管其他颜色也能工作。

## 智能边缘

对于大多数打印零件，您的打印机的切片程序将能够自动为打印添加合适的边缘以改善粘附。例外是主体，自动边缘可能会填充样品移动所需的间隙。

这个智能边缘自动确定适合添加边缘的区域，并将边缘添加到STL文件中。由于边缘是STL的一部分，去除并不总是容易的。智能边缘边缘不是简单地延伸最低层，而是与正在打印的零件边缘平行打印的单独部分，使清理变得更容易。

有时切片器会自动组合边缘和零件。您可以在切片后通过预览最低层在切片软件中检查这种情况是否发生；智能边缘的边缘应该如下所示平行出现（零件和边缘的边缘以橙色显示）。

![智能边缘的边缘平行于打印零件的边缘](./images/smart_brim_1.jpg)

无论您的打印机如何，在打印显微镜时不要尝试在切片器中添加进一步的边缘。下面列出了不同切片器中智能边缘所需的一些示例切片器设置。

*   **Ultimaker Cura**

Cura（v4.4）自动将智能边缘切片得适合打印。

*   **PrusaSlicer**

如下所示，在PrusaSlicer（v2.1.1）中不更改默认设置，智能边缘将作为显微镜底座的延伸打印。

![智能边缘被错误地打印为底座的实体延伸](./images/smart_brim_prusa_1.jpg)

这可以在PrusaSlicer的"专家"选项卡中纠正。右键单击需要智能边缘的零件，打开添加设置 > 高级菜单。选中"切片间隙闭合半径"框并单击确定。

![如何打开高级设置菜单](./images/smart_brim_prusa_2.jpg)

![要更改的设置](./images/smart_brim_prusa_3.jpg)

这将打开切片间隙闭合半径选项，应设置为0.001毫米。这将添加重新切片模型的选项，现在将按要求打印边缘。

![更改闭合半径后，如图所示重新切片模型](./images/smart_brim_prusa_4.jpg)

![更改Prusa设置后边缘现在正确打印](./images/smart_brim_1.jpg)

## 打印零件的清理

如果您自己打印零件，请先用钻头钻开显微镜本体中的三个孔，如图所示。确保完全钻通。如果您没有钻头，可以通过将M3螺钉一直拧入，然后用螺丝刀或提供的螺母强行旋转来即兴处理。另外，使用钳子从样品载物台下侧移除任何松散的塑料丝。如果您的机器校准良好用于打印桥接，最后一步应该不是必需的。

![钻开致动器的孔](./images/main_body_drill.jpg)

致动器柱外壳和容纳黄铜螺母的中央致动器柱之间也有连接 - 这些需要断开，如后面的说明中所述。两对较薄支腿和显微镜周围的"墙"之间也可能有短连接 - 这些也应该用刀断开。每对支腿之间的"梯子"状结构也只是为了在打印期间提供支撑 - 将其留在原地没有害处，但如果您切掉"横档"，将允许载物台移动得更自由一些。

一旦您有了打印零件，您可以开始[组装致动器](./1_actuator_assembly_zh.md)。

## 定制显微镜的额外细节

如果您正在构建上面列出的两个标准构建之一，您可以安全地忽略此部分。如果您正在构建定制版本并需要了解所有选项，请继续阅读。

**塑料工具：**
* [弹性带和螺母插入工具，带弹性带工具架](./parts/printed_tools/actuator_assembly_tools.md) `actuator_assembly_tools.stl`
* [插入工具](./parts/printed_tools/lens_tool.md)用于13mm直径聚光镜和/或管镜：`lens_tool.stl`
* [夹具固定相机板](./parts/printed_tools/picamera_2_tools.md)当您拧下镜头时：`picamera_2_gripper.stl`
* [可选] [拧下相机镜头的工具](./parts/printed_tools/picamera_2_tools.md)（仅在您的相机没有附带时需要）`picamera_2_lens_gripper.stl`

**组件：**
* [显微镜本体](./parts/printed/main_body.md)：`main_body_<stage size><height>[-M].stl`。
* 3个[支脚](./parts/printed/feet.md)：`feet.stl` 或 `feet_tall.stl`（包含全部3个）
* 3个[大齿轮](./parts/printed/gears.md)：`gears.stl`（包含全部3个）
* 照明：
 - [垂直燕尾槽](./parts/printed/illumination_dovetail.md)：`illumination_dovetail.stl`
 - [聚光镜臂](./parts/printed/condenser.md)：`condenser.stl`
* 2个[样品夹具](./parts/printed/sample_clips.md)：`sample_clips.stl`（包含两个）
* 光学模块（您需要以下两个选项之一）：
 - 老式[光学模块](./parts/printed/optics_module_casing.md)（一部分，最适合RMS物镜）：`optics_<camera>_<lens>_<stage size><height>.stl`
 - 平台式光学模块（两部分，最适合网络摄像头镜头）：
  * [相机平台](./parts/printed/camera_platform.md)：`camera_platform_<camera>_<stage size><height>.stl`
  * [镜头间隔器](./parts/printed/lens_spacer.md)：`lens_spacer_<camera>_<lens>_<stage_size><height>.stl`
* [可选] 相机罩：`picamera_2_cover.stl`
* [可选] 3个[小齿轮](./parts/printed/small_gears.md)用于电机：`small_gears.stl`（包含全部3个）
* [可选] [样品升高器](./parts/printed/sample_riser.md)：`sample_riser_<stage size><thickness>.stl`
* [可选] 如果使用浸没油效果更好的载玻片架：`slide_riser_LS10.stl`
* [可选] [容纳树莓派的底座](./parts/printed/microscope_stand.md)：`microscope_stand.stl`
* [可选] [容纳电机驱动器的底座](./parts/printed/motor_driver_case.md)（安装在容纳树莓派的底座下面）：`motor_driver_case.stl`
* [可选] [后支脚](./parts/printed/back_foot.md)，以防您不使用显微镜支架：`back_foot.stl`

在上面的文件名中，有多个版本的地方，参数包含在尖括号中：
* `<stage size>` 选择平台的尺寸 - 但目前只支持 `LS`。
* `<height>` 是从主体底部到载物台顶部的高度（mm），目前是 `65` 或 `75`。
* 通常上述两个参数出现在一起，所以您会看到 `LS65`。我几乎只使用 `65` 作为标准，如果我使用物镜（这是常态），我会添加10mm升高器。
* `<camera>` 是您使用的相机，对于树莓派相机模块v2是 `picamera_2`，对于罗技C270是 `c270`，对于带螺旋M12镜头安装的相机是 `m12`。
* `<lens>` 是您使用的镜头，如果您使用相机附带的镜头，则是 `pilens`、`c270_lens` 或 `m12_lens`。要使用有限共轭、RMS螺纹物镜镜头，您应该指定 `rms_f50d13`（对于50mm焦距、12.7mm直径管镜，例如ThorLabs ac127-050-a）。您也可以指定 `rms_f40d16`（使用Comar管镜，焦距40mm，直径16mm），但这已被弃用，因为图像不如前者好。
* `<thickness>` 是载物台升高器的厚度 - 它增加的高度量。通常10mm升高器与65mm本体一起使用，以允许使用45mm齐焦距离物镜，目前只推荐LS10。

上面方括号中的可选文件名部分：
* 本体名称中的 `-M` 表示它有电机凸耳，允许安装28BYJ-48步进电机
* 照明或支脚上的 `_tall` 表示本体离地面26mm而不是15mm，为更大的相机模块提供间隙。这只有在您不使用显微镜支架时才有用。

目前，有两个推荐的本体版本；`LS65` 和 `LS65-M`。唯一的区别是 `-M` 版本可以安装电机。要构建高分辨率版本的显微镜，使用10mm厚的样品升高器 `sample_riser_LS10.stl` 和 `optics_picamera_2_rms_f50d13_LS65.stl`。要构建低分辨率版本，不要使用样品升高器，而是使用 `camera_platform_picamera_2_LS65.stl` 和 `lens_spacer_picamera_2_pilens_LS65.stl`。在这两种情况下，最好打印显微镜支架，并使用标准高度支脚。

**可打印弹性带**
如果您无法获得氟橡胶O型圈，一个可能的替代方案是使用柔性TPU线材打印一些O型圈。用于此目的的STL文件是 `actuator_tension_band.stl`。更多细节在[O型圈零件页面](./parts/fixings/viton_o_ring_30mm_inner_diameter_2mm_cross_section.md)中给出。
