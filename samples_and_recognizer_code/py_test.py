import cv2
import numpy as np
import time
import os
import subprocess

# Load HAAR face classifier
face_classifier = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

# Load the pre-trained model
recognizer = cv2.face.LBPHFaceRecognizer_create()
recognizer.read('trainer.xml')

def face_detector(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = face_classifier.detectMultiScale(gray, 1.3, 5)
    
    if len(faces) == 0:
        return img, None
    
    for (x, y, w, h) in faces:
        cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 255), 2)
        roi = img[y:y + h, x:x + w]
        roi = cv2.resize(roi, (200, 200))
        break
    
    return img, roi

def run_terraform_apply():
    try:
        # Initialize 
        subprocess.run(["terraform", "init"], check=True)

        # Plan 
        subprocess.run(["terraform", "plan"], check=True)

        # Apply
        subprocess.run(["terraform", "apply", "-auto-approve"], check=True)

        print("Terraform applied successfully.")

    except subprocess.CalledProcessError as e:
        print(f"An error occurred: {e}")



cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    
    if not ret:
        print("Failed to capture image")
        break
    
    image, face = face_detector(frame)
    
    try:
        if face is not None:
            face = cv2.cvtColor(face, cv2.COLOR_BGR2GRAY)
            results = recognizer.predict(face)
            
            if results[1] < 500:
                confidence = int(100 * (1 - (results[1]) / 400))
                display_string = f'{confidence}% Confident it is User'
                
                if confidence > 85:
                    cv2.putText(image, "Face Unlocked", (250, 450), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 255, 0), 2)
                    cv2.imshow('Face Recognition', image)
                    cv2.imwrite('recognized_face.jpg', image)

                    # Open webcam for 1 seconds
                    time.sleep(1)
                    print("Face Unlocked")

                    run_terraform_apply()

                    break
                else:
                    cv2.putText(image, "Unknown Face", (250, 450), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255), 2)
                    cv2.imshow('Face Recognition', image)
                    cv2.imwrite('unknown_face.jpg', image)
                    time.sleep(1) 
                    print("Face Unknown")


            else:
                cv2.putText(image, "Unknown Face", (250, 450), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255), 2)
                cv2.imshow('Face Recognition', image)
                

        else:
            time.sleep(2)

            cv2.putText(image, "No Face Found", (220, 120), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255), 2)
            cv2.imshow('Face Recognition', image)
            cv2.imwrite('notrecognized_face.jpg', image)

            

    except Exception as e:
        print(f"Error: {e}")
        cv2.putText(image, "Error in processing", (220, 120), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255), 2)
        cv2.imshow('Face Recognition', image)
        

   

cap.release()
cv2.destroyAllWindows()
