function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}




echo "Welcome to Yolo-ONNX Converter Tool!"
echo "-------------------------------------------"
cat model_types.txt
echo "-------------------------------------------"
read -p "Enter the name of your model you are working on : " model_type
echo "-------------------------------------------"
read -p "Enter your data.yaml path : " data_yaml
echo "- ------------------------------------------"
eval $(parse_yaml $data_yaml)

echo -e "Labels are $names"
echo "$names" > names.txt
echo "The number of classes in your model is: $nc"
read -p "Did you train your model with default anchors?(y/n) : " default_anchors
echo "-------------------------------------------"
read -p "What are the number of classes in your model?(Give an integer value) : " num_classes
echo "-------------------------------------------"
read -p "What is the image size you trained your model on?(Enter just the width or height) : " img_size
echo "-------------------------------------------"
cat model_folder_names.txt
echo "-------------------------------------------"
read -p "Enter a folder name where we'll export your model to. Follow the below naming convention : " folder_name

if [ "$model_type" == "yolov3" ]
then 
	echo "Please give us a moment as we are download the required version of onnx required for yolov3......."
	pip install onnx==1.4.1
	read -p "Enter your model_weights path without the extension:(Make sure the model config and names file have the same name) : " weights
else
	echo "Please give us a moment as we are download the required version of onnx required for your model......."
	pip install onnx==1.8.0
	read -p "Enter your model weights path : " weights
fi	

if [ "$model_type" == "yolov7" ]
then
	echo "v7 here we come"
	mkdir $folder_name && mkdir $folder_name/onnx && mkdir $folder_name/onnx/v1
	cd yolov7
	echo "Running this command: python export.py --weights "../"$weights --grid --include-nms --dynamic-batch --img-size $img_size"
	python export.py --weights "../"$weights --grid --include-nms --dynamic-batch --img-size $img_size
	$onnx_model_name= $weights | cut -d '.' -f 1 
	mv "../"$onnx_model_name".onnx" "../"$folder_name/onnx/v1/
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
