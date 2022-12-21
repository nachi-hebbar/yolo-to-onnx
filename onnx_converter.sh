echo "Welcome to Yolo-ONNX Converter Tool!"
echo "-------------------------------------------"
cat model_types.txt
echo "-------------------------------------------"
read -p "Enter the name of your model you are working on : " model_type
echo "-------------------------------------------"
read -p "Did you train your model with default anchors?(y/n)" default_anchors
echo "-------------------------------------------"
read -p "What are the number of classes in your model?(Give an integer value)" num_classes
echo "-------------------------------------------"
read -p "What is the image size you trained your model on?(Enter just the width or height)" img_size
if [ "$model_type" == "yolov3" ]
then 
	echo "Please give us a moment as we are download the required version of onnx required for yolov3......."
	pip install onnx==1.4.1
	read -p "Enter your model_weights path without the extension:(Make sure the model config and names file have the same name) " weights
else
	echo "Please give us a moment as we are download the required version of onnx required for your model......."
	pip install onnx==1.8.0
	read -p "Enter your model weights path: " weights
fi	

if [ "$model_type" == "yolov7" ]
then
	echo "v7 here we come"
	cd yolov7
	echo "Running this command: python export.py --weights "../"$weights --grid --include-nms --dynamic-batch --img-size $img_size"
	python export.py --weights "../"$weights --grid --include-nms --dynamic-batch --img-size $img_size
elif [ "$model_type" == "yolov5" ]
then
	echo "v5 here we come"
	cd yolov5
	python export.py --weights "../"$weights --include 'onnx' --dynamic --img-size $img_size

else
	echo "v3 here we come"
	cd yolov3
	python yolo_to_onnx.py -m "../"$weights 
fi
