import yaml
import json
import sys

model_type=sys.argv[1]#yolov3,yolov5 or yolov7
img_size=sys.argv[2]#640 or 480 typically
folder_name=sys.argv[3]#folder name where model is exported
onnx_model_name=sys.argv[4]#model_name
data_file="../"+sys.argv[5]#data_file
if model_type=="2":
    spec_path="../boilerplate_json/yolov5_spec.json"
elif model_type=="1":
    spec_path="../boilerplate_json/yolov7_spec.json"
else:
    spec_path="../boilerplate_json/yolov3_spec.json"

with open(spec_path,'r+') as spec:
    data=json.load(spec)
    data["input_data"]["layers"][0]["shape"]=[-1,3,int(img_size),int(img_size)]
    onnx_model=onnx_model_name.split("/")[-1]
    data["onnx_path"]=folder_name+"/onnx/v1/"+onnx_model
    if model_type=="2":
        with open(data_file) as f:
            data_yaml=yaml.safe_load(f)
            labels=list(data_yaml["names"].values())
            #print("Labels are: ", labels)
    elif model_type=="1":
        with open(data_file) as f:
            data_yaml=yaml.safe_load(f)
            labels=data_yaml["names"]
            #print("Labels are: ", labels)
    else:
        names_file= "../"+''.join(onnx_model_name.split(".")[:-1])+".names"
        with open(names_file) as f:
            labels=f.read()
            #print("Labels are: ",labels)
    data["output_data"]["labels"]=labels
    spec.seek(0)
new_path="../"+folder_name+"/onnx/v1/spec.json"
with open(new_path,'w') as f:
    json.dump(data,f,indent=4)
