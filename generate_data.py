import json
import numpy as np

def generate():
    print("🛠️ Generating nested history student data...")
    # 30% are locals (150 students)
    # 1/3 are Non-Veg, 2/3 are Veg
    
    with open('student_data.json', 'w') as f:
        f.write("[\n")
        for i in range(2000):
            diet = "Non-Veg" if i % 3 == 0 else "Veg"
            is_local = 1 if i < 150 else 0
            
            # Create 30 days, each with 4 meals
            nested_history = []
            for day in range(30):
                day_meals = np.random.choice([0, 1], size=4, p=[0.2, 0.8]).tolist()
                nested_history.append(day_meals)
            
            student_obj = {
                "roll_no": str(20220000 + i), # 8-digit ID
                "diet_plan": diet,
                "is_local": is_local,
                "history": nested_history # [[B,L,S,D], [B,L,S,D] ... x30]
            }
            
            f.write(json.dumps(student_obj))
            if i < 1999:
                f.write(",\n")
        f.write("\n]")
        
    print("✅ student_data.json created with nested [[B,L,S,D]... x30] history.")

if __name__ == "__main__":
    generate()