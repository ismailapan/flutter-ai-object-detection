import torch 
from ultralytics import YOLO

model_path = "runs/detect/fruit_detection/weights/best.pt"
model = YOLO(model_path)

results = model.predict(
    source= "forTest/deneme6.jpg",
    show = False,
    conf = 0.54,
    save = True
)


    
