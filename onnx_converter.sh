source yaml_writer.sh

echo "Welcome to Yolo-ONNX Converter Tool!"
echo "-------------------------------------------"
cat model_types.txt
echo "-------------------------------------------"

read -p "Enter the name of your model you are working on(Enter number) : " model_type
echo "-------------------------------------------"
cat model_frameworks.txt
echo "-------------------------------------------"

read -p "Which framework have you trained your model with?(Enter number) : " model_framework
echo "- ------------------------------------------"

if [ "$model_framework" == "1" ]
then
	read -p "Enter your data.yaml path : " data_yaml
	echo "- ------------------------------------------"
	eval $(parse_yaml $data_yaml)
else
	read -p "Enter your model config file: " data_cfg
	echo "- ------------------------------------------"
	eval $(parse_yaml $data_cfg)
fi
read -p "Enter your model_config.yaml path : " config_yaml
echo "- ------------------------------------------"
echo "Anchors for your model is: $anchors"
echo -e "Labels are $names"
echo "$names" > names.txt
echo "The number of classes in your model is: $nc"
read -p "Did you train your model with default anchors?(y/n) : " default_anchors
echo "-------------------------------------------"
read -p "What is the image size you trained your model on?(Enter just the width or height) : " img_size
echo "-------------------------------------------"
cat model_folder_names.txt
echo "-------------------------------------------"
read -p "Enter a folder name where we'll export your model to. Follow the naming convention <object_class>.<model_type> : " folder_name

if [ "$model_type" == "3" ]
then 
	echo "Please give us a moment as we are download the required version of onnx required for yolov3......."
	pip install onnx==1.4.1
	read -p "Enter your model_weights path without the extension:(Make sure the model config and names file have the same name) : " weights
else
	echo "Please give us a moment as we are download the required version of onnx required for your model......."
	pip install onnx==1.8.0
	read -p "Enter your model weights path : " weights
fi	

if [ "$model_type" == "1" ]
then
	echo "v7 here we come"
	mkdir $folder_name && mkdir $folder_name/onnx && mkdir $folder_name/onnx/v1
	cd yolov7
	echo "Running this command: python export.py --weights "../"$weights --grid --include-nms --dynamic-batch --img-size $img_size"
	python export.py --weights "../"$weights --grid --include-nms --dynamic-batch --img-size $img_size
	onnx_model_name="${weights:0:-3}"".onnx"
	mv "../"$onnx_model_name "../"$folder_name/onnx/v1/
	cp "../boilerplate_json/yolov7_spec.json" "../"$folder_name/onnx/v1/
	cd "../"$folder_name/onnx/v1
	echo "Done! The following folder has been created for you: $folder_name. Kindly edit the labels and model path in you spec.json as per your project"

elif [ "$model_type" == "2" ]
then
	echo "v5 here we come"
	cd yolov5
	python export.py --weights "../"$weights --include 'onnx' --dynamic --img-size $img_size
	
else
	echo "v3 here we come"
	cd yolov3
	python yolo_to_onnx.py -m "../"$weights 
fi
