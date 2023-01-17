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
	read -p "Good choice with selecting Pytorch framework! Enter your data.yaml file path(contains class names,etc): " data_yaml
	echo "--------------------------------------------------------------------------------"
fi 

read -p "What is the image size you trained your model on?(Enter just the width or height) : " img_size
echo "-------------------------------------------"
cat model_folder_names.txt
echo "-------------------------------------------"
read -p "Enter a folder name where we'll export your model. Follow the above naming convention : " folder_name

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
	python ../yaml_reader.py $model_type $img_size $folder_name $onnx_model_name $data_yaml
	#$cp "../boilerplate_json/yolov7_spec.json" "../"$folder_name/onnx/v1/
	cd "../"$folder_name/onnx/v1
	echo "Done! The following folder has been created for you: $folder_name. You can transfer this awiros alexandria folder and start using it!"

elif [ "$model_type" == "2" ]
then
	echo "v5 here we come"
	mkdir $folder_name && mkdir $folder_name/onnx && mkdir $folder_name/onnx/v1
	cd yolov5
	python export.py --weights "../"$weights --include 'onnx' --dynamic --img-size $img_size
	onnx_model_name="${weights:0:-3}"".onnx"
	mv "../"$onnx_model_name "../"$folder_name/onnx/v1/
	#cp "../boilerplate_json/yolov5_spec.json" "../"$folder_name/onnx/v1/
	python ../yaml_reader.py $model_type $img_size $folder_name $onnx_model_name $data_yaml
	#cd "../"$folder_name/onnx/v1
	#temp=$(mktemp)
	#jq '. input_data.layers."shape"='"[-1,3,$img_size,$img_size]"'' yolov5_spec.json > "$temp" &&mv "$temp" yolov5_spec.json
	#jq '. "onnx_path"="'"$folder_name/onnx/v1/$onnx_model_name"'"' yolov5_spec.json  > "$temp" &&mv "$temp" yolov5_spec.json
	echo "Done! The following folder has been created for you: $folder_name. You can transfer this awiros alexandria folder and start using it!"
	
else
	echo "v3 here we come"
	mkdir $folder_name && mkdir $folder_name/onnx && mkdir $folder_name/onnx/v1
	cd yolov3
	python yolo_to_onnx.py -m "../"$weights 
	onnx_model_name="$weights"".onnx"
	mv "../"$onnx_model_name "../"$folder_name/onnx/v1/
	python ../yaml_reader.py $model_type $img_size $folder_name $onnx_model_name $onnx_model_name 
	#cp "../boilerplate_json/yolov3_spec.json" "../"$folder_name/onnx/v1/
	#cd "../"$folder_name/onnx/v1
	echo "Done! The following folder has been created for you: $folder_name."
fi
