from deepface import DeepFace
import sys

img_path = sys.argv[1]
demographies = DeepFace.analyze(
	img_path=img_path,
	detector_backend="opencv",
	actions=['age']
)

print(demographies)
