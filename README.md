# yolo-to-onnx

This is an awiros utility to convert all your yolo models into the common onnx format.

Steps:

    1. Create a docker container with the following docker image: nvcr.io/nvidia/pytorch:21.08-py3
    2. In your workspace, clone this repo using git clone https://bitbucket.org/nachiketa1999/yolo-to-onnx
    3. Install dependencies using pip install -r requirements.txt
    4. Run the onnx-converter.sh script
    5. Enter your model information as and when prompted by the onnx_converter script
