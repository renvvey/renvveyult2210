import cv2
import numpy as np

from roop.typing import Frame


class Frame_TattooRemover():
    processorname = 'tattoo_remover'
    type = 'frame_enhancer'

    plugin_options: dict = None

    def Initialize(self, plugin_options: dict):
        self.plugin_options = plugin_options

    def Run(self, temp_frame: Frame) -> Frame:
        """
        Attempts to reduce or remove tattoos by detecting high-saturation (colored) areas
        and applying inpainting to fill them with surrounding skin texture.
        Works best when combined with manual masking or on areas with distinct tattoos.
        """
        if temp_frame is None:
            return temp_frame

        # Work on a copy
        frame = temp_frame.copy()

        # Convert to HSV to detect colorful tattoo areas
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        saturation = hsv[:, :, 1]

        # Create mask for likely tattoo areas (high saturation)
        # Tattoos are often more saturated than natural skin
        _, mask = cv2.threshold(saturation, 50, 255, cv2.THRESH_BINARY)

        # Also catch darker tattoos
        value = hsv[:, :, 2]
        _, dark_mask = cv2.threshold(value, 70, 255, cv2.THRESH_BINARY_INV)
        mask = cv2.bitwise_or(mask, dark_mask)

        # Dilate to cover the full tattoo area + some blending
        kernel = cv2.getStructuringKernel(cv2.MORPH_ELLIPSE, (11, 11))
        mask = cv2.dilate(mask, kernel, iterations=3)

        # Stronger inpaint for better tattoo removal
        result = cv2.inpaint(frame, mask, 7, cv2.INPAINT_TELEA)

        # Light additional smoothing on the result to blend better
        result = cv2.bilateralFilter(result, 5, 50, 50)

        return result

    def Release(self):
        pass