stl_presets = [
    {
        "key": "high_resolution_raspberry_pi",
        "title": "High Resolution with Raspberry Pi",
        "description": "A microscope using the Raspberry Pi camera and  high resolution optics, as used for medical work.",
        "parameters": {
            "optics": "rms_f50d13",
            "camera": "picamera_2",
            "reflection_illumination": False,
            "motorised": True,
            "pi_in_base": True,
            "tall_bucket_base": False,
            "slide_riser": False,
        },
    },
    {
        "key": "basic_raspberry_pi",
        "title": "Basic with Raspberry Pi",
        "description": "A basic microscope using the Raspberry Pi camera and simple optics. Best suited for low resolution microscopy and educational workshops.",
        "parameters": {
            "optics": "pilens",
            "camera": "picamera_2",
            "motorised": False,
            "pi_in_base": True,
            "tall_bucket_base": False,
            "slide_riser": False,
        },
    },
    {
        "key": "low_cost_webcam",
        "title": "Low Cost with Webcam",
        "description": "The cheapest possible option using a computer webcam.",
        "parameters": {
            "optics": "6ledcam_lens",
            "camera": "6ledcam",
            "motorised": False,
            "pi_in_base": False,
            "slide_riser": False,
        },
    },
]

#TODO: Stop commenting out options and just put in a flag
option_docs = [
    {
        "key": "optics",
        "default": "rms_f50d13",
        "description": "The type of lens you'd like to use on your microscope.",
        "options": [
            {
                "key": "rms_f50d13",
                "title": "RMS Objective and f50d13 lens",
                "description": "An RMS-threaded microscope objective with 160mm tube length, and a 12.7mm diameter, 50mm focal length achromatic doublet lens.",
            },
            {
                "key": "rms_infinity_f50d13",
                "title": "RMS Infinity Objective and f50d13 lens",
                "description": "An RMS-threaded, infinity-corrected microscope objective with a 12.7mm diameter, 50mm focal length achromatic doublet lens.",
            },
            {
                "key": "pilens",
                "title": "Pi Lens",
                "description": "The lens included with the Raspberry Pi camera module, v1 or v2 (either will fit)",
            },
            #{
            #    "key": "c270_lens",
            #    "title": "C270 Lens",
            #    "description": "The lens included with the Logitech C270 webcam",
            #},
            #{
            #    "key": "m12_lens",
            #    "title": "M12 Lens",
            #    "description": "A typical M12 CCTV lens",
            #},
            {
                "key": "6ledcam_lens",
                "title": "6LED Camera Lens",
                "description": "The lens that comes with a cheap '6LED' camera.",
            },
            {
                "key": "dashcam_lens",
                "title": "Dashcam Lens",
                "description": "The lens that comes with the camera of a cheap dashcam e.g. the RangeTour B90 (though it may be sold under different names).",
            },
            #{
            #    "key": "rms_f40d16",
            #    "title": "RMS F40D16",
            #    "description": "An RMS-threaded microscope objective with 160mm tube length, and a 16mm diameter, 40mm focal length lens (no longer recommended due to poor quality at the edges of the image)",
            #},
        ],
    },
    {
        "key": "camera",
        "default": "picamera_2",
        "description": "The type of camera to use with your microscope.",
        "options": [
            {
                "key": "picamera_2",
                "title": "Pi Camera",
                "description": "The Raspberry Pi camera module, version 1 or 2",
            },
            #{
            #    "key": "logitech_c270",
            #    "title": "Logitech C270",
            #    "description": "The Logitech C270 webcam",
            #},
            {"key": "m12", "title": "M12 Camera", "description": "A M12 CCTV camera"},
            {
                "key": "6ledcam",
                "title": "6LED",
                "description": "A cheap USB '6 LED' Webcam",
            },
            {
                "key": "dashcam",
                "title": "Dashcam",
                "description": "A cheap dash cam where a screen and camera are sold as one , e.g. RangeTour B90s (it may be sold under different names as well)",
            },
        ],
    },
    {
        "key": "motorised",
        "default": True,
        "description": "Use unipolar stepper motors and a motor controller PCB to move the stage. The alternative is to use hand-actuated thumbwheels.",
    },
    {
        "key": "motor_driver_electronics",
        "default": "sangaboard",
        "description": "The type of electronics used to drive the motors",
        "options": [
            {
                "key": "sangaboard",
                "title": "Sangaboard",
                "description": "A v0.3 Sangaboard. (Custom board)",
            },
            {
                "key": "arduino_nano",
                "title": "Ardunio Nano",
                "description": "Homemade driver using Arduino Nano and the driver boards that come with the motors.",
            },
        ]
    },
    {
        "key": "slide_riser",
        "default": False,
        "advanced": True,
        "description": "Also include slide riser an alternative to the standard sample clips.",
    },
    {
        "key": "reflection_illumination",
        "default": False,
        "advanced": True,
        "description": "Enable the microscope modifications required for reflection illumination and fluorescence microscopy.",
    },
    {
        "key": "pi_in_base",
        "default": True,
        "advanced": True,
        "description": "Whether you'd like to house a Raspberry Pi in the bucket base.",
    },
    {
        "key": "include_actuator_drilling_jig",
        "description": "This part is very much optional, and is only useful for cleaning up slightly dodgy prints, if the 3mm hole in the actuator has printed too small.",
        "advanced": True,
        "default": False,
    },
    {
        "key": "use_motor_gears_for_hand_actuation",
        "default": False,
        "advanced": True,
        "description": "Use the normal motor gears instead of the thumbwheels with the hand-actuated version of the microscope.",
    },
    {
        "key": "tall_bucket_base",
        "description": "The tall bucket base is only needed if using the and infinity corrected RMS objective.",
        "advanced": True,
        "default": True,
    },
    {
        "key": "include_actuator_tension_band",
        "default": False,
        "advanced": True,
        "description": "Include some bands, to replace the o-rings, that need to be printed in TPU filament.",
    },
    {
        "key": "legacy_picamera_tools",
        "default": False,
        "advanced": True,
        "description": "Include tools for older picameras where the lenses are glued in.",
    },
]

# additional constraints on what is required to build a working microscope
# that are not already expressed through openscad parameters, these are
# used to disable option combinations that result in essential parts
# missing
required_stls = [
    # you need an optics module or a lens spacer, also called mount in some files
    r"^(optics_|lens_spacer|(.*cam_mount_)).*\.stl",
    # you need a main microscope body
    r"^main_body\.stl",
    # you need some feet
    r"^feet.*\.stl",
]
